//
//  ToThrowErrorOfType.swift
//  Match
//
//  Created by Michal on 19/10/2021.
//

/// Tests whether the expression thrown an Error of expected type.
///
/// ```swift
///  expect({ try throwError(NetworkingError.server) }).toThrow(NetworkingError.self) // Passes
///  expect({ try throwError(HttpError.badRequest) }).toThrow(NetworkingError.self) // Fails
/// ```
///
public struct ToThrowErrorOfType<ResultType, ExpectedError: Error>: Matcher {
    public let matcherName: String = "toThrow"
    
    public let expectation: Expectation<ResultType>
    
    /// Expected error type.
    public let expectedErrorType: ExpectedError.Type
    
    public let sourceCodeLocation: SourceCodeLocation
    
    /// Creates and instance for expectation.
    ///
    /// - Parameters:
    ///     - expectation: Expectation used to evaluate actual value.
    ///     - expectedErrorType: Expected error type.
    ///     - sourceCodeLocation: The location in the Source Code where evaluation was triggered.
    public init(expectation: Expectation<ResultType>, expectedErrorType: ExpectedError.Type, sourceCodeLocation: SourceCodeLocation) {
        self.expectation = expectation
        self.expectedErrorType = expectedErrorType
        self.sourceCodeLocation = sourceCodeLocation
    }
    
    public func evaluate() -> EvaluationResult {
        let didThrow: Bool = {
            do {
                _ = try expectation.expression.evaluate()
                return false
            } catch {
                return (error as? ExpectedError) != nil
            }
        }()
        
        let evaluationStatus = EvaluationStatus(boolValue: didThrow, evaluationType: expectation.evaluationType)
        let message: String = {
            switch evaluationStatus {
            case .passed:
                return "Did\(isNegated ? " not" : "") throw an error of type of: \(expectedErrorType)"
            case .failed:
                return "Expected\(isNegated ? " not" : "") to throw an error of type of: \(expectedErrorType), but \(isNegated ? "did" : "did not")"
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
    /// Verifies whether the expression thrown an Error of expected type..
    ///
    /// See the ``ToThrowErrorOfType`` for more information.
    ///
    /// - Parameters:
    ///     - expectedErrorType: Expected error type.
    ///     - file: The file where evaluation was triggered.
    ///     - line: The line number where the evaluation was triggered.
    func toThrow<ExpectedError: Error>(_ expectedErrorType: ExpectedError.Type, file: StaticString = #filePath, line: UInt = #line) {
        let matcher = ToThrowErrorOfType(expectation: self, expectedErrorType: expectedErrorType, sourceCodeLocation: SourceCodeLocation(file: file, line: line))
        let evaluationResult = matcher.evaluate()
        self.environment.resultReporter.reportResult(evaluationResult)
    }
}
