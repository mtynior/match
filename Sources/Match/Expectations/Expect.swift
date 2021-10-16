//
//  Expect.swift
//  Match
//
//  Created by Michal on 16/10/2021.
//

import Foundation
import XCTest

public extension XCTestCase {
    /// Creates an Expectation for specified expression.
    ///
    /// Creates a positive Expectation for the @autoclosure expression.
    /// Created instance uses the current test case and ``Environment.global`` environment.
    ///
    /// - Parameters:
    ///     - expression: Expression that will be evaluated.
    func expect<ResultType>(_ expression: @autoclosure @escaping () throws -> ResultType) -> Expectation<ResultType> {
        Expectation(expression: Expression(expression), testCase: self, evaluationType: .positive, environment: Environment.global)
    }
    
    /// Creates an Expectation for specified expression.
    ///
    /// Creates a positive Expectation for the closure expression.
    /// Created instance uses the current test case and ``Environment.global`` environment.
    ///
    /// - Parameters:
    ///     - expression: Expression that will be evaluated.
    func expect<ResultType>(_ expression: @escaping () throws -> ResultType) -> Expectation<ResultType> {
        Expectation(expression: Expression(expression), testCase: self, evaluationType: .positive, environment: Environment.global)
    }
}
