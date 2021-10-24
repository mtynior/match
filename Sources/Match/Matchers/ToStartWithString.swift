//
//  ToStartWithString.swift
//  Match
//
//  Created by Michal on 19/10/2021.
//

/// Tests whether a String starts the expected substring.
///
/// ```swift
/// expect("Anakin").toStartWith("Ana") // Passes
/// expect("Anakin").toStartWith("ana") // Fails
/// expect("Anakin").toStartWith("ana", comparisonOptions: .caseInsensitive) // Passes
/// ```
///
public struct ToStartWithString<ResultType: StringProtocol>: Matcher {
    public let matcherName: String = "toStartWith"
    
    public let expectation: Expectation<ResultType>
    
    /// Expected value.
    public let expectedSubstring: ResultType
    
    /// Type of comparison.
    public let comparisonOptions: StringComparisonOptions
        
    public let sourceCodeLocation: SourceCodeLocation
    
    /// Creates and instance for expectation using specified expected value.
    ///
    /// - Parameters:
    ///     - expectation: Expectation used to evaluate actual value.
    ///     - expectedSubstring: Expected value.
    ///     - comparisonOptions: Type of comparison.
    ///     - sourceCodeLocation: The location in the Source Code where evaluation was triggered.
    public init(expectation: Expectation<ResultType>, expectedSubstring: ResultType, comparisonOptions: StringComparisonOptions, sourceCodeLocation: SourceCodeLocation) {
        self.expectation = expectation
        self.expectedSubstring = expectedSubstring
        self.comparisonOptions = comparisonOptions
        self.sourceCodeLocation = sourceCodeLocation
    }
    
    public func evaluate() -> EvaluationResult {
        guard let actualValue = try? expectation.expression.evaluate() else {
            return EvaluationResult(message: "Could not evaluate the expression", evaluationStatus: .failed, evaluationContext: evaluationContext)
        }
        
        let doesContain: Bool = {
            switch comparisonOptions {
            case .caseSensitive:
                return actualValue.hasPrefix(expectedSubstring)
            case .caseInsensitive:
                return actualValue.lowercased().hasPrefix(expectedSubstring.lowercased())
            }
        }()
        
        let evaluationStatus = EvaluationStatus(boolValue: doesContain, evaluationType: expectation.evaluationType)
        let message: String = {
            switch evaluationStatus {
            case .passed:
                return "Received: \(actualValue) does\(isNegated ? " not" : "") start with (\(comparisonOptions)): \(expectedSubstring)"
            case .failed:
                return "Expected the: \(actualValue)\(isNegated ? " not" : "") to start with (\(comparisonOptions)): \(expectedSubstring), but it does\(isNegated ? "" : " not")"
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
    /// Verifies whether a String starts with the expected substring.
    ///
    /// See the ``ToStartWithString`` for more information.
    ///
    /// - Parameters:
    ///     - expectedSubstring: Expected substring.
    ///     - comparisonOptions: Type of comparison. By default, the comparison is case sensitive.
    ///     - file: The file where evaluation was triggered.
    ///     - line: The line number where the evaluation was triggered.
    func toStartWith(_ expectedSubstring: ReturnType, comparisonOptions: StringComparisonOptions = .caseSensitive, file: StaticString = #filePath, line: UInt = #line) {
        let matcher = ToStartWithString(
            expectation: self,
            expectedSubstring: expectedSubstring,
            comparisonOptions: comparisonOptions,
            sourceCodeLocation: SourceCodeLocation(file: file, line: line)
        )
        
        let evaluationResult = matcher.evaluate()
        self.environment.resultReporter.reportResult(evaluationResult)
    }
}
