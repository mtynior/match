//
//  ExpectationTests.swift
//  Match
//
//  Created by Michal on 16/10/2021.
//

import XCTest
@testable import Match

final class ExpectationTests: XCTestCase {
    func testCreateExpectation() {
        // given
        let expectedValue = 3
        let testCase = XCTestCase()
        let expectedEvaluationType = EvaluationType.positive
        let expectedEnvironment = Environment()
        
        // when
        let actualExpectation = Expectation(
            expression: Expression(expectedValue),
            testCase: testCase,
            evaluationType: expectedEvaluationType,
            environment: expectedEnvironment
        )
        
        // then
        XCTAssertEqual(try? actualExpectation.expression.evaluate(), expectedValue)
        XCTAssertNotNil(actualExpectation.testCase)
        XCTAssertEqual(actualExpectation.evaluationType, expectedEvaluationType)
        XCTAssertEqual(actualExpectation.environment.id, expectedEnvironment.id)
    }
    
    func testNegatedExpectation() throws {
        // given
        let expectedValue = 3
        let testCase = XCTestCase()
        let expectedEvaluationType = EvaluationType.negated
        let expectedEnvironment = Environment()
        
        let positiveExpectation = Expectation(
            expression: Expression(expectedValue),
            testCase: testCase,
            evaluationType: .positive,
            environment: expectedEnvironment
        )
        
        // when
        let negatedExpectation = positiveExpectation.not
        
        // then
        XCTAssertEqual(try? negatedExpectation.expression.evaluate(), expectedValue)
        XCTAssertNotNil(negatedExpectation.testCase)
        XCTAssertEqual(negatedExpectation.evaluationType, expectedEvaluationType)
        XCTAssertEqual(negatedExpectation.environment.id, expectedEnvironment.id)
    }
}
