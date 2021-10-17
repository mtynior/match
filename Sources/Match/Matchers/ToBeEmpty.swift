//
//  ToBeEmpty.swift
//  Match
//
//  Created by Michal on 17/10/2021.
//

import Foundation

/// Tests whether a collection of values is empty.
///
/// This matcher works with any type that conforms to the `Collection` protocol, like `Array` or `String`:
/// ```swift
/// expect([1, 2, 3]).toBeEmpty() // Fails
/// expect([Int]()).toBeEmpty() //Passes
///
/// expect("Luke Skywalker").toBeEmpty() // Fails
/// expect("").toBeEmpty() // Passes
/// ```
/// 
public struct ToBeEmpty<ResultType: Collection>: Matcher {
    public let matcherName: String = "toBeEmpty"
    
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
        
        let isEmpty = actualValue.isEmpty
        
        let evaluationStatus = EvaluationStatus(boolValue: isEmpty, evaluationType: expectation.evaluationType)
        let message: String = {
            switch evaluationStatus {
            case .passed:
                return "Expected collection is\(isNegated ? " not" : "") empty\(isNegated ? " and has \(actualValue.count) elements" : "")"
            case .failed:
                return "Expected\(isNegated ? " not" : "") empty value, but received \(actualValue.count) elements"
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
public extension Expectation where ReturnType: Collection {
    /// Verifies whether a `Collection` is empty.
    ///
    /// See the ``ToBeEmpty`` for more information.
    ///
    /// - Parameters:
    ///     - file: The file where evaluation was triggered.
    ///     - line: The line number where the evaluation was triggered.
    func toBeEmpty(file: String = #filePath, line: UInt = #line) {
        let matcher = ToBeEmpty(expectation: self, sourceCodeLocation: SourceCodeLocation(file: file, line: line))
        let evaluationResult = matcher.evaluate()
        self.environment.resultReporter.reportResult(evaluationResult)
    }
}
