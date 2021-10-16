//
//  Expression.swift
//  Match
//
//  Created by Michal on 16/10/2021.
//

import Foundation

/// Describes an Expression
public protocol ExpressionRepresentable {
    associatedtype ResultType
    
    // Executes the expression code and returns the result.
    func evaluate() throws -> ResultType
}

/// Contains information about expression that will be evaluated.
public struct Expression<ResultType>: ExpressionRepresentable {
    private let handler: () throws -> ResultType
    
    /// Creates an instance of an expression from a autoclosure.
    ///
    public init(_ handler: @autoclosure @escaping () throws -> ResultType) {
        self.handler = handler
    }
    
    /// Creates an instance of an expression from a regular closure.
    public init(_ handler: @escaping () throws -> ResultType) {
        self.handler = handler
    }
    
    /// Executes the expression and returns result value.
    public func evaluate() throws -> ResultType {
        return try handler()
    }
}
