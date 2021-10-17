//
//  ToBeEmptyTests.swift
//  Match
//
//  Created by Michal on 17/10/2021.
//

import XCTest
@testable import Match

final class ToBeEmptyTests: XCTestCase {
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
            makeMatcher(actualValue: "").evaluate().evaluationStatus,
            .passed,
            "ToBeEmpty should be evaluated as `passed` for an empty String"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Darth Vader").evaluate().evaluationStatus,
            .failed,
            "ToBeEmpty should be evaluated as `failed` for a non empty String"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: [Int]()).evaluate().evaluationStatus,
            .passed,
            "ToBeEmpty should be evaluated as `passed` for an empty Array"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: [1, 2, 3]).evaluate().evaluationStatus,
            .failed,
            "ToBeEmpty should be evaluated as `failed` for a non empty Array"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: Set<Int>()).evaluate().evaluationStatus,
            .passed,
            "ToBeEmpty should be evaluated as `passed` for an empty Set"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: Set<Int>([1, 2, 3])).evaluate().evaluationStatus,
            .failed,
            "ToBeEmpty should be evaluated as `failed` for a non empty Set"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: [String: Int]()).evaluate().evaluationStatus,
            .passed,
            "ToBeEmpty should be evaluated as `passed` for an empty Dictionary"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: ["1": 1, "2": 2]).evaluate().evaluationStatus,
            .failed,
            "ToBeEmpty should be evaluated as `failed` for a non empty Dictionary"
        )
    }
    
    func testNegatedEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: "", evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "ToBeEmpty should be evaluated as `failed` for an empty String"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Darth Vader", evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "ToBeEmpty should be evaluated as `passed` for a non empty String"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: [Int](), evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "ToBeEmpty should be evaluated as `failed` for an empty Array"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: [1, 2, 3], evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "ToBeEmpty should be evaluated as `passed` for a non empty Array"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: Set<Int>(), evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "ToBeEmpty should be evaluated as `failed` for an empty Set"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: Set<Int>([1, 2, 3]), evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "ToBeEmpty should be evaluated as `passed` for a non empty Set"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: [String: Int](), evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "ToBeEmpty should be evaluated as `failed` for an empty Dictionary"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: ["1": 1, "2": 2], evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "ToBeEmpty should be evaluated as `passed` for a non empty Dictionary"
        )
    }
    
    func testMessages() throws {
        // Failures
        XCTAssertEqual(
            makeMatcher(actualValue: [1, 2, 3]).evaluate().message,
            "Expected empty value, but received 3 elements"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: [Int](), evaluationType: .negated).evaluate().message,
            "Expected not empty value, but received 0 elements"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(actualValue: [Int]()).evaluate().message,
            "Expected collection is empty"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: [1, 2, 3, 4], evaluationType: .negated).evaluate().message,
            "Expected collection is not empty and has 4 elements"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toBeEmpty"
       
        // when
        let actualMatcher = makeMatcher(actualValue: "Luke Skywalker")
        
        // then
        XCTAssertEqual(actualMatcher.matcherName, expectedResult)
    }
    
    func testReportEvaluationResult() throws {
        // given
        let reportExpectation = expectation(description: "toBeEmpty() should report the evaluation result")
        
        mockedReporter.onReportResult = { _ in
            reportExpectation.fulfill()
        }
       
        // when
        expect([1, 2, 3]).toBeEmpty()
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToBeEmptyTests {
    func makeMatcher<T: Collection>(actualValue: T, evaluationType: EvaluationType = .positive) -> ToBeEmpty<T> {
        return ToBeEmpty(
            expectation: MockedData.mockedExpectation(value: actualValue, evaluationType: evaluationType),
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
