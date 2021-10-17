//
//  ToBeFalsyTests.swift
//  Match
//
//  Created by Michal on 17/10/2021.
//

import XCTest
@testable import Match

final class ToBeFalsyTests: XCTestCase {
    var mockedReporter: MockedReporter!
    
    override func setUpWithError() throws {
        mockedReporter = MockedReporter()
        Environment.global.resultReporter = mockedReporter
    }

    override func tearDownWithError() throws {
        mockedReporter = nil
    }

    func testPositiveEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: false).evaluate().evaluationStatus,
            .passed,
            "ToBeFalsy should be evaluated as `passed` for a falsy value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: true).evaluate().evaluationStatus,
            .failed,
            "ToBeFalsy should be evaluated as `failed` for a truthy value"
        )
    }
    
    func testNegatedEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: false, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToBeFalsy should be evaluated as `failed` for a falsy value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: true, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToBeFalsy should be evaluated as `passed` for a truthy value"
        )
    }
    
    func testMessages() throws {
        // Failures
        XCTAssertEqual(
            makeMatcher(actualValue: true).evaluate().message,
            "Expected falsy value, but received true"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: false, evaluationType: .negated).evaluate().message,
            "Expected not falsy value, but received false"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(actualValue: false).evaluate().message,
            "Received falsy value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: true, evaluationType: .negated).evaluate().message,
            "Received not falsy value"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toBeFalsy"
       
        // when
        let actualMatcher = makeMatcher(actualValue: true)
        
        // then
        XCTAssertEqual(actualMatcher.matcherName, expectedResult)
    }
    
    func testReportEvaluationResult() throws {
        // given
        let reportExpectation = expectation(description: "toBeFalsy() should report the evaluation result")
        
        mockedReporter.onReportResult = { _ in
            reportExpectation.fulfill()
        }
       
        // when
        expect("".isEmpty).toBeFalsy()
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToBeFalsyTests {
    func makeMatcher(actualValue: Bool, evaluationType: EvaluationType = .positive) -> ToBeFalsy {
        return ToBeFalsy(
            expectation: MockedData.mockedExpectation(value: actualValue, evaluationType: evaluationType),
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
