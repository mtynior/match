//
//  ToBeCloseTo.swift
//  Match
//
//  Created by Michal on 17/10/2021.
//

import Foundation

/// Tests whether the two values are close to each other within a specified precision.
///
/// This matcher uses the `abs(actualValue - expectedValue) <= precision` formula to determine whether the values are close to each other.
///
/// By default, the ``ToBeCloseTo/defaultPrecision`` precision is used. It can be change with the second parameter:
/// ```swift
/// expect(3.005).toBeCloseTo(3.001) // Fails
/// expect(3.005).toBeCloseTo(3.001, within: 0.01) //Passes
/// ```
///
public struct ToBeCloseTo<ResultType: FloatingPoint>: Matcher {
    public let matcherName: String = "toBeCloseTo"
    
    public let expectation: Expectation<ResultType>
    
    /// Expected value.
    public let expectedValue: ResultType
    
    /// Precision used when comparing actual and expected values.
    public let precision: ResultType
    
    public let sourceCodeLocation: SourceCodeLocation
    
    /// Creates and instance for expectation using specified expected value and precision.
    ///
    /// - Parameters:
    ///     - expectation: Expectation used to evaluate actual value.
    ///     - expectedValue: Expected value.
    ///     - precision: Precision used to determine whether the actual end expected values are close to each other.
    ///     - sourceCodeLocation: The location in the Source Code where evaluation was triggered.
    public init(expectation: Expectation<ResultType>, expectedValue: ResultType, precision: ResultType, sourceCodeLocation: SourceCodeLocation) {
        self.expectation = expectation
        self.expectedValue = expectedValue
        self.precision = precision
        self.sourceCodeLocation = sourceCodeLocation
    }
    
    public func evaluate() -> EvaluationResult {
        guard let actualValue = try? expectation.expression.evaluate() else {
            return EvaluationResult(message: "Could not evaluate the expression", evaluationStatus: .failed, evaluationContext: evaluationContext)
        }
        
        let diff = abs(actualValue - expectedValue)
        let isClose = diff <= precision
        
        let evaluationStatus = EvaluationStatus(boolValue: isClose, evaluationType: expectation.evaluationType)
        let message: String = {
            switch evaluationStatus {
            case .passed:
                return "Expected: \(expectedValue) is\(isNegated ? " not" : "") close to received: \(actualValue) within: \(precision). The difference: \(diff)"
            case .failed:
                return "Expected\(isNegated ? " not" : "") to be close to: \(expectedValue) within: \(precision), but received: \(actualValue). The difference: \(diff)"
            }
        }()

        return EvaluationResult(
            message: message,
            evaluationStatus: evaluationStatus,
            evaluationContext: evaluationContext
        )
    }
}

// MARK: - Helpers
public extension ToBeCloseTo {
    /// Returns the default precision used by the matcher. At the moment the default precision is 0.0001.
    static var defaultPrecision: ResultType {
        return 1 / 10000
    }
}

// MARK: - DSL
public extension Expectation where ReturnType: FloatingPoint {
    /// Verifies whether the two `FloatingPoint` values are close to each other.
    ///
    /// See the ``ToBeCloseTo`` for more information.
    ///
    /// - Parameters:
    ///     - expectedValue: Expected value.
    ///     - precision: Precision used to determine whether the actual end expected values are close to each other.
    ///                  If explicit precision is not provided, the default one (``ToBeCloseTo/defaultPrecision``) is used.
    ///     - file: The file where evaluation was triggered.
    ///     - line: The line number where the evaluation was triggered.
    func toBeCloseTo(_ expectedValue: ReturnType, within precision: ReturnType = ToBeCloseTo.defaultPrecision, file: StaticString = #filePath, line: UInt = #line) {
        let matcher = ToBeCloseTo(expectation: self, expectedValue: expectedValue, precision: precision, sourceCodeLocation: SourceCodeLocation(file: file, line: line))
        let evaluationResult = matcher.evaluate()
        self.environment.resultReporter.reportResult(evaluationResult)
    }
}
