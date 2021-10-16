//
//  Expectation.swift
//  Match
//
//  Created by Michal on 16/10/2021.
//

import Foundation
import XCTest

/// Represents an Expectation that will be evaluated
public struct Expectation<ReturnType> {
    /// Expression that will be evaluated.
    let expression: Expression<ReturnType>
   
    /// XCTestCase inside which the Expectation was created.
    public weak var testCase: XCTestCase?
    
    /// Indicates whether this is standard or negated evaluation.
    public let evaluationType: EvaluationType
    
    /// Environment used then evaluation was triggered
    let environment: EnvironmentRepresentable
    
    /// Returns the negated version of the current Expectation.
    ///
    /// Creates a copy of the current ``Expectation`` with the ``evaluationType`` set to ``EvaluationType/negated``.
    public var not: Expectation<ReturnType> {
        Expectation(expression: expression, testCase: testCase, evaluationType: .negated, environment: environment)
    }
    
    /// Creates an instance of an ``Expectation`` for expression, triggered inside a test case, and using specified evaluationType and environment.
    ///
    /// - Parameters:
    ///     - expression: Expression that will be evaluated.
    ///     - testCase: XCTestCase inside which the Expectation was created.
    ///     - evaluationType: Indicates whether this is standard or negated evaluation.
    ///     - environment: Environment used then evaluation was triggered.
    public init(expression: Expression<ReturnType>, testCase: XCTestCase?, evaluationType: EvaluationType, environment: EnvironmentRepresentable) {
        self.expression = expression
        self.testCase = testCase
        self.evaluationType = evaluationType
        self.environment = environment
    }
}
