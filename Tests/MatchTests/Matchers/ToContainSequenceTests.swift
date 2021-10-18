//
//  ToContainSequenceTests.swift
//  Match
//
//  Created by Michal on 18/10/2021.
//

import XCTest
@testable import Match

final class ToContainSequenceTests: XCTestCase {
    var mockedReporter: MockedReporter!
    
    override func setUpWithError() throws {
        mockedReporter = MockedReporter()
        Environment.global.resultReporter = mockedReporter
    }

    override func tearDownWithError() throws {
        mockedReporter = nil
    }

    func testPositiveEvaluation() throws {
        let sequence = [1, 2, 3, 4, 5]
        
        XCTAssertEqual(
            makeMatcher(actualValue: sequence, expectedValues: [1]).evaluate().evaluationStatus,
            .passed,
            "ToContainSequence should be evaluated as `passed` when a Sequence contains a value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: sequence, expectedValues: [10]).evaluate().evaluationStatus,
            .failed,
            "ToContainSequence should be evaluated as `failed` when a Sequence contains a value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: sequence, expectedValues: [3, 5]).evaluate().evaluationStatus,
            .passed,
            "ToContainSequence should be evaluated as `passed` when a Sequence contains all expected values"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: sequence, expectedValues: [3, 11]).evaluate().evaluationStatus,
            .failed,
            "ToContainSequence should be evaluated as `failed` when a Sequence does not contain all expected values"
        )
    }
    
    func testNegatedEvaluation() throws {
        let sequence = [1, 2, 3, 4, 5]
        
        XCTAssertEqual(
            makeMatcher(actualValue: sequence, expectedValues: [1], evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToContainSequence should be evaluated as `failed` when a Sequence contains a value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: sequence, expectedValues: [10], evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToContainSequence should be evaluated as `passed` when a Sequence contains a value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: sequence, expectedValues: [3, 5], evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToContainSequence should be evaluated as `failed` when a Sequence contains all expected values"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: sequence, expectedValues: [3, 11], evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToContainSequence should be evaluated as `passed` when a Sequence does not contain all expected values"
        )
    }
        
    func testMessages() throws {
        let sequence = [1, 2, 3, 4, 5]
        
        // Failures
        XCTAssertEqual(
            makeMatcher(actualValue: sequence, expectedValues: [3, 9]).evaluate().message,
            "Expected the: [1, 2, 3, 4, 5] to contain: [3, 9], but it does not"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: sequence, expectedValues: [2, 3], evaluationType: .negated).evaluate().message,
            "Expected the: [1, 2, 3, 4, 5] not to contain: [2, 3], but it does"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(actualValue: sequence, expectedValues: [2, 4]).evaluate().message,
            "Received: [1, 2, 3, 4, 5] does contain: [2, 4]"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: sequence, expectedValues: [3, 9], evaluationType: .negated).evaluate().message,
            "Received: [1, 2, 3, 4, 5] does not contain: [3, 9]"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toContain"
       
        // when
        let actualMatcher = makeMatcher(actualValue: [0, 1, 2], expectedValues: [1, 5])
        
        // then
        XCTAssertEqual(actualMatcher.matcherName, expectedResult)
    }
    
    func testReportEvaluationResult() throws {
        // given
        let reportExpectation = expectation(description: "toContain() should report the evaluation result")
        
        mockedReporter.onReportResult = { _ in
            reportExpectation.fulfill()
        }
       
        // when
        expect([0, 1, 2]).toContain(3)
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToContainSequenceTests {
    func makeMatcher<T: Sequence>(actualValue: T, expectedValues: [T.Element], evaluationType: EvaluationType = .positive) -> ToContainSequence<T> {
        return ToContainSequence(
            expectation: MockedData.mockedExpectation(value: actualValue, evaluationType: evaluationType),
            expectedValues: expectedValues,
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
