//
//  ToContainSetAlgebra.swift
//  Match
//
//  Created by Michal on 18/10/2021.
//

import Foundation

/// Verifies whether a SetAlgebra contains all the expected values.
///
/// ```swift
/// struct RefreshOptions: OptionSet {
///     let rawValue: Int8
///
///     static let hourly = RefreshOptions(rawValue: 1 << 0)
///     static let daily = RefreshOptions(rawValue: 1 << 1)
///     static let weekly = RefreshOptions(rawValue: 1 << 2)
///     static let monthly = RefreshOptions(rawValue: 1 << 3)
///     static let yearly = RefreshOptions(rawValue: 1 << 4)
/// }
///
/// let set: RefreshOptions = [.hourly, .daily, .weekly, .monthly]
///
/// expect(set).toContain(.daily) // Passes
/// expect(set).toContain([.hourly, .daily]) // Passes
/// expect(set).toContain(.yearly) // Fails
/// expect(set).toContain([.daily, .yearly]) // Fails
/// ```
///
public struct ToContainSetAlgebra<ResultType: SetAlgebra>: Matcher where ResultType.Element: Equatable {
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
            let expectedValuesLists = expectedValues.compactMap({ String(describing: $0) }).joined(separator: ", ")

            switch evaluationStatus {
            case .passed:
                return "Received: \(actualValue) does\(isNegated ? " not" : "") contain: \(expectedValuesLists)"
            case .failed:
                return "Expected the: \(actualValue)\(isNegated ? " not" : "") to contain: \(expectedValuesLists), but it does\(isNegated ? "" : " not")"
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
public extension Expectation where ReturnType: SetAlgebra, ReturnType.Element: Equatable {
    /// Verifies whether a SetAlgebra contains all expected values.
    ///
    /// See the ``ToContainSetAlgebra`` for more information.
    ///
    /// - Parameters:
    ///     - expectedValues: Expected sequence of values.
    ///     - comparisonOptions: Type of comparison. By default, the comparison is case sensitive.
    ///     - file: The file where evaluation was triggered.
    ///     - line: The line number where the evaluation was triggered.
    func toContain(_ expectedValues: [ReturnType.Element], file: String = #filePath, line: UInt = #line) {
        let matcher = ToContainSetAlgebra(expectation: self, expectedValues: expectedValues, sourceCodeLocation: SourceCodeLocation(file: file, line: line))
        let evaluationResult = matcher.evaluate()
        self.environment.resultReporter.reportResult(evaluationResult)
    }
    
    /// Verifies whether a SetAlgebra contains the expected value.
    ///
    /// See the ``ToContainSetAlgebra`` for more information.
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
