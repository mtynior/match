//
//  EvaluationContext.swift
//  Match
//
//  Created by Michal on 16/10/2021.
//

import Foundation
import XCTest

/// The context used by a matcher when evaluating a result.
public struct EvaluationContext {
    /// XCTestCase inside which the evaluation was triggered
    public weak var testCase: XCTestCase?
    
    /// Name of the matcher
    public let matcherName: String
    
    /// The file where evaluation was triggered.
    public let file: String
    
    /// The line number where the evaluation was triggered.
    public let line: UInt
    
    /// Creates a context with specific test case, name of the matcher, file, and line number
    public init(testCase: XCTestCase?, matcherName: String, file: String, line: UInt) {
        self.testCase = testCase
        self.matcherName = matcherName
        self.file = file
        self.line = line
    }
}
