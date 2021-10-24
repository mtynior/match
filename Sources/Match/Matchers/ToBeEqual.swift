//
//  ToBeEqual.swift
//  Match
//
//  Created by Michal on 17/10/2021.
//

import Foundation

/// Tests whether the two values are equal.
///
/// This matcher works with any type that conforms to the `Equatable` protocol:
/// ```swift
/// expect(2).toBeEqual(5) // Fails
/// expect(2).toBeEqual(2) // Passes
///
/// expect("Anakin").toBeEqual("Vader") // Fails
/// expect("Anakin").toBeEqual("Anakin") // Passes
///
/// expect([1, 2, 3]).toBeEqual([3, 2, 1]) // Fails
/// expect([1, 2, 3]).toBeEqual([1, 2, 3]) // Passes
/// ```
///
/// When comparing `FloatingPoint` numbers use the ``Expectation/toBeCloseTo(_:within:file:line:)`` instead!
///
public struct ToBeEqual<ResultType: Equatable>: Matcher {
    public let matcherName: String = "toBeEqual"
    
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
        
        let isEqual = actualValue == expectedValue
        
        let evaluationStatus = EvaluationStatus(boolValue: isEqual, evaluationType: expectation.evaluationType)
        let message: String = {
            switch evaluationStatus {
            case .passed:
                return "Expected: \(expectedValue) is\(isNegated ? " not" : "") equal to received: \(actualValue)"
            case .failed:
                return "Expected: \(expectedValue)\(isNegated ? " not" : "") to be equal to received: \(actualValue)"
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
public extension Expectation where ReturnType: Equatable {
    /// Verifies whether the two values are equal.
    ///
    /// See the ``ToBeEqual`` for more information.
    ///
    /// - Parameters:
    ///     - expectedValue: Expected value.
    ///     - file: The file where evaluation was triggered.
    ///     - line: The line number where the evaluation was triggered.
    func toBeEqual(_ expectedValue: ReturnType, file: String = #filePath, line: UInt = #line) {
        let matcher = ToBeEqual(expectation: self, expectedValue: expectedValue, sourceCodeLocation: SourceCodeLocation(file: file, line: line))
        let evaluationResult = matcher.evaluate()
        self.environment.resultReporter.reportResult(evaluationResult)
    }
}
