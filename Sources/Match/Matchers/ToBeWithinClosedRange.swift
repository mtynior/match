//
//  ToBeWithinClosedRange.swift
//  Match
//
//  Created by Michal on 19/10/2021.
//

import Foundation
/// Tests whether the actual value is within closed range.
/// ```swift
/// expect(15).toBeWithin(0...10) // Fails
/// expect(10).toBeWithin(0...10) // Passes
/// expect(7).toBeWithin(0...10) // Passes
/// ```
///
public struct ToBeWithinClosedRange<ResultType: Comparable>: Matcher {
    public let matcherName: String = "toBeWithin"
    
    public let expectation: Expectation<ResultType>
    
    /// Expected value.
    public let expectedRange: ClosedRange<ResultType>
        
    public let sourceCodeLocation: SourceCodeLocation
    
    /// Creates and instance for expectation using specified expected value.
    ///
    /// - Parameters:
    ///     - expectation: Expectation used to evaluate actual value.
    ///     - expectedRange: Expected range.
    ///     - sourceCodeLocation: The location in the Source Code where evaluation was triggered.
    public init(expectation: Expectation<ResultType>, expectedRange: ClosedRange<ResultType>, sourceCodeLocation: SourceCodeLocation) {
        self.expectation = expectation
        self.expectedRange = expectedRange
        self.sourceCodeLocation = sourceCodeLocation
    }
    
    public func evaluate() -> EvaluationResult {
        guard let actualValue = try? expectation.expression.evaluate() else {
            return EvaluationResult(message: "Could not evaluate the expression", evaluationStatus: .failed, evaluationContext: evaluationContext)
        }
        
        let doesContain = expectedRange.contains(actualValue)
        
        let evaluationStatus = EvaluationStatus(boolValue: doesContain, evaluationType: expectation.evaluationType)
        let message: String = {
            switch evaluationStatus {
            case .passed:
                return "Actual value: \(actualValue) is\(isNegated ? " not" : "") within range: (\(expectedRange.lowerBound)...\(expectedRange.upperBound))"
            case .failed:
                return "Expected\(isNegated ? " not" : "") to be within (\(expectedRange.lowerBound)...\(expectedRange.upperBound)), but received: \(actualValue) is\(isNegated ? "" : " not")"
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
    /// Verifies whether the actual value is within closed range.
    ///
    /// See the ``ToBeWithinClosedRange`` for more information.
    ///
    /// - Parameters:
    ///     - expectedRange: Expected range.
    ///     - file: The file where evaluation was triggered.
    ///     - line: The line number where the evaluation was triggered.
    func toBeWithin(_ expectedRange: ClosedRange<ReturnType>, file: String = #filePath, line: UInt = #line) {
        let matcher = ToBeWithinClosedRange(expectation: self, expectedRange: expectedRange, sourceCodeLocation: SourceCodeLocation(file: file, line: line))
        let evaluationResult = matcher.evaluate()
        self.environment.resultReporter.reportResult(evaluationResult)
    }
}
