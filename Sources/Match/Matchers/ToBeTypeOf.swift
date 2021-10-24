//
//  ToBeTypeOf.swift
//  Match
//
//  Created by Michal on 18/10/2021.
//

import Foundation

/// Tests whether the actual value is type of the expected type.
///
/// ```swift
/// expect("Anakin").toBeTypeOf(Int.self) // Fails
/// expect("Anakin").toBeTypeOf(String.self) // Passes
/// ```
/// This matcher also verifies whether a value or an object conforms to protocol, and can verify the inheritance:
/// ```swift
/// protocol Fighter {}
/// class TieFighter: Fighter {}
/// final class TieBomber: TieFighter {}
///
/// expect(TieFighter()).toBeTypeOf(Fighter.self) // Passes
/// expect(TieBomber()).toBeTypeOf(TieFighter.self) // Passes
/// expect(TieBomber()).toBeTypeOf(Fighter.self) // Passes
/// ```
///
public struct ToBeTypeOf<ResultType, ExpectedType>: Matcher {
    public let matcherName: String = "toBeTypeOf"
    
    public let expectation: Expectation<ResultType>
    
    /// Expected type.
    public let expectedType: ExpectedType.Type
        
    public let sourceCodeLocation: SourceCodeLocation
    
    /// Creates and instance for expectation using specified expected value.
    ///
    /// - Parameters:
    ///     - expectation: Expectation used to evaluate actual value.
    ///     - expectedType: Expected type.
    ///     - sourceCodeLocation: The location in the Source Code where evaluation was triggered.
    public init(expectation: Expectation<ResultType>, expectedType: ExpectedType.Type, sourceCodeLocation: SourceCodeLocation) {
        self.expectation = expectation
        self.expectedType = expectedType
        self.sourceCodeLocation = sourceCodeLocation
    }
    
    public func evaluate() -> EvaluationResult {
        guard let actualValue = try? expectation.expression.evaluate() else {
            return EvaluationResult(message: "Could not evaluate the expression", evaluationStatus: .failed, evaluationContext: evaluationContext)
        }
        
        let isTypeOf = actualValue is ExpectedType
        
        let evaluationStatus = EvaluationStatus(boolValue: isTypeOf, evaluationType: expectation.evaluationType)
        let message: String = {
            switch evaluationStatus {
            case .passed:
                return "Received: \(type(of: actualValue)) is\(isNegated ? " not" : "") type of expected: \(expectedType)"
            case .failed:
                return "Expected\(isNegated ? " not" : "") to be type of: \(expectedType), but received: \(type(of: actualValue))"
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
    /// Verifies whether the actual value is type of the expected type.
    ///
    /// See the ``ToBeTypeOf`` for more information.
    ///
    /// - Parameters:
    ///     - expectedType: Expected type.
    ///     - file: The file where evaluation was triggered.
    ///     - line: The line number where the evaluation was triggered.
    func toBeTypeOf<ExpectedType>(_ expectedType: ExpectedType.Type, file: StaticString = #filePath, line: UInt = #line) {
        let matcher = ToBeTypeOf(expectation: self, expectedType: expectedType, sourceCodeLocation: SourceCodeLocation(file: file, line: line))
        let evaluationResult = matcher.evaluate()
        self.environment.resultReporter.reportResult(evaluationResult)
    }
}
