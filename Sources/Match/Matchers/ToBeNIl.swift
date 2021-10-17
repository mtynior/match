//
//  ToBeNil.swift
//  Match
//
//  Created by Michal on 17/10/2021.
//
/// Tests whether the value is `nil`.
///
/// ```swift
/// let optional: String = nil
/// expect(optional).toBeNil() // Passes
/// expect(optional).not.toBeFalsy() // Fails
/// ```
///
public struct ToBeNil<ResultType>: Matcher {
    public let matcherName: String = "toBeNil"
    
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
        
        let isNil: Bool = {
            if let optional = actualValue as? _MatchOptionalProtocol {
                return optional.isNil
            }
            return false
        }()
        
        let evaluationStatus = EvaluationStatus(boolValue: isNil, evaluationType: expectation.evaluationType)
        let message: String = {
            switch evaluationStatus {
            case .passed:
                return "Received value is\(isNegated ? " not" : "") nil"
            case .failed:
                return "Expected\(isNegated ? " not" : "") nil value, but received: \(isNegated ? "nil" : "\(actualValue)")"
            }
        }()

        return EvaluationResult(
            message: message,
            evaluationStatus: evaluationStatus,
            evaluationContext: evaluationContext
        )
    }
}

// MARK: - Helpers
private protocol _MatchOptionalProtocol {
    var isNil: Bool { get }
}

extension Optional: _MatchOptionalProtocol {
    /// Indicates whether the optional is `nil` or not.
    var isNil: Bool { self == nil }
}

// MARK: - DSL
public extension Expectation {
    /// Verifies whether a value is `nil`.
    ///
    /// See the ``ToBeNil`` for more information.
    ///
    /// - Parameters:
    ///     - file: The file where evaluation was triggered.
    ///     - line: The line number where the evaluation was triggered.
    func toBeNil(file: String = #filePath, line: UInt = #line) {
        let matcher = ToBeNil(expectation: self, sourceCodeLocation: SourceCodeLocation(file: file, line: line))
        let evaluationResult = matcher.evaluate()
        self.environment.resultReporter.reportResult(evaluationResult)
    }
}
