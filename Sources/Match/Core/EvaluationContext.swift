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
    
    /// The location in the Source Code where evaluation was triggered.
    public let sourceCodeLocation: SourceCodeLocation

    /// Creates a context with specific test case, name of the matcher, and location in the Source Code.
    public init(testCase: XCTestCase?, matcherName: String, sourceCodeLocation: SourceCodeLocation) {
        self.testCase = testCase
        self.matcherName = matcherName
        self.sourceCodeLocation = sourceCodeLocation
    }
}
