//
//  ToBeTypeOfTests.swift
//  Match
//
//  Created by Michal on 18/10/2021.
//

import XCTest
@testable import Match

final class ToBeTypeOfTests: XCTestCase {
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
            makeMatcher(actualValue: 1, expectedType: Int.self).evaluate().evaluationStatus,
            .passed,
            "ToBeTypeOf should be evaluated as `passed` when value is of expected type"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "1", expectedType: Int.self).evaluate().evaluationStatus,
            .failed,
            "ToBeTypeOf should be evaluated as `failed` when value is of expected type"
        )

        XCTAssertEqual(
            makeMatcher(actualValue: TieFighter(), expectedType: TieFighter.self).evaluate().evaluationStatus,
            .passed,
            "ToBeTypeOf should be evaluated as `passed` when object is of expected type"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: TieBomber(), expectedType: TieFighter.self).evaluate().evaluationStatus,
            .passed,
            "ToBeTypeOf should be evaluated as `passed` when object is a subclass of expected type"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: TieFighter(), expectedType: Fighter.self).evaluate().evaluationStatus,
            .passed,
            "ToBeTypeOf should be evaluated as `passed` when object conforms to protocol"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: XWingStruct(), expectedType: Fighter.self).evaluate().evaluationStatus,
            .passed,
            "ToBeTypeOf should be evaluated as `passed` when structure conforms to protocol"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "XWing", expectedType: Fighter.self).evaluate().evaluationStatus,
            .failed,
            "ToBeTypeOf should be evaluated as `failed` when value does not conform to protocol"
        )
    }
    
    func testNegatedEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: 1, expectedType: Int.self, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToBeTypeOf should be evaluated as `failed` when value is of expected type"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "1", expectedType: Int.self, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToBeTypeOf should be evaluated as `passed` when value is of expected type"
        )

        XCTAssertEqual(
            makeMatcher(actualValue: TieFighter(), expectedType: TieFighter.self, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToBeTypeOf should be evaluated as `failed` when object is of expected type"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: TieBomber(), expectedType: TieFighter.self, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToBeTypeOf should be evaluated as `failed` when object is a subclass of expected type"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: TieFighter(), expectedType: Fighter.self, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToBeTypeOf should be evaluated as `failed` when object conforms to protocol"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: XWingStruct(), expectedType: Fighter.self, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToBeTypeOf should be evaluated as `failed` when structure conforms to protocol"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: "XWing", expectedType: Fighter.self, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToBeTypeOf should be evaluated as `passed` when value does not conform to protocol"
        )
    }
    
    func testMessages() throws {
        // Failures
        XCTAssertEqual(
            makeMatcher(actualValue: 2, expectedType: String.self).evaluate().message,
            "Expected to be type of: \(String.self), but received: \(Int.self)"
        )
                
        XCTAssertEqual(
            makeMatcher(actualValue: "Hello", expectedType: String.self, evaluationType: .negated).evaluate().message,
            "Expected not to be type of: \(String.self), but received: \(String.self)"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(actualValue: 2, expectedType: Int.self).evaluate().message,
            "Received: \(Int.self) is type of expected: \(Int.self)"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 2, expectedType: String.self, evaluationType: .negated).evaluate().message,
            "Received: \(Int.self) is not type of expected: \(String.self)"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toBeTypeOf"
       
        // when
        let actualMatcher = makeMatcher(actualValue: "Anakin", expectedType: Int.self)
        
        // then
        XCTAssertEqual(actualMatcher.matcherName, expectedResult)
    }
    
    func testReportEvaluationResult() throws {
        // given
        let reportExpectation = expectation(description: "toBeTypeOf() should report the evaluation result")
        
        mockedReporter.onReportResult = { _ in
            reportExpectation.fulfill()
        }
       
        // when
        expect("Han Solo").toBeTypeOf(Int.self)
        
        // then
        waitForExpectations(timeout: 5)
    }
}

// MARK: - Helpers

protocol Fighter {}

private extension ToBeTypeOfTests {
    class TieFighter: Fighter {}
    final class TieBomber: TieFighter {}
    struct XWingStruct: Fighter {}
    
    func makeMatcher<Actual, Expected>(actualValue: Actual, expectedType: Expected.Type, evaluationType: EvaluationType = .positive) -> ToBeTypeOf<Actual, Expected> {
        return ToBeTypeOf(
            expectation: MockedData.mockedExpectation(value: actualValue, evaluationType: evaluationType),
            expectedType: expectedType,
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
