//
//  ToHaveCountTests.swift
//  Match
//
//  Created by Michal on 17/10/2021.
//

import XCTest
@testable import Match

// swiftlint:disable function_body_length
final class ToHaveCountTests: XCTestCase {
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
            makeMatcher(actualValue: "", expectedCount: 0).evaluate().evaluationStatus,
            .passed,
            "ToHaveCount should be evaluated as `passed` for an empty String"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Mace", expectedCount: 4).evaluate().evaluationStatus,
            .passed,
            "ToHaveCount should be evaluated as `passed` when a String has the expected length"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Kenobi", expectedCount: 3).evaluate().evaluationStatus,
            .failed,
            "ToHaveCount should be evaluated as `failed` when a String does not have the expected length"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: [Int](), expectedCount: 0).evaluate().evaluationStatus,
            .passed,
            "ToHaveCount should be evaluated as `passed` for empty Array"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: [1, 2, 3], expectedCount: 3).evaluate().evaluationStatus,
            .passed,
            "ToHaveCount should be evaluated as `passed` when an Array has expected number of items"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: [1, 2, 3], expectedCount: 10).evaluate().evaluationStatus,
            .failed,
            "ToHaveCount should be evaluated as `failed` when an Array does not have expected number of items"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: Set<Int>(), expectedCount: 0).evaluate().evaluationStatus,
            .passed,
            "ToHaveCount should be evaluated as `passed` for an empty Set"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: Set([1, 2, 3]), expectedCount: 3).evaluate().evaluationStatus,
            .passed,
            "ToHaveCount should be evaluated as `passed` when a Set has expected number of items"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: Set([1, 2, 3]), expectedCount: 10).evaluate().evaluationStatus,
            .failed,
            "ToHaveCount should be evaluated as `failed` when a Set does not have expected number of items"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: [String: Int](), expectedCount: 0).evaluate().evaluationStatus,
            .passed,
            "ToHaveCount should be evaluated as `passed` for an empty Dictionary"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: ["1": 1, "2": 2], expectedCount: 2).evaluate().evaluationStatus,
            .passed,
            "ToHaveCount should be evaluated as `passed` when a Dictionary has expected number of items"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: ["1": 1, "2": 2], expectedCount: 5).evaluate().evaluationStatus,
            .failed,
            "ToHaveCount should be evaluated as `failed` when a Dictionary does not have expected number of items"
        )
    }
    
    func testNegatedEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: "", expectedCount: 0, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToHaveCount should be evaluated as `failed` for an empty String"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Mace", expectedCount: 4, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToHaveCount should be evaluated as `failed` when a String has the expected length"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Kenobi", expectedCount: 3, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToHaveCount should be evaluated as `passed` when a String does not have the expected length"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: [Int](), expectedCount: 0, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToHaveCount should be evaluated as `failed` for empty Array"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: [1, 2, 3], expectedCount: 3, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToHaveCount should be evaluated as `failed` when an Array has expected number of items"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: [1, 2, 3], expectedCount: 10, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToHaveCount should be evaluated as `passed` when an Array does not have expected number of items"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: Set<Int>(), expectedCount: 0, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToHaveCount should be evaluated as `failed` for an empty Set"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: Set([1, 2, 3]), expectedCount: 3, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToHaveCount should be evaluated as `failed` when a Set has expected number of items"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: Set([1, 2, 3]), expectedCount: 10, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToHaveCount should be evaluated as `passed` when a Set does not have expected number of items"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: [String: Int](), expectedCount: 0, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToHaveCount should be evaluated as `failed` for an empty Dictionary"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: ["1": 1, "2": 2], expectedCount: 2, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToHaveCount should be evaluated as `failed` when a Dictionary has expected number of items"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: ["1": 1, "2": 2], expectedCount: 5, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToHaveCount should be evaluated as `passed` when a Dictionary does not have expected number of items"
        )
    }
    
    func testMessages() throws {
        // Failures
        XCTAssertEqual(
            makeMatcher(actualValue: "Jedi", expectedCount: 8).evaluate().message,
            "Expected to have count of: 8, but received: 4"
        )
                
        XCTAssertEqual(
            makeMatcher(actualValue: "Jedi", expectedCount: 4, evaluationType: .negated).evaluate().message,
            "Expected to not have count of: 4, but received: 4"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(actualValue: "Sith", expectedCount: 4).evaluate().message,
            "Does have count of: 4"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Sith", expectedCount: 2, evaluationType: .negated).evaluate().message,
            "Does not have count of: 2"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toHaveCount"
       
        // when
        let actualMatcher = makeMatcher(actualValue: "Anakin", expectedCount: 3)
        
        // then
        XCTAssertEqual(actualMatcher.matcherName, expectedResult)
    }
    
    func testReportEvaluationResult() throws {
        // given
        let reportExpectation = expectation(description: "toHaveCount() should report the evaluation result")
        
        mockedReporter.onReportResult = { _ in
            reportExpectation.fulfill()
        }
       
        // when
        expect("Jedi").toHaveCount(3)
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToHaveCountTests {
    func makeMatcher<T: Collection>(actualValue: T, expectedCount: Int, evaluationType: EvaluationType = .positive) -> ToHaveCount<T> {
        return ToHaveCount(
            expectation: MockedData.mockedExpectation(value: actualValue, evaluationType: evaluationType),
            expectedCount: expectedCount,
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
