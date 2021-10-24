//
//  ToBeEqualString.swift
//  Match
//
//  Created by Michal on 24/10/2021.
//

import Foundation

/// Tests whether the two Strings are equal.
///
/// ```swift
/// expect("Anakin").toBeEqual("Vader") // Fails
/// expect("Anakin").toBeEqual("Anakin") // Passes
/// expect("Anakin").toBeEqual("anakin") // Fails
/// expect("Anakin").toBeEqual("anakin", comparisonOptions: .caseInsensitive) // Passes
/// ```
public struct ToBeEqualString<ResultType: StringProtocol>: Matcher {
    public let matcherName: String = "toBeEqual"
    
    public let expectation: Expectation<ResultType>
    
    /// Expected value.
    public let expectedValue: ResultType
    
    /// Type of comparison.
    public let comparisonOptions: StringComparisonOptions
        
    public let sourceCodeLocation: SourceCodeLocation
    
    /// Creates and instance for expectation using specified expected value.
    ///
    /// - Parameters:
    ///     - expectation: Expectation used to evaluate actual value.
    ///     - expectedValue: Expected value.
    ///     - sourceCodeLocation: The location in the Source Code where evaluation was triggered.
    public init(expectation: Expectation<ResultType>, expectedValue: ResultType, comparisonOptions: StringComparisonOptions, sourceCodeLocation: SourceCodeLocation) {
        self.expectation = expectation
        self.expectedValue = expectedValue
        self.comparisonOptions = comparisonOptions
        self.sourceCodeLocation = sourceCodeLocation
    }
    
    public func evaluate() -> EvaluationResult {
        guard let actualValue = try? expectation.expression.evaluate() else {
            return EvaluationResult(message: "Could not evaluate the expression", evaluationStatus: .failed, evaluationContext: evaluationContext)
        }
        
        let isEqual: Bool = {
            switch comparisonOptions {
            case .caseSensitive:
                return actualValue == expectedValue
            case .caseInsensitive:
                return actualValue.lowercased() == expectedValue.lowercased()
            }
        }()
        
        let evaluationStatus = EvaluationStatus(boolValue: isEqual, evaluationType: expectation.evaluationType)
        let message: String = {
            switch evaluationStatus {
            case .passed:
                return "Expected: \(expectedValue) is\(isNegated ? " not" : "") equal (\(comparisonOptions)) to received: \(actualValue)"
            case .failed:
                return "Expected: \(expectedValue)\(isNegated ? " not" : "") to be equal (\(comparisonOptions)) to received: \(actualValue)"
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
public extension Expectation where ReturnType: StringProtocol {
    /// Verifies whether the String values are equal.
    ///
    /// See the ``ToBeEqual`` for more information.
    ///
    /// - Parameters:
    ///     - expectedValue: Expected value.
    ///     - comparisonOptions: Type of comparison.
    ///     - file: The file where evaluation was triggered.
    ///     - line: The line number where the evaluation was triggered.
    func toBeEqual(_ expectedValue: ReturnType, comparisonOptions: StringComparisonOptions, file: StaticString = #filePath, line: UInt = #line) {
        let matcher = ToBeEqualString(
            expectation: self,
            expectedValue: expectedValue,
            comparisonOptions: comparisonOptions,
            sourceCodeLocation: SourceCodeLocation(file: file, line: line)
        )
        
        let evaluationResult = matcher.evaluate()
        self.environment.resultReporter.reportResult(evaluationResult)
    }
}
