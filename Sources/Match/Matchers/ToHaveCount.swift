//
//  ToHaveCount.swift
//  
//
//  Created by Michal on 17/10/2021.
//

/// Tests whether a collection has a expected number of elements
///
/// This matcher works with any type that conforms to the `Collection` protocol:
/// ```swift
/// expect("Anakin").toHaveCount(2) // Fails
/// expect("Anakin").toHaveCount(6) // Passes
///
/// expect([1, 2, 3, 4]).toHaveCount(2) // Fails
/// expect([1, 2, 3, 4]).toHaveCount(4) // Passes
/// ```
///
public struct ToHaveCount<ResultType: Collection>: Matcher {
    public let matcherName: String = "toHaveCount"
    
    public let expectation: Expectation<ResultType>
    
    /// Expected count.
    public let expectedCount: Int
        
    public let sourceCodeLocation: SourceCodeLocation
    
    /// Creates and instance for expectation using specified expected value.
    ///
    /// - Parameters:
    ///     - expectation: Expectation used to evaluate actual value.
    ///     - expectedCount: Expected count.
    ///     - sourceCodeLocation: The location in the Source Code where evaluation was triggered.
    public init(expectation: Expectation<ResultType>, expectedCount: Int, sourceCodeLocation: SourceCodeLocation) {
        self.expectation = expectation
        self.expectedCount = expectedCount
        self.sourceCodeLocation = sourceCodeLocation
    }
    
    public func evaluate() -> EvaluationResult {
        guard let actualValue = try? expectation.expression.evaluate() else {
            return EvaluationResult(message: "Could not evaluate the expression", evaluationStatus: .failed, evaluationContext: evaluationContext)
        }
        
        let hasCount = actualValue.count == expectedCount
        
        let evaluationStatus = EvaluationStatus(boolValue: hasCount, evaluationType: expectation.evaluationType)
        let message: String = {
            switch evaluationStatus {
            case .passed:
                return "Does\(isNegated ? " not" : "") have count of: \(expectedCount)"
            case .failed:
                return "Expected to\(isNegated ? " not" : "") have count of: \(expectedCount), but received: \(actualValue.count)"
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
    /// Verifies whether a collection has a expected number of elements.
    ///
    /// See the ``ToHaveCount`` for more information.
    ///
    /// - Parameters:
    ///     - expectedCount: Expected count.
    ///     - file: The file where evaluation was triggered.
    ///     - line: The line number where the evaluation was triggered.
    func toHaveCount(_ expectedCount: Int, file: String = #filePath, line: UInt = #line) {
        let matcher = ToHaveCount(expectation: self, expectedCount: expectedCount, sourceCodeLocation: SourceCodeLocation(file: file, line: line))
        let evaluationResult = matcher.evaluate()
        self.environment.resultReporter.reportResult(evaluationResult)
    }
}
