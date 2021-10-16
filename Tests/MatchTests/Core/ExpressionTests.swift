//
//  ExpressionTests.swift
//  Match
//
//  Created by Michal on 16/10/2021.
//

import XCTest
@testable import Match

final class ExpressionTests: XCTestCase {
    func testExpressionWithValue() throws {
        // given
        let expectedValue = 3
        
        // when
        let expression = Expression(3)
        let actualValue = try? expression.evaluate()
        
        // then
        XCTAssertEqual(actualValue, expectedValue)
    }
    
    func testExpressionWithFunction() throws {
        // given
        let expectedValue = 3
        
        // and
        func sum(_ param1: Int, _ param2: Int) -> Int { param1 + param2 }
        
        // when
        let expression = Expression(sum(1, 2))
        let actualValue = try? expression.evaluate()
        
        // then
        XCTAssertEqual(actualValue, expectedValue)
    }
    
    func testExpressionWithClosure() throws {
        // given
        let expectedValue = 5
        
        // when
        let expression = Expression({ 3 + 2 })
        let actualValue = try? expression.evaluate()
        
        // then
        XCTAssertEqual(actualValue, expectedValue)
    }
}
