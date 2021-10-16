//
//  ExpectTest.swift
//  Match
//
//  Created by Michal on 16/10/2021.
//

import XCTest
@testable import Match

final class ExpectTest: XCTestCase {
    func testExpectationForAutoclosure() throws {
        // given
        let expectedValue = 3
        
        // when
        let actualExpectation = expect(3)
        
        // then
        XCTAssertEqual(try? actualExpectation.expression.evaluate(), expectedValue)
        XCTAssertNotNil(actualExpectation.testCase)
        XCTAssertEqual(actualExpectation.evaluationType, .positive)
        XCTAssertEqual(actualExpectation.environment.id, Environment.global.id)
    }
    
    func testExpectationForClosure() throws {
        // given
        let expectedValue = 3
        
        // when
        let actualExpectation = expect({ 1 + 2 })
        
        // then
        XCTAssertEqual(try? actualExpectation.expression.evaluate(), expectedValue)
        XCTAssertNotNil(actualExpectation.testCase)
        XCTAssertEqual(actualExpectation.evaluationType, .positive)
        XCTAssertEqual(actualExpectation.environment.id, Environment.global.id)
    }
}
