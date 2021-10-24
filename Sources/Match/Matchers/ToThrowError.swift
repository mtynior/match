//
//  ToThrowError.swift
//  Match
//
//  Created by Michal on 19/10/2021.
//

/// Tests whether the expression thrown an expected Error .
///
/// ```swift
///  expect({ try throwError(NetworkingError.server) }).toThrow(NetworkingError.server) // Passes
///  expect({ try throwError(HttpError.badRequest) }).toThrow(HttpError.notFound) // Fails
/// ```
///
public struct ToThrowError<ResultType, ExpectedError: Error>: Matcher {
    public let matcherName: String = "toThrow"
    
    public let expectation: Expectation<ResultType>
    
    /// Expected error type.
    public let expectedError: ExpectedError
    
    public let sourceCodeLocation: SourceCodeLocation
    
    /// Creates and instance for expectation.
    ///
    /// - Parameters:
    ///     - expectation: Expectation used to evaluate actual value.
    ///     - expectedError: Expected error.
    ///     - sourceCodeLocation: The location in the Source Code where evaluation was triggered.
    public init(expectation: Expectation<ResultType>, expectedError: ExpectedError, sourceCodeLocation: SourceCodeLocation) {
        self.expectation = expectation
        self.expectedError = expectedError
        self.sourceCodeLocation = sourceCodeLocation
    }
    
    public func evaluate() -> EvaluationResult {
        let didThrow: Bool = {
            do {
                _ = try expectation.expression.evaluate()
                return false
            } catch {
                return error._domain == expectedError._domain && error._code == expectedError._code
            }
        }()
        
        let evaluationStatus = EvaluationStatus(boolValue: didThrow, evaluationType: expectation.evaluationType)
        let message: String = {
            switch evaluationStatus {
            case .passed:
                return "Did\(isNegated ? " not" : "") throw: \(expectedError)"
            case .failed:
                return "Expected\(isNegated ? " not" : "") to throw: \(expectedError), but \(isNegated ? "did" : "did not")"
            }
        }()

        return EvaluationResult(
            message: message,
            evaluationStatus: evaluationStatus,
            evaluationContext: evaluationContext
        )
    }
}

// MARK: - DSL
public extension Expectation {
    /// Verifies whether the expression thrown an expected Error.
    ///
    /// See the ``ToThrowError`` for more information.
    ///
    /// - Parameters:
    ///     - expectedError: Expected error.
    ///     - file: The file where evaluation was triggered.
    ///     - line: The line number where the evaluation was triggered.
    func toThrow<ExpectedError: Error>(_ expectedError: ExpectedError, file: StaticString = #filePath, line: UInt = #line) {
        let matcher = ToThrowError(expectation: self, expectedError: expectedError, sourceCodeLocation: SourceCodeLocation(file: file, line: line))
        let evaluationResult = matcher.evaluate()
        self.environment.resultReporter.reportResult(evaluationResult)
    }
}
