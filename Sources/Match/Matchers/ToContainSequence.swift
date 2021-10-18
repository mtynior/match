//
//  ToContainSequence.swift
//  Match
//
//  Created by Michal on 18/10/2021.
//

import Foundation

/// Verifies whether a Sequence contains all the expected values.
///
/// ```swift
/// expect([1, 2, 3, 4, 5]).toContain(1) // Passes
/// expect([1, 2, 3, 4, 5]).toContain([2, 3]) // Passes
/// expect([1, 2, 3, 4, 5]).toContain(7) // Fails
/// expect([1, 2, 3, 4, 5]).toContain([1, 7]) // Fails
/// ```
///
public struct ToContainSequence<ResultType: Sequence>: Matcher where ResultType.Element: Equatable {
    public let matcherName: String = "toContain"
    
    public let expectation: Expectation<ResultType>
    
    /// Expected sequence of values.
    public let expectedValues: [ResultType.Element]
            
    public let sourceCodeLocation: SourceCodeLocation
    
    /// Creates and instance for expectation using specified expected value.
    ///
    /// - Parameters:
    ///     - expectation: Expectation used to evaluate actual value.
    ///     - expectedValues: Expected sequence of values.
    ///     - sourceCodeLocation: The location in the Source Code where evaluation was triggered.
    public init(expectation: Expectation<ResultType>, expectedValues: [ResultType.Element], sourceCodeLocation: SourceCodeLocation) {
        self.expectation = expectation
        self.expectedValues = expectedValues
        self.sourceCodeLocation = sourceCodeLocation
    }
    
    public func evaluate() -> EvaluationResult {
        guard let actualValue = try? expectation.expression.evaluate() else {
            return EvaluationResult(message: "Could not evaluate the expression", evaluationStatus: .failed, evaluationContext: evaluationContext)
        }
        
        let doesContain = expectedValues.allSatisfy {
            actualValue.contains($0)
        }
         
        let evaluationStatus = EvaluationStatus(boolValue: doesContain, evaluationType: expectation.evaluationType)
        let message: String = {
            let actualValuesLists = actualValue.compactMap({ String(describing: $0) }).joined(separator: ", ")
            let expectedValuesLists = expectedValues.compactMap({ String(describing: $0) }).joined(separator: ", ")

            switch evaluationStatus {
            case .passed:
                return "Received: [\(actualValuesLists)] does\(isNegated ? " not" : "") contain: [\(expectedValuesLists)]"
            case .failed:
                return "Expected the: [\(actualValuesLists)]\(isNegated ? " not" : "") to contain: [\(expectedValuesLists)], but it does\(isNegated ? "" : " not")"
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
public extension Expectation where ReturnType: Sequence, ReturnType.Element: Equatable {
    /// Verifies whether a Sequence contains all expected values.
    ///
    /// See the ``ToContainSequence`` for more information.
    ///
    /// - Parameters:
    ///     - expectedValues: Expected sequence of values.
    ///     - comparisonOptions: Type of comparison. By default, the comparison is case sensitive.
    ///     - file: The file where evaluation was triggered.
    ///     - line: The line number where the evaluation was triggered.
    func toContain(_ expectedValues: [ReturnType.Element], file: String = #filePath, line: UInt = #line) {
        let matcher = ToContainSequence(expectation: self, expectedValues: expectedValues, sourceCodeLocation: SourceCodeLocation(file: file, line: line))
        let evaluationResult = matcher.evaluate()
        self.environment.resultReporter.reportResult(evaluationResult)
    }
    
    /// Verifies whether a Sequence contains the expected value.
    ///
    /// See the ``ToContainSequence`` for more information.
    ///
    /// - Parameters:
    ///     - expectedValue: Expected value.
    ///     - comparisonOptions: Type of comparison. By default, the comparison is case sensitive.
    ///     - file: The file where evaluation was triggered.
    ///     - line: The line number where the evaluation was triggered.
    func toContain(_ expectedValue: ReturnType.Element, file: String = #filePath, line: UInt = #line) {
       toContain([expectedValue], file: file, line: line)
    }
}
