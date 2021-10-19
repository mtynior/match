//
//  ToMatch.swift
//  Match
//
//  Created by Michal on 19/10/2021.
//

import Foundation

/// Tests whether the actual value matches regex.
///
/// ```swift
/// expect("Luke").toMatch(#"^[0-9]*$"#) // Fails
/// expect("2349").toMatch(#"^[0-9]*$"#) // Passes
/// ```
///
public struct ToMatch<ResultType: StringProtocol>: Matcher {
    public let matcherName: String = "toMatch"
    
    public let expectation: Expectation<ResultType>
    
    /// Regex.
    public let regex: String
        
    public let sourceCodeLocation: SourceCodeLocation
    
    /// Creates and instance for expectation using specified expected value.
    ///
    /// - Parameters:
    ///     - expectation: Expectation used to evaluate actual value.
    ///     - regex: Regex.
    ///     - sourceCodeLocation: The location in the Source Code where evaluation was triggered.
    public init(expectation: Expectation<ResultType>, regex: String, sourceCodeLocation: SourceCodeLocation) {
        self.expectation = expectation
        self.regex = regex
        self.sourceCodeLocation = sourceCodeLocation
    }
    
    public func evaluate() -> EvaluationResult {
        guard let actualValue = try? expectation.expression.evaluate() else {
            return EvaluationResult(message: "Could not evaluate the expression", evaluationStatus: .failed, evaluationContext: evaluationContext)
        }
        
        let doesMatch = actualValue.range(of: regex, options: .regularExpression) != nil
        
        let evaluationStatus = EvaluationStatus(boolValue: doesMatch, evaluationType: expectation.evaluationType)
        let message: String = {
            switch evaluationStatus {
            case .passed:
                return "Received value: \(actualValue) does\(isNegated ? " not" : "") match the regex"
            case .failed:
                return "Expected\(isNegated ? " not" : "") to match the regex"
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
    /// Verifies whether the actual value matches regex..
    ///
    /// See the ``ToMatch`` for more information.
    ///
    /// - Parameters:
    ///     - regex: Regex.
    ///     - file: The file where evaluation was triggered.
    ///     - line: The line number where the evaluation was triggered.
    func toMatch(_ regex: String, file: String = #filePath, line: UInt = #line) {
        let matcher = ToMatch(expectation: self, regex: regex, sourceCodeLocation: SourceCodeLocation(file: file, line: line))
        let evaluationResult = matcher.evaluate()
        self.environment.resultReporter.reportResult(evaluationResult)
    }
}
