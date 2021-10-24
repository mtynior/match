//
//  ToBeTruthyTests.swift
//  Match
//
//  Created by Michal on 17/10/2021.
//

import XCTest
@testable import Match

final class ToBeTruthyTests: XCTestCase {
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
            makeMatcher(actualValue: true).evaluate().evaluationStatus,
            .passed,
            "ToBeTruthy should be evaluated as `passed` for a truthy value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: false).evaluate().evaluationStatus,
            .failed,
            "ToBeTruthy should be evaluated as `failed` for a flasy value"
        )
    }
    
    func testNegatedEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: true, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToBeTruthy should be evaluated as `failed` for a truthy value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: false, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToBeTruthy should be evaluated as `passed` for a falsy value"
        )
    }
    
    func testMessages() throws {
        // Failures
        XCTAssertEqual(
            makeMatcher(actualValue: false).evaluate().message,
            "Expected truthy value, but received false"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: true, evaluationType: .negated).evaluate().message,
            "Expected not truthy value, but received true"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(actualValue: true).evaluate().message,
            "Received truthy value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: false, evaluationType: .negated).evaluate().message,
            "Received not truthy value"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toBeTruthy"
       
        // when
        let actualMatcher = makeMatcher(actualValue: true)
        
        // then
        XCTAssertEqual(actualMatcher.matcherName, expectedResult)
    }
    
    func testReportEvaluationResult() throws {
        // given
        let reportExpectation = expectation(description: "toBeTruthy() should report the evaluation result")
        
        mockedReporter.onReportResult = { _ in
            reportExpectation.fulfill()
        }
       
        // when
        expect("".isEmpty).toBeTruthy()
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToBeTruthyTests {
    func makeMatcher(actualValue: Bool, evaluationType: EvaluationType = .positive) -> ToBeTruthy {
        return ToBeTruthy(
            expectation: MockedData.mockedExpectation(value: actualValue, evaluationType: evaluationType),
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
