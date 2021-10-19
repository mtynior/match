//
//  ToThrow.swift
//  Match
//
//  Created by Michal on 19/10/2021.
//

/// Tests whether the expression thrown any error.
///
/// ```swift
///  expect({ try throwError(NetworkingError.server) }).toThrow() // Passes
///  expect({ try throwError(nil) }).toThrow() // Fails
/// ```
///
public struct ToThrow<ResultType>: Matcher {
    public let matcherName: String = "toThrow"
    
    public let expectation: Expectation<ResultType>
    
    public let sourceCodeLocation: SourceCodeLocation
    
    /// Creates and instance for expectation.
    ///
    /// - Parameters:
    ///     - expectation: Expectation used to evaluate actual value.
    ///     - sourceCodeLocation: The location in the Source Code where evaluation was triggered.
    public init(expectation: Expectation<ResultType>, sourceCodeLocation: SourceCodeLocation) {
        self.expectation = expectation
        self.sourceCodeLocation = sourceCodeLocation
    }
    
    public func evaluate() -> EvaluationResult {
        let didThrow: Bool = {
            do {
                _ = try expectation.expression.evaluate()
                return false
            } catch {
                return true
            }
        }()
        
        let evaluationStatus = EvaluationStatus(boolValue: didThrow, evaluationType: expectation.evaluationType)
        let message: String = {
            switch evaluationStatus {
            case .passed:
                return "Did\(isNegated ? " not" : "") throw an Error"
            case .failed:
                return "Expected\(isNegated ? " not" : "") to throw an Error, but \(isNegated ? "did" : "did not")"
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
    /// Verifies whether the expression thrown any error.
    ///
    /// See the ``ToThrow`` for more information.
    ///
    /// - Parameters:
    ///     - file: The file where evaluation was triggered.
    ///     - line: The line number where the evaluation was triggered.
    func toThrow(file: String = #filePath, line: UInt = #line) {
        let matcher = ToThrow<ReturnType>(expectation: self, sourceCodeLocation: SourceCodeLocation(file: file, line: line))
        let evaluationResult = matcher.evaluate()
        self.environment.resultReporter.reportResult(evaluationResult)
    }
}
