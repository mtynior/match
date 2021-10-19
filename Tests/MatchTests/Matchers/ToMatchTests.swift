//
//  ToMatchTests.swift
//  Match
//
//  Created by Michal on 19/10/2021.
//

import XCTest
@testable import Match

final class ToMatchTests: XCTestCase {
    var mockedReporter: MockedReporter!
    let onlyDigitsRegex = #"^[0-9]*$"#
    
    override func setUpWithError() throws {
        mockedReporter = MockedReporter()
        Environment.global.resultReporter = mockedReporter
    }

    override func tearDownWithError() throws {
        mockedReporter = nil
    }

    func testPositiveEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: "12345", regex: onlyDigitsRegex).evaluate().evaluationStatus,
            .passed,
            "ToMatch should be evaluated as `passed` when a Regex matches a String"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "h3ll0", regex: onlyDigitsRegex).evaluate().evaluationStatus,
            .failed,
            "ToMatch should be evaluated as `failed` when a Regex does not match a String"
        )
    }
    
    func testNegatedEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: "12345", regex: onlyDigitsRegex, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToMatch should be evaluated as `failed` when a Regex matches a String"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "h3ll0", regex: onlyDigitsRegex, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToMatch should be evaluated as `passed` when a Regex does not match a String"
        )
    }
    
    func testMessages() throws {
        // Failures
        XCTAssertEqual(
            makeMatcher(actualValue: "h3ll0", regex: onlyDigitsRegex).evaluate().message,
            "Expected to match the regex"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "12345", regex: onlyDigitsRegex, evaluationType: .negated).evaluate().message,
            "Expected not to match the regex"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(actualValue: "12345", regex: onlyDigitsRegex).evaluate().message,
            "Received value: 12345 does match the regex"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "h3ll0", regex: onlyDigitsRegex, evaluationType: .negated).evaluate().message,
            "Received value: h3ll0 does not match the regex"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toMatch"
       
        // when
        let actualMatcher = makeMatcher(actualValue: "Anakin", regex: onlyDigitsRegex)
        
        // then
        XCTAssertEqual(actualMatcher.matcherName, expectedResult)
    }
    
    func testReportEvaluationResult() throws {
        // given
        let reportExpectation = expectation(description: "toMatch() should report the evaluation result")
        
        mockedReporter.onReportResult = { _ in
            reportExpectation.fulfill()
        }
       
        // when
        expect("Luke").toMatch(onlyDigitsRegex)
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToMatchTests {
    func makeMatcher<T: StringProtocol>(actualValue: T, regex: String, evaluationType: EvaluationType = .positive) -> ToMatch<T> {
        return ToMatch(
            expectation: MockedData.mockedExpectation(value: actualValue, evaluationType: evaluationType),
            regex: regex,
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
