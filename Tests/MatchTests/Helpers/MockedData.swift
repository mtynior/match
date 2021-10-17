//
//  MockedData.swift
//  Match
//
//  Created by Michal on 17/10/2021.
//

@testable import Match
import XCTest

enum MockedData {
    static func mockedExpectation<T>(value: T, testCase: XCTestCase? = nil, evaluationType: EvaluationType = .positive, environment: EnvironmentRepresentable = Environment.global) -> Expectation<T> {
        Expectation(expression: Expression(value), testCase: testCase, evaluationType: evaluationType, environment: Environment.global)
    }
    
    static func mockedSourceCodeLocation(file: String = "FileUnderTests.swift", line: UInt = 15) -> SourceCodeLocation {
         SourceCodeLocation(file: file, line: line)
    }
}
