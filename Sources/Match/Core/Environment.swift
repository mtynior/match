//
//  Environment.swift
//  Match
//
//  Created by Michal on 16/10/2021.
//

import Foundation

/// Represents an Environment
public protocol EnvironmentRepresentable: AnyObject {
    /// Result reporter used by the library to output the results of the evaluations.
    var resultReporter: ResultReporter { get set }
}

/// Environment used by the Matchers
public final class Environment: EnvironmentRepresentable {
    public var resultReporter: ResultReporter
    
    /// Global environment used by all Matchers.
    ///
    /// Updates to this environment have global impact and affect all Matchers.
    /// For example, the code below will replace the default ``XCTestReporter`` reporter, and the evaluation
    /// result reported by the all Matcher will be printed on Console:
    /// ```swift
    /// final class ConsoleReporter: ResultReporter {
    ///     func reportResult(_ evaluationResult: EvaluationResultRepresentable) {
    ///         print(evaluationResult.message)
    ///     }
    /// }
    ///
    /// Environment.global.resultReporter = ConsoleReporter()
    /// ```
    public static let global = Environment()
    
    /// Creates an ``Environment`` with a specific result reporter. If the ``resultReporter`` is not provided, the ``XCTestReporter`` will be used by default.
    ///
    /// - Parameters:
    ///   - resultReporter: The ``ResultReporter`` used to output evaluation results.
    public init(resultReporter: ResultReporter = XCTestReporter()) {
        self.resultReporter = resultReporter
    }
}
