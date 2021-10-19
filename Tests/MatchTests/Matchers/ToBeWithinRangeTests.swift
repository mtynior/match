//
//  ToBeWithinRangeTests.swift
//  Match
//
//  Created by Michal on 19/10/2021.
//

import XCTest
@testable import Match

final class ToBeWithinRangeTests: XCTestCase {
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
            makeMatcher(actualValue: 4, range: 0..<10).evaluate().evaluationStatus,
            .passed,
            "ToBeWithinRange() should be evaluated as `passed` when a value is inside an open range"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 10, range: 0..<10).evaluate().evaluationStatus,
            .failed,
            "ToBeWithinRange() should be evaluated as `failed` when a value is not inside an open range"
        )
    }
    
    func testNegatedEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: 4, range: 0..<10, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToBeWithinRange() should be evaluated as `failed` when a value is inside an open range"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 10, range: 0..<10, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToBeWithinRange() should be evaluated as `passed` when a value is not inside an open range"
        )
    }
    
    func testMessages() throws {
        // Failures
        XCTAssertEqual(
            makeMatcher(actualValue: 11, range: 0..<10).evaluate().message,
            "Expected to be within (0..<10), but received: 11 is not"
        )
                
        XCTAssertEqual(
            makeMatcher(actualValue: 7, range: 0..<10, evaluationType: .negated).evaluate().message,
            "Expected not to be within (0..<10), but received: 7 is"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(actualValue: 4, range: 0..<10).evaluate().message,
            "Actual value: 4 is within range: (0..<10)"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 19, range: 0..<10, evaluationType: .negated).evaluate().message,
            "Actual value: 19 is not within range: (0..<10)"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toBeWithin"
       
        // when
        let actualMatcher = makeMatcher(actualValue: 12, range: 0..<10)
        
        // then
        XCTAssertEqual(actualMatcher.matcherName, expectedResult)
    }
    
    func testReportEvaluationResult() throws {
        // given
        let reportExpectation = expectation(description: "toBeWithin() should report the evaluation result")
        
        mockedReporter.onReportResult = { _ in
            reportExpectation.fulfill()
        }
       
        // when
        expect(15).toBeWithin(0..<10)
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToBeWithinRangeTests {
    func makeMatcher<T: Comparable>(actualValue: T, range: Range<T>, evaluationType: EvaluationType = .positive) -> ToBeWithinRange<T> {
        return ToBeWithinRange(
            expectation: MockedData.mockedExpectation(value: actualValue, evaluationType: evaluationType),
            expectedRange: range,
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
