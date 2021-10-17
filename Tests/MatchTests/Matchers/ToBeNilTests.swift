//
//  ToBeNilTests.swift
//  Match
//
//  Created by Michal on 17/10/2021.
//

import XCTest
@testable import Match

final class ToBeNilTests: XCTestCase {
    var mockedReporter: MockedReporter!
    
    let nilValue: String? = nil
    
    override func setUpWithError() throws {
        mockedReporter = MockedReporter()
        Environment.global.resultReporter = mockedReporter
    }

    override func tearDownWithError() throws {
        mockedReporter = nil
    }

    func testPositiveEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: nilValue).evaluate().evaluationStatus,
            .passed,
            "ToBeNil should be evaluated as `passed` for a nil value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Poe Dameron").evaluate().evaluationStatus,
            .failed,
            "ToBeNil should be evaluated as `failed` for a non nil value"
        )
    }
    
    func testNegatedEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: nilValue, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToBeNil should be evaluated as `failed` for a nil value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Fin", evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToBeNil should be evaluated as `passed` for a non nil value"
        )
    }
    
    func testMessages() throws {
        // Failures
        XCTAssertEqual(
            makeMatcher(actualValue: "Vader").evaluate().message,
            "Expected nil value, but received: Vader"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: nilValue, evaluationType: .negated).evaluate().message,
            "Expected not nil value, but received: nil"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(actualValue: nilValue).evaluate().message,
            "Received value is nil"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Kylo Ren", evaluationType: .negated).evaluate().message,
            "Received value is not nil"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toBeNil"
       
        // when
        let actualMatcher = makeMatcher(actualValue: true)
        
        // then
        XCTAssertEqual(actualMatcher.matcherName, expectedResult)
    }
    
    func testReportEvaluationResult() throws {
        // given
        let reportExpectation = expectation(description: "toBeNil() should report the evaluation result")
        
        mockedReporter.onReportResult = { _ in
            reportExpectation.fulfill()
        }
       
        // when
        expect("Palpatine").toBeNil()
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToBeNilTests {
    func makeMatcher<T>(actualValue: T, evaluationType: EvaluationType = .positive) -> ToBeNil<T> {
        return ToBeNil(
            expectation: MockedData.mockedExpectation(value: actualValue, evaluationType: evaluationType),
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
