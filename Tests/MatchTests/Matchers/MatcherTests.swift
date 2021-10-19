//
//  MatcherTests.swift
//  Match
//
//  Created by Michal on 19/10/2021.
//

import XCTest
@testable import Match

final class MatcherTests: XCTestCase {
    func testIsNegated() throws {
        // given
        let testCases: [(evaluationType: EvaluationType, shouldBeNegated: Bool, comment: String)] = [
            (evaluationType: .positive, shouldBeNegated: false, comment: "Matcher.isNegated should be false when evaluationType is .positive"),
            (evaluationType: .negated, shouldBeNegated: true, comment: "Matcher.isNegated should be true when evaluationType is .negated")
        ]
        
        for testCase in testCases {
            let expectation = MockedData.mockedExpectation(expression: { "Vader" }, testCase: nil, evaluationType: testCase.evaluationType)
            
            // when
            let matcher = MockedMatcher<String>(expectation: expectation)
            
            // then
            XCTAssertEqual(matcher.isNegated, testCase.shouldBeNegated, testCase.comment)
        }
    }
}
