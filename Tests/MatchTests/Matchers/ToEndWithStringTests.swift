//
//  ToEndWithStringTests.swift
//  Match
//
//  Created by Michal on 19/10/2021.
//

import XCTest
@testable import Match

final class ToEndWithStringTests: XCTestCase {
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
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "walker").evaluate().evaluationStatus,
            .passed,
            "ToEndWithString should be evaluated as `passed` when a String ends with a substring"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "WaLker").evaluate().evaluationStatus,
            .failed,
            "ToEndWithString should be evaluated as `failed` when a String ends with a substring but case sensitivity does not mach"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "WaLker", comparisonOptions: .caseInsensitive).evaluate().evaluationStatus,
            .passed,
            "ToEndWithString should be evaluated as `passed` when a String ends with a substring and case sensitivity is ignored"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "Sky").evaluate().evaluationStatus,
            .failed,
            "ToEndWithString should be evaluated as `failed` when a String does not end with a substring"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "Sky", comparisonOptions: .caseInsensitive).evaluate().evaluationStatus,
            .failed,
            "ToEndWithString should be evaluated as `failed` when a String does not end with a substring and case sensitivity is ignored"
        )
    }
    
    func testNegatedEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "walker", evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToEndWithString should be evaluated as `failed` when a String ends with a substring"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "WaLker", evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToEndWithString should be evaluated as `passed` when a String ends with a substring but case sensitivity does not mach"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "WaLker", comparisonOptions: .caseInsensitive, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToEndWithString should be evaluated as `failed` when a String ends with a substring and case sensitivity is ignored"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "Sky", evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToEndWithString should be evaluated as `passed` when a String does not end with a substring"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "Sky", comparisonOptions: .caseInsensitive, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToEndWithString should be evaluated as `passed` when a String does not end with a substring and case sensitivity is ignored"
        )
    }
        
    func testMessages() throws {
        // Failures
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedSubstring: "Jedi").evaluate().message,
            "Expected the: Anakin to end with (case sensitive): Jedi, but it does not"
        )
                
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedSubstring: "kin", evaluationType: .negated).evaluate().message,
            "Expected the: Anakin not to end with (case sensitive): kin, but it does"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedSubstring: "Aki", comparisonOptions: .caseInsensitive).evaluate().message,
            "Expected the: Anakin to end with (case insensitive): Aki, but it does not"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedSubstring: "kin").evaluate().message,
            "Received: Anakin does end with (case sensitive): kin"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedSubstring: "Kin", evaluationType: .negated).evaluate().message,
            "Received: Anakin does not end with (case sensitive): Kin"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedSubstring: "Kin", comparisonOptions: .caseInsensitive).evaluate().message,
            "Received: Anakin does end with (case insensitive): Kin"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toEndWith"
       
        // when
        let actualMatcher = makeMatcher(actualValue: "Anakin", expectedSubstring: "AKI")
        
        // then
        XCTAssertEqual(actualMatcher.matcherName, expectedResult)
    }
    
    func testReportEvaluationResult() throws {
        // given
        let reportExpectation = expectation(description: "toEndWith() should report the evaluation result")
        
        mockedReporter.onReportResult = { _ in
            reportExpectation.fulfill()
        }
       
        // when
        expect("Anakin").toEndWith("aki")
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToEndWithStringTests {
    func makeMatcher<T: StringProtocol>(
        actualValue: T,
        expectedSubstring: T,
        comparisonOptions: StringComparisonOptions = .caseSensitive,
        evaluationType: EvaluationType = .positive
    ) -> ToEndWithString<T> {
        return ToEndWithString(
            expectation: MockedData.mockedExpectation(value: actualValue, evaluationType: evaluationType),
            expectedSubstring: expectedSubstring,
            comparisonOptions: comparisonOptions,
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
