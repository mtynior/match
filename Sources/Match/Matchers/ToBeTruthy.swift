//
//  ToBeTruthy.swift
//  Match
//
//  Created by Michal on 17/10/2021.
//

/// Tests whether the value is Truthy.
///
/// ```swift
/// expect("Anakin".isEmpty).toBeTruthy() // Fails
/// expect("".isEmpty).toBeTruthy() // Passes
/// ```
/// Note:
///
/// The code above is just an example. To verify whether a collection is empty use ``Expectation/toBeEmpty(file:line:)``.
///
public struct ToBeTruthy: Matcher {
    public typealias ResultType = Bool
    
    public let matcherName: String = "toBeTruthy"
    
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
        guard let actualValue = try? expectation.expression.evaluate() else {
            return EvaluationResult(message: "Could not evaluate the expression", evaluationStatus: .failed, evaluationContext: evaluationContext)
        }
        
        let isTruthy = actualValue == true
        
        let evaluationStatus = EvaluationStatus(boolValue: isTruthy, evaluationType: expectation.evaluationType)
        let message: String = {
            switch evaluationStatus {
            case .passed:
                return "Received\(isNegated ? " not" : "") truthy value"
            case .failed:
                return "Expected\(isNegated ? " not" : "") truthy value, but received \(isNegated ? "true" : "false")"
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
public extension Expectation where ReturnType == Bool {
    /// Verifies whether a value is truthy.
    ///
    /// See the ``ToBeTruthy`` for more information.
    ///
    /// - Parameters:
    ///     - file: The file where evaluation was triggered.
    ///     - line: The line number where the evaluation was triggered.
    func toBeTruthy(file: StaticString = #filePath, line: UInt = #line) {
        let matcher = ToBeTruthy(expectation: self, sourceCodeLocation: SourceCodeLocation(file: file, line: line))
        let evaluationResult = matcher.evaluate()
        self.environment.resultReporter.reportResult(evaluationResult)
    }
}
