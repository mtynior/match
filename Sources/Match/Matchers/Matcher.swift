//
//  Matcher.swift
//  Match
//
//  Created by Michal on 17/10/2021.
//

import Foundation

/// Represents a Matcher
public protocol Matcher {
    associatedtype ResultType
    
    /// Name of the Matcher
    var matcherName: String { get }
    
    /// ``Expectation`` that will be evaluated by the Matcher.
    var expectation: Expectation<ResultType> { get }
    
    /// The location in the Source Code where evaluation was triggered.
    var sourceCodeLocation: SourceCodeLocation { get }
    
    /// Tests the expectation and return the result of the evaluation.
    func evaluate() -> EvaluationResult
}

public extension Matcher {
    /// Indicates whether the ``Expectation``'s evaluation type is negated.
    var isNegated: Bool {
        expectation.evaluationType == .negated
    }
    
    var evaluationContext: EvaluationContext {
        EvaluationContext(testCase: expectation.testCase, matcherName: matcherName, sourceCodeLocation: sourceCodeLocation)
    }
}
