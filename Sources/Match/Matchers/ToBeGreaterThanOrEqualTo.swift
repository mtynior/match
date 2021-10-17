//
//  ToBeGreaterThanOrEqualTo.swift
//  Match
//
//  Created by Michal on 17/10/2021.
//

import Foundation

/// Tests whether the actual value is greater than or equal to expected value.
///
/// This matcher works with any type that conforms to the `Comparable` protocol:
/// ```swift
/// expect(2).ToBeGreaterThan(0) // Passes
/// expect(2).toBeGreaterThan(2) // Passes
/// expect(2).toBeGreaterThan(5) // Fails
/// ```
///
public struct ToBeGreaterThanOrEqualTo<ResultType: Comparable>: Matcher {
    public let matcherName: String = "toBeGreaterThanOrEqualTo"
    
    public let expectation: Expectation<ResultType>
    
    /// Expected value.
    public let expectedValue: ResultType
        
    public let sourceCodeLocation: SourceCodeLocation
    
    /// Creates and instance for expectation using specified expected value.
    ///
    /// - Parameters:
    ///     - expectation: Expectation used to evaluate actual value.
    ///     - expectedValue: Expected value.
    ///     - sourceCodeLocation: The location in the Source Code where evaluation was triggered.
    public init(expectation: Expectation<ResultType>, expectedValue: ResultType, sourceCodeLocation: SourceCodeLocation) {
        self.expectation = expectation
        self.expectedValue = expectedValue
        self.sourceCodeLocation = sourceCodeLocation
    }
    
    public func evaluate() -> EvaluationResult {
        guard let actualValue = try? expectation.expression.evaluate() else {
            return EvaluationResult(message: "Could not evaluate the expression", evaluationStatus: .failed, evaluationContext: evaluationContext)
        }
        
        let isGreaterThanOrEqual = actualValue >= expectedValue
        
        let evaluationStatus = EvaluationStatus(boolValue: isGreaterThanOrEqual, evaluationType: expectation.evaluationType)
        let message: String = {
            switch evaluationStatus {
            case .passed:
                return "Received: \(actualValue) is\(isNegated ? " not" : "") greater than or equal to: \(expectedValue)"
            case .failed:
                return "Expected the received value: \(actualValue)\(isNegated ? " not" : "") to be greater than or equal to: \(expectedValue), but it was\(isNegated ? "" : " not")"
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
public extension Expectation where ReturnType: Comparable {
    /// Verifies whether the actual value is greater than or equal to expected value.
    ///
    /// See the ``ToBeGreaterThanOrEqualTo`` for more information.
    ///
    /// - Parameters:
    ///     - expectedValue: Expected value.
    ///     - file: The file where evaluation was triggered.
    ///     - line: The line number where the evaluation was triggered.
    func toBeGreaterThanOrEqualTo(_ expectedValue: ReturnType, file: String = #filePath, line: UInt = #line) {
        let matcher = ToBeGreaterThanOrEqualTo(expectation: self, expectedValue: expectedValue, sourceCodeLocation: SourceCodeLocation(file: file, line: line))
        let evaluationResult = matcher.evaluate()
        self.environment.resultReporter.reportResult(evaluationResult)
    }
}
