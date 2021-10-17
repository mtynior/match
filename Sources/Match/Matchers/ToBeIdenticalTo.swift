//
//  ToBeIdenticalTo.swift
//  
//
//  Created by Michal on 17/10/2021.
//

import Foundation

/// Tests whether the two values are identical (share the same memory).
///
/// This matcher works with any type that conforms to the `AnyObject` protocol:
/// ```swift
/// final class Car {
///    let color: String
/// }
///
/// let car1 = Car(color: "red")
/// let car2 = Car(color: "red")
///
/// expect(car1).toBeIdenticalTo(car2) // Fails
/// expect(car1).toBeIdenticalTo(car1) // Passes
/// ```
///
public struct ToBeIdenticalTo<ResultType: AnyObject>: Matcher {
    public let matcherName: String = "toBeIdenticalTo"
    
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
        
        let isIdentical = actualValue === expectedValue
        
        let evaluationStatus = EvaluationStatus(boolValue: isIdentical, evaluationType: expectation.evaluationType)
        let message: String = {
            switch evaluationStatus {
            case .passed:
                return "Expected: \(expectedValue) is\(isNegated ? " not" : "") identical to received: \(actualValue)"
            case .failed:
                return "Expected: \(expectedValue)\(isNegated ? " not" : "") to be identical to received: \(actualValue)"
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
public extension Expectation where ReturnType: AnyObject {
    /// Verifies whether the two values are identical (share the same memory).
    ///
    /// See the ``ToBeIdenticalTo`` for more information.
    ///
    /// - Parameters:
    ///     - expectedValue: Expected value.
    ///     - file: The file where evaluation was triggered.
    ///     - line: The line number where the evaluation was triggered.
    func toBeIdenticalTo(_ expectedValue: ReturnType, file: String = #filePath, line: UInt = #line) {
        let matcher = ToBeIdenticalTo(expectation: self, expectedValue: expectedValue, sourceCodeLocation: SourceCodeLocation(file: file, line: line))
        let evaluationResult = matcher.evaluate()
        self.environment.resultReporter.reportResult(evaluationResult)
    }
}
