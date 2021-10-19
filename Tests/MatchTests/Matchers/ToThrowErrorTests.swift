//
//  ToThrowErrorTests.swift.swift
//  Match
//
//  Created by Michal on 19/10/2021.
//

import XCTest
@testable import Match

final class ToThrowErrorTests: XCTestCase {
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
                expectedError: MockedData.Errors.NetworkingError.server
            ).evaluate().evaluationStatus,
            .passed,
            "ToThrowError should be evaluated as `passed` when expected error is thrown"
        )
        
        XCTAssertEqual(
            makeMatcher(
                expression: { try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.server) },
                expectedError: MockedData.Errors.NetworkingError.connection
            ).evaluate().evaluationStatus,
            .failed,
            "ToThrowError should be evaluated as `failed` when expected error is not thrown"
        )
    }
    
    func testNegatedEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(
                expression: { try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.server) },
                expectedError: MockedData.Errors.NetworkingError.server,
                evaluationType: .negated
            ).evaluate().evaluationStatus,
            .failed,
            "Negated ToThrowErrorOfType should be evaluated as `failed` when expected error is thrown"
        )
        
        XCTAssertEqual(
            makeMatcher(
                expression: { try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.server) },
                expectedError: MockedData.Errors.NetworkingError.connection,
                evaluationType: .negated
            ).evaluate().evaluationStatus,
            .passed,
            "Negated ToThrowErrorOfType should be evaluated as `passed` when expected error is not thrown"
        )
    }
    
    func testMessages() throws {
        // Failures
        XCTAssertEqual(
            makeMatcher(
                expression: { try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.server) },
                expectedError: MockedData.Errors.HttpError.forbidden
            ).evaluate().message,
            "Expected to throw: \(MockedData.Errors.HttpError.forbidden), but did not"
        )
        
        XCTAssertEqual(
            makeMatcher(
                expression: { try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.server) },
                expectedError: MockedData.Errors.NetworkingError.server,
                evaluationType: .negated
            ).evaluate().message,
            "Expected not to throw: \(MockedData.Errors.NetworkingError.server), but did"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(
                expression: { try MockedData.Errors.throwError(MockedData.Errors.HttpError.badRequest) },
                expectedError: MockedData.Errors.HttpError.badRequest
            ).evaluate().message,
            "Did throw: \(MockedData.Errors.HttpError.badRequest)"
        )
        
        XCTAssertEqual(
            makeMatcher(
                expression: { try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.server) },
                expectedError: MockedData.Errors.NetworkingError.connection,
                evaluationType: .negated
            ).evaluate().message,
            "Did not throw: \(MockedData.Errors.NetworkingError.connection)"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toThrow"
       
        // when
        let actualMatcher = makeMatcher(
            expression: { try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.connection) },
            expectedError: MockedData.Errors.HttpError.forbidden
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
        expect({ try MockedData.Errors.throwError(MockedData.Errors.NetworkingError.connection) }).toThrow(MockedData.Errors.HttpError.badRequest)
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToThrowErrorTests {
    func makeMatcher<E: Error>(expression: @escaping () throws -> Void, expectedError: E, evaluationType: EvaluationType = .positive) -> ToThrowError<Void, E> {
        return ToThrowError(
            expectation: MockedData.mockedExpectation(expression: expression, evaluationType: evaluationType),
            expectedError: expectedError,
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
