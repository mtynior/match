//
//  ToThrowTests.swift
//  Match
//
//  Created by Michal on 19/10/2021.
//

import XCTest
@testable import Match

final class ToThrowTests: XCTestCase {
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
            makeMatcher(expression: { try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.server) }).evaluate().evaluationStatus,
            .passed,
            "ToThrow should be evaluated as `passed` when an Error is thrown"
        )
        
        XCTAssertEqual(
            makeMatcher(expression: { try MockedData.Errors.throwError(nil) }).evaluate().evaluationStatus,
            .failed,
            "ToThrow should be evaluated as `failed` when an Error is not thrown"
        )
    }
    
    func testNegatedEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(expression: { try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.server) }, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToThrow should be evaluated as `failed` when an Error is thrown"
        )
        
        XCTAssertEqual(
            makeMatcher(expression: { try MockedData.Errors.throwError(nil) }, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToThrow should be evaluated as `passed` when an Error is not thrown"
        )
    }
    
    func testMessages() throws {
        // Failures
        XCTAssertEqual(
            makeMatcher(expression: { try MockedData.Errors.throwError(nil) }).evaluate().message,
            "Expected to throw an Error, but did not"
        )
        
        XCTAssertEqual(
            makeMatcher(expression: { try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.server) }, evaluationType: .negated).evaluate().message,
            "Expected not to throw an Error, but did"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(expression: { try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.server) }).evaluate().message,
            "Did throw an Error"
        )
        
        XCTAssertEqual(
            makeMatcher(expression: { try MockedData.Errors.throwError(nil) }, evaluationType: .negated).evaluate().message,
            "Did not throw an Error"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toThrow"
       
        // when
        let actualMatcher = makeMatcher(expression: { try MockedData.Errors.throwError(nil) })
        
        // then
        XCTAssertEqual(actualMatcher.matcherName, expectedResult)
    }
    
    func testReportEvaluationResult() throws {
        // given
        let reportExpectation = expectation(description: "toThrow() should report the evaluation result")
        
        mockedReporter.onReportResult = { _ in
            reportExpectation.fulfill()
        }
       
        // when
        expect({ try MockedData.Errors.throwError(nil) }).toThrow()
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToThrowTests {
    func makeMatcher(expression: @escaping () throws -> Void, evaluationType: EvaluationType = .positive) -> ToThrow<Void> {
        return ToThrow(
            expectation: MockedData.mockedExpectation(expression: expression, evaluationType: evaluationType),
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
