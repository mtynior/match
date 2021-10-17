//
//  ToBeLessThanTests.swift
//  Match
//
//  Created by Michal on 17/10/2021.
//

import XCTest
@testable import Match

final class ToBeLessThanTests: XCTestCase {
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
            makeMatcher(actualValue: 1, expectedValue: 2).evaluate().evaluationStatus,
            .passed,
            "ToBeLessThan should be evaluated as `passed` when actual value is less than expected value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 2, expectedValue: 1).evaluate().evaluationStatus,
            .failed,
            "ToBeLessThan should be evaluated as `failed`  when actual value is less than expected value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 1, expectedValue: 1).evaluate().evaluationStatus,
            .failed,
            "ToBeLessThan should be evaluated as `failed` when actual value is equal to expected value"
        )
    }
    
    func testNegatedEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: 1, expectedValue: 2, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToBeLessThan should be evaluated as `failed` when actual value is less than expected value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 2, expectedValue: 1, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToBeLessThan should be evaluated as `passed`  when actual value is less than expected value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 1, expectedValue: 1, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToBeLessThan should be evaluated as `passed` when actual value is equal to expected value"
        )
    }
    
    func testMessages() throws {
        // Failures
        XCTAssertEqual(
            makeMatcher(actualValue: 21, expectedValue: 10).evaluate().message,
            "Expected the received value: 21 to be less than: 10, but it was not"
        )
                
        XCTAssertEqual(
            makeMatcher(actualValue: 10, expectedValue: 21, evaluationType: .negated).evaluate().message,
            "Expected the received value: 10 not to be less than: 21, but it was"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(actualValue: 10, expectedValue: 21).evaluate().message,
            "Received: 10 is less than: 21"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 13, expectedValue: 9, evaluationType: .negated).evaluate().message,
            "Received: 13 is not less than: 9"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toBeLessThan"
       
        // when
        let actualMatcher = makeMatcher(actualValue: 25, expectedValue: 8)
        
        // then
        XCTAssertEqual(actualMatcher.matcherName, expectedResult)
    }
    
    func testReportEvaluationResult() throws {
        // given
        let reportExpectation = expectation(description: "toBeLessThan() should report the evaluation result")
        
        mockedReporter.onReportResult = { _ in
            reportExpectation.fulfill()
        }
       
        // when
        expect(1.33).toBeLessThan(3.14)
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToBeLessThanTests {
    func makeMatcher<T: Comparable>(actualValue: T, expectedValue: T, evaluationType: EvaluationType = .positive) -> ToBeLessThan<T> {
        return ToBeLessThan(
            expectation: MockedData.mockedExpectation(value: actualValue, evaluationType: evaluationType),
            expectedValue: expectedValue,
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
