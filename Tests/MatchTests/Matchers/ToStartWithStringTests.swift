//
//  ToStartWithStringTests.swift
//  Match
//
//  Created by Michal on 19/10/2021.
//

import XCTest
@testable import Match

final class ToStartWithStringTests: XCTestCase {
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
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "Anak").evaluate().evaluationStatus,
            .passed,
            "ToStartWithString should be evaluated as `passed` when a String starts with a substring"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "aki").evaluate().evaluationStatus,
            .failed,
            "ToStartWithString should be evaluated as `failed` when a String starts with a substring but case sensitivity does not mach"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "anak", comparisonOptions: .caseInsensitive).evaluate().evaluationStatus,
            .passed,
            "ToStartWithString should be evaluated as `passed` when a String starts with a substring and case sensitivity is ignored"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "AKi").evaluate().evaluationStatus,
            .failed,
            "ToStartWithString should be evaluated as `failed` when a String does not start a substring"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "Vader", comparisonOptions: .caseInsensitive).evaluate().evaluationStatus,
            .failed,
            "ToStartWithString should be evaluated as `failed` when a String does not start a substring and case sensitivity is ignored"
        )
    }
    
    func testNegatedEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "Anak", evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToStartWithString should be evaluated as `failed` when a String starts with a substring"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "aki", evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToStartWithString should be evaluated as `passed` when a String starts with a substring but case sensitivity does not mach"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "anak", comparisonOptions: .caseInsensitive, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToStartWithString should be evaluated as `failed` when a String starts with a substring and case sensitivity is ignored"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "AKi", evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToStartWithString should be evaluated as `passed` when a String does not start a substring"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "Vader", evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToStartWithString should be evaluated as `passed` when a String does not start a substring"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "Vader", comparisonOptions: .caseInsensitive, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToStartWithString should be evaluated as `passed` when a String does not start a substring and case sensitivity is ignored"
        )
    }
        
    func testMessages() throws {
        // Failures
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedSubstring: "Jedi").evaluate().message,
            "Expected the: Anakin to start with (case sensitive): Jedi, but it does not"
        )
                
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedSubstring: "Anak", evaluationType: .negated).evaluate().message,
            "Expected the: Anakin not to start with (case sensitive): Anak, but it does"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedSubstring: "JEDI", comparisonOptions: .caseInsensitive).evaluate().message,
            "Expected the: Anakin to start with (case insensitive): JEDI, but it does not"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedSubstring: "Anak").evaluate().message,
            "Received: Anakin does start with (case sensitive): Anak"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedSubstring: "Jedi", evaluationType: .negated).evaluate().message,
            "Received: Anakin does not start with (case sensitive): Jedi"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedSubstring: "ANAK", comparisonOptions: .caseInsensitive).evaluate().message,
            "Received: Anakin does start with (case insensitive): ANAK"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toStartWith"
       
        // when
        let actualMatcher = makeMatcher(actualValue: "Anakin", expectedSubstring: "aki")
        
        // then
        XCTAssertEqual(actualMatcher.matcherName, expectedResult)
    }
    
    func testReportEvaluationResult() throws {
        // given
        let reportExpectation = expectation(description: "toStartWith() should report the evaluation result")
        
        mockedReporter.onReportResult = { _ in
            reportExpectation.fulfill()
        }
       
        // when
        expect("Anakin").toStartWith("aki")
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToStartWithStringTests {
    func makeMatcher<T: StringProtocol>(
        actualValue: T,
        expectedSubstring: T,
        comparisonOptions: StringComparisonOptions = .caseSensitive,
        evaluationType: EvaluationType = .positive
    ) -> ToStartWithString<T> {
        return ToStartWithString(
            expectation: MockedData.mockedExpectation(value: actualValue, evaluationType: evaluationType),
            expectedSubstring: expectedSubstring,
            comparisonOptions: comparisonOptions,
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
