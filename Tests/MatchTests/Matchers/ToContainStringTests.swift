//
//  ToContainStringTests.swift
//  Match
//
//  Created by Michal on 18/10/2021.
//

import XCTest
@testable import Match

final class ToContainStringTests: XCTestCase {
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
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "Sky").evaluate().evaluationStatus,
            .passed,
            "ToContainString should be evaluated as `passed` when a String contains a substring"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "sky").evaluate().evaluationStatus,
            .failed,
            "ToContainString should be evaluated as `failed` when a String contains a substring but case sensitivity does not mach"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "sKY", comparisonOptions: .caseInsensitive).evaluate().evaluationStatus,
            .passed,
            "ToContainString should be evaluated as `passed` when a String contains a substring and case sensitivity is ignored"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "Vader").evaluate().evaluationStatus,
            .failed,
            "ToContainString should be evaluated as `failed` when a String does not contain a substring"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "Vader", comparisonOptions: .caseInsensitive).evaluate().evaluationStatus,
            .failed,
            "ToContainString should be evaluated as `failed` when a String does not contain a substring and case sensitivity is ignored"
        )
    }
    
    func testNegatedEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "Sky", evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToContainString should be evaluated as `failed` when a String contains a substring"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "sky", evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToContainString should be evaluated as `passed` when a String contains a substring but case sensitivity does not mach"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "sKY", comparisonOptions: .caseInsensitive, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToContainString should be evaluated as `failed` when a String contains a substring and case sensitivity is ignored"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "Vader", evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToContainString should be evaluated as `passed` when a String does not contain a substring"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin Skywalker", expectedSubstring: "Vader", comparisonOptions: .caseInsensitive, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToContainString should be evaluated as `passed` when a String does not contain a substring and case sensitivity is ignored"
        )
    }
        
    func testMessages() throws {
        // Failures
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedSubstring: "Jedi").evaluate().message,
            "Expected the: Anakin to contain (case sensitive): Jedi, but it does not"
        )
                
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedSubstring: "aki", evaluationType: .negated).evaluate().message,
            "Expected the: Anakin not to contain (case sensitive): aki, but it does"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedSubstring: "JEDI", comparisonOptions: .caseInsensitive).evaluate().message,
            "Expected the: Anakin to contain (case insensitive): JEDI, but it does not"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedSubstring: "nak").evaluate().message,
            "Received: Anakin does contain (case sensitive): nak"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedSubstring: "Jedi", evaluationType: .negated).evaluate().message,
            "Received: Anakin does not contain (case sensitive): Jedi"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedSubstring: "AKI", comparisonOptions: .caseInsensitive).evaluate().message,
            "Received: Anakin does contain (case insensitive): AKI"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toContain"
       
        // when
        let actualMatcher = makeMatcher(actualValue: "Anakin", expectedSubstring: "Vader")
        
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
        expect("Anakin").toContain("Darth")
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToContainStringTests {
    func makeMatcher<T: StringProtocol>(
        actualValue: T,
        expectedSubstring: T,
        comparisonOptions: StringComparisonOptions = .caseSensitive,
        evaluationType: EvaluationType = .positive
    ) -> ToContainString<T> {
        return ToContainString(
            expectation: MockedData.mockedExpectation(value: actualValue, evaluationType: evaluationType),
            expectedSubstring: expectedSubstring,
            comparisonOptions: comparisonOptions,
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
