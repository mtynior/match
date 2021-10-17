//
//  ToBeGreaterThanOrEqualToTests.swift
//  Match
//
//  Created by Michal on 17/10/2021.
//

import XCTest
@testable import Match

final class ToBeGreaterThanOrEqualToTests: XCTestCase {
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
            makeMatcher(actualValue: 2, expectedValue: 1).evaluate().evaluationStatus,
            .passed,
            "ToBeGreaterThanOrEqualTo should be evaluated as `passed` when actual value is greater than expected value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 1, expectedValue: 2).evaluate().evaluationStatus,
            .failed,
            "ToBeGreaterThanOrEqualTo should be evaluated as `failed`  when actual value is less than expected value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 1, expectedValue: 1).evaluate().evaluationStatus,
            .passed,
            "ToBeGreaterThanOrEqualTo should be evaluated as `passed` when actual value is equal to expected value"
        )
    }
    
    func testNegatedEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: 2, expectedValue: 1, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToBeGreaterThanOrEqualTo should be evaluated as `failed` when actual value is greater than expected value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 1, expectedValue: 2, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToBeGreaterThanOrEqualTo should be evaluated as `passed`  when actual value is less than expected value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 1, expectedValue: 1, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToBeGreaterThanOrEqualTo should be evaluated as `failed` when actual value is equal to expected value"
        )
    }
    
    func testMessages() throws {
        // Failures
        XCTAssertEqual(
            makeMatcher(actualValue: 10, expectedValue: 21).evaluate().message,
            "Expected the received value: 10 to be greater than or equal to: 21, but it was not"
        )
                
        XCTAssertEqual(
            makeMatcher(actualValue: 21, expectedValue: 10, evaluationType: .negated).evaluate().message,
            "Expected the received value: 21 not to be greater than or equal to: 10, but it was"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(actualValue: 21, expectedValue: 10).evaluate().message,
            "Received: 21 is greater than or equal to: 10"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 7, expectedValue: 10, evaluationType: .negated).evaluate().message,
            "Received: 7 is not greater than or equal to: 10"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toBeGreaterThanOrEqualTo"
       
        // when
        let actualMatcher = makeMatcher(actualValue: 20, expectedValue: 25)
        
        // then
        XCTAssertEqual(actualMatcher.matcherName, expectedResult)
    }
    
    func testReportEvaluationResult() throws {
        // given
        let reportExpectation = expectation(description: "toBeGreaterThanOrEqualTo() should report the evaluation result")
        
        mockedReporter.onReportResult = { _ in
            reportExpectation.fulfill()
        }
       
        // when
        expect(3.14).toBeGreaterThanOrEqualTo(1.43)
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToBeGreaterThanOrEqualToTests {
    func makeMatcher<T: Comparable>(actualValue: T, expectedValue: T, evaluationType: EvaluationType = .positive) -> ToBeGreaterThanOrEqualTo<T> {
        return ToBeGreaterThanOrEqualTo(
            expectation: MockedData.mockedExpectation(value: actualValue, evaluationType: evaluationType),
            expectedValue: expectedValue,
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
