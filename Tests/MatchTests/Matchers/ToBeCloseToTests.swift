//
//  ToBeCloseToTests.swift
//  Match
//
//  Created by Michal on 17/10/2021.
//

import XCTest
@testable import Match

final class ToBeCloseToTests: XCTestCase {
    var mockedReporter: MockedReporter!
    
    override func setUpWithError() throws {
        mockedReporter = MockedReporter()
        Environment.global.resultReporter = mockedReporter
    }

    override func tearDownWithError() throws {
        mockedReporter = nil
    }

    func testPositiveMatching() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: 0, expectedValue: 0, precision: nil).evaluate().evaluationStatus,
            .passed,
            "ToBeClose should be evaluated as `passed` for equal values"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 3.14, expectedValue: 3.15, precision: 0.01).evaluate().evaluationStatus,
            .passed,
            "ToBeClose should be evaluated as `passed` for actual value close to expected value within implicit precision"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 3.0001, expectedValue: 3.0001, precision: nil).evaluate().evaluationStatus,
            .passed,
            "ToBeClose should be evaluated as `passed` for actual value close to expected value within default precision"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 3.14, expectedValue: 3.5, precision: 0.1).evaluate().evaluationStatus,
            .failed,
            "ToBeClose should be evaluated as `failed` for actual value not close to expected value within implicit precision"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 3.14, expectedValue: 3.5, precision: nil).evaluate().evaluationStatus,
            .failed,
            "ToBeClose should be evaluated as `failed` for actual value not close to expected value within default precision"
        )
    }
    
    func testNegatedMatching() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: 0, expectedValue: 0, precision: nil, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToBeClose should be evaluated as `failed` for equal values"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 3.14, expectedValue: 3.15, precision: 0.01, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToBeClose should be evaluated as `failed` for actual value close to expected value within implicit precision"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 3.0001, expectedValue: 3.0001, precision: nil, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToBeClose should be evaluated as `failed` for actual value close to expected value within default precision"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 3.14, expectedValue: 3.5, precision: 0.1, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToBeClose should be evaluated as `passed` for actual value not close to expected value within implicit precision"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 3.14, expectedValue: 3.5, precision: nil, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToBeClose should be evaluated as `passed` for actual value not close to expected value within default precision"
        )
    }
    
    func testMessages() throws {
        // Failures
        XCTAssertEqual(
            makeMatcher(actualValue: 3.14, expectedValue: 3.5, precision: 0.001).evaluate().message,
            "Expected to be close to: \(3.5) within: \(0.001), but received: \(3.14). The difference: \(abs(3.14-3.5))"
        )
                
        XCTAssertEqual(
            makeMatcher(actualValue: 3.14, expectedValue: 3.5, precision: 0.5, evaluationType: .negated).evaluate().message,
            "Expected not to be close to: \(3.5) within: \(0.5), but received: \(3.14). The difference: \(abs(3.14-3.5))"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(actualValue: 3.14, expectedValue: 3.5, precision: 0.5).evaluate().message,
            "Expected: \(3.5) is close to received: \(3.14) within: \(0.5). The difference: \(abs(3.14-3.5))"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: 3.14, expectedValue: 3.5, precision: 0.1, evaluationType: .negated).evaluate().message,
            "Expected: \(3.5) is not close to received: \(3.14) within: \(0.1). The difference: \(abs(3.14-3.5))"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toBeCloseTo"
       
        // when
        let actualMatcher = makeMatcher(actualValue: 3.14, expectedValue: 3.5, precision: 0.0001)
        
        // then
        XCTAssertEqual(actualMatcher.matcherName, expectedResult)
    }
    
    func testReportEvaluationResult() throws {
        // given
        let reportExpectation = expectation(description: "toBeCloseTo() should report the evaluation result")
        
        mockedReporter.onReportResult = { _ in
            reportExpectation.fulfill()
        }
       
        // when
        expect(3.14).toBeCloseTo(3.5)
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToBeCloseToTests {
    func makeMatcher<T: FloatingPoint>(actualValue: T, expectedValue: T, precision: T?, evaluationType: EvaluationType = .positive) -> ToBeCloseTo<T> {
        let precision = precision ?? ToBeCloseTo.defaultPrecision
        
        return ToBeCloseTo(
            expectation: MockedData.mockedExpectation(value: actualValue, evaluationType: evaluationType),
            expectedValue: expectedValue,
            precision: precision,
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
