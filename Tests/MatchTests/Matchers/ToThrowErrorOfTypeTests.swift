//
//  ToThrowErrorOfTypeTests.swift
//  Match
//
//  Created by Michal on 19/10/2021.
//

import XCTest
@testable import Match

final class ToThrowErrorOfTypeTests: XCTestCase {
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
            makeMatcher(
                expression: { try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.server) },
                expectedError: MockedData.Errors.NetworkingError.self
            ).evaluate().evaluationStatus,
            .passed,
            "ToThrowErrorOfType should be evaluated as `passed` when an error of expected type is thrown"
        )
        
        XCTAssertEqual(
            makeMatcher(
                expression: { try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.server) },
                expectedError: MockedData.Errors.HttpError.self
            ).evaluate().evaluationStatus,
            .failed,
            "ToThrowErrorOfType should be evaluated as `failed` when an error of expected type is not thrown"
        )
    }
    
    func testNegatedEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(
                expression: { try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.server) },
                expectedError: MockedData.Errors.NetworkingError.self,
                evaluationType: .negated
            ).evaluate().evaluationStatus,
            .failed,
            "Negated ToThrowErrorOfType should be evaluated as `failed` when an error of expected type is thrown"
        )
        
        XCTAssertEqual(
            makeMatcher(
                expression: { try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.server) },
                expectedError: MockedData.Errors.HttpError.self,
                evaluationType: .negated
            ).evaluate().evaluationStatus,
            .passed,
            "Negated ToThrowErrorOfType should be evaluated as `passed` when an Error is not thrown"
        )
    }
    
    func testMessages() throws {
        // Failures
        XCTAssertEqual(
            makeMatcher(
                expression: { try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.server) },
                expectedError: MockedData.Errors.HttpError.self
            ).evaluate().message,
            "Expected to throw an error of type of: \(MockedData.Errors.HttpError.self), but did not"
        )
        
        XCTAssertEqual(
            makeMatcher(
                expression: { try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.server) },
                expectedError: MockedData.Errors.NetworkingError.self,
                evaluationType: .negated
            ).evaluate().message,
            "Expected not to throw an error of type of: \(MockedData.Errors.NetworkingError.self), but did"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(
                expression: { try MockedData.Errors.throwError(MockedData.Errors.HttpError.badRequest) },
                expectedError: MockedData.Errors.HttpError.self
            ).evaluate().message,
            "Did throw an error of type of: \(MockedData.Errors.HttpError.self)"
        )
        
        XCTAssertEqual(
            makeMatcher(
                expression: { try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.server) },
                expectedError: MockedData.Errors.HttpError.self,
                evaluationType: .negated
            ).evaluate().message,
            "Did not throw an error of type of: \(MockedData.Errors.HttpError.self)"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toThrow"
       
        // when
        let actualMatcher = makeMatcher(
            expression: { try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.connection) },
            expectedError: MockedData.Errors.HttpError.self
        )
        
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
        expect({ try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.connection) }).toThrow(MockedData.Errors.HttpError.self)
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToThrowErrorOfTypeTests {
    func makeMatcher<E: Error>(expression: @escaping () throws -> Void, expectedError: E.Type, evaluationType: EvaluationType = .positive) -> ToThrowErrorOfType<Void, E> {
        return ToThrowErrorOfType(
            expectation: MockedData.mockedExpectation(expression: expression, evaluationType: evaluationType),
            expectedErrorType: expectedError,
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
