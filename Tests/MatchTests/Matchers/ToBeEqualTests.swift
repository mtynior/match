//
//  ToBeEqualTests.swift
//  Match
//
//  Created by Michal on 17/10/2021.
//

import XCTest
@testable import Match

final class ToBeEqualTests: XCTestCase {
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
            makeMatcher(actualValue: 0, expectedValue: 0).evaluate().evaluationStatus,
            .passed,
            "ToBeEqual should be evaluated as `passed` for equal values"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 0, expectedValue: 16).evaluate().evaluationStatus,
            .failed,
            "ToBeEqual should be evaluated as `failed` for not equal values"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: [1, 2, 3], expectedValue: [1, 2, 3]).evaluate().evaluationStatus,
            .passed,
            "ToBeEqual should be evaluated as `passed` for equal Arrays"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: [1, 2, 3], expectedValue: [3, 2, 1]).evaluate().evaluationStatus,
            .failed,
            "ToBeEqual should be evaluated as `failed` for not equal Arrays"
        )
    }
    
    func testNegatedEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: 0, expectedValue: 0, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToBeEqual should be evaluated as `failed` for equal values"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 0, expectedValue: 16, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToBeEqual should be evaluated as `passed` for not equal values"
        )
    }
    
    func testMessages() throws {
        // Failures
        XCTAssertEqual(
            makeMatcher(actualValue: 2, expectedValue: 10).evaluate().message,
            "Expected: 10 to be equal to received: 2"
        )
                
        XCTAssertEqual(
            makeMatcher(actualValue: 7, expectedValue: 7, evaluationType: .negated).evaluate().message,
            "Expected: 7 not to be equal to received: 7"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(actualValue: 3, expectedValue: 3).evaluate().message,
            "Expected: 3 is equal to received: 3"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 7, expectedValue: 10, evaluationType: .negated).evaluate().message,
            "Expected: 10 is not equal to received: 7"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toBeEqual"
       
        // when
        let actualMatcher = makeMatcher(actualValue: 2, expectedValue: 4)
        
        // then
        XCTAssertEqual(actualMatcher.matcherName, expectedResult)
    }
    
    func testReportEvaluationResult() throws {
        // given
        let reportExpectation = expectation(description: "toBeEqual() should report the evaluation result")
        
        mockedReporter.onReportResult = { _ in
            reportExpectation.fulfill()
        }
       
        // when
        expect(3).toBeEqual(6)
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToBeEqualTests {
    func makeMatcher<T: Equatable>(actualValue: T, expectedValue: T, evaluationType: EvaluationType = .positive) -> ToBeEqual<T> {
        return ToBeEqual(
            expectation: MockedData.mockedExpectation(value: actualValue, evaluationType: evaluationType),
            expectedValue: expectedValue,
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
