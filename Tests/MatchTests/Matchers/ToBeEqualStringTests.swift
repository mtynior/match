//
//  ToBeEqualStringTests.swift
//  Match
//
//  Created by Michal on 24/10/2021.
//

import XCTest
@testable import Match

final class ToBeEqualStringTests: XCTestCase {
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
            makeMatcher(actualValue: "Anakin", expectedValue: "Anakin").evaluate().evaluationStatus,
            .passed,
            "ToBeEqual should be evaluated as `passed` when Strings are equal"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedValue: "anakin").evaluate().evaluationStatus,
            .failed,
            "ToBeEqual should be evaluated as `failed` when Strings are the same but case sensitivity does not match"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedValue: "anakin", comparisonOptions: .caseInsensitive).evaluate().evaluationStatus,
            .passed,
            "ToBeEqual should be evaluated as `passed` when Strings are the same but case sensitivity is ignored"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedValue: "Vader").evaluate().evaluationStatus,
            .failed,
            "ToBeEqual should be evaluated as `failed` when Strings are not equal"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedValue: "Vader", comparisonOptions: .caseInsensitive).evaluate().evaluationStatus,
            .failed,
            "ToBeEqual should be evaluated as `failed` when Strings are not equal and case sensitivity is ignored"
        )
    }
    
    func testNegatedEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedValue: "Anakin", evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToBeEqual should be evaluated as `passed` when Strings are equal"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedValue: "anakin", evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToBeEqual should be evaluated as `failed` when Strings are the same but case sensitivity does not match"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedValue: "anakin", comparisonOptions: .caseInsensitive, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToBeEqual should be evaluated as `failed` when Strings are the same but case sensitivity is ignored"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedValue: "Vader", evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToBeEqual should be evaluated as `passed` when Strings are not equal"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedValue: "Vader", comparisonOptions: .caseInsensitive, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToBeEqual should be evaluated as `passed` when Strings are not equal and case sensitivity is ignored"
        )
    }
    
    func testMessages() throws {
        // Failures
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedValue: "Jedi").evaluate().message,
            "Expected: Jedi to be equal (case sensitive) to received: Anakin"
        )
                
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedValue: "Anakin", evaluationType: .negated).evaluate().message,
            "Expected: Anakin not to be equal (case sensitive) to received: Anakin"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedValue: "JEDI", comparisonOptions: .caseInsensitive).evaluate().message,
            "Expected: JEDI to be equal (case insensitive) to received: Anakin"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedValue: "Anakin").evaluate().message,
            "Expected: Anakin is equal (case sensitive) to received: Anakin"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedValue: "Jedi", evaluationType: .negated).evaluate().message,
            "Expected: Jedi is not equal (case sensitive) to received: Anakin"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "Anakin", expectedValue: "anakin", comparisonOptions: .caseInsensitive).evaluate().message,
            "Expected: anakin is equal (case insensitive) to received: Anakin"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toBeEqual"
       
        // when
        let actualMatcher = makeMatcher(actualValue: "Anakin", expectedValue: "Vader")
        
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
        expect("Luke").toBeEqual("Sith")
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToBeEqualStringTests {
    func makeMatcher<T: StringProtocol>(
        actualValue: T,
        expectedValue: T,
        comparisonOptions: StringComparisonOptions = .caseSensitive,
        evaluationType: EvaluationType = .positive
    ) -> ToBeEqualString<T> {
        return ToBeEqualString(
            expectation: MockedData.mockedExpectation(value: actualValue, evaluationType: evaluationType),
            expectedValue: expectedValue,
            comparisonOptions: comparisonOptions,
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
