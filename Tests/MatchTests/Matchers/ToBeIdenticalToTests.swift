//
//  ToBeIdenticalToTests.swift
//  Match
//
//  Created by Michal on 17/10/2021.
//

import XCTest
@testable import Match

final class ToBeIdenticalToTests: XCTestCase {
    private let object1 = XWing()
    private let object2 = XWing()
    
    var mockedReporter: MockedReporter!
    
    override func setUpWithError() throws {
        mockedReporter = MockedReporter()
        Environment.global.resultReporter = mockedReporter
    }

    override func tearDownWithError() throws {
        mockedReporter = nil
    }

    func testPositiveEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: object1, expectedValue: object1).evaluate().evaluationStatus,
            .passed,
            "ToBeIdenticalTo should be evaluated as `passed` for the same objects"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: object1, expectedValue: object2).evaluate().evaluationStatus,
            .failed,
            "ToBeIdenticalTo should be evaluated as `failed` for not the same objects"
        )
    }
    
    func testNegatedEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: object1, expectedValue: object1, evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToBeIdenticalTo should be evaluated as `failed` for the same objects"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: object1, expectedValue: object2, evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToBeIdenticalTo should be evaluated as `passed` for not the same objects"
        )
    }
    
    func testMessages() throws {
        // Failures
        XCTAssertEqual(
            makeMatcher(actualValue: object1, expectedValue: object2).evaluate().message,
            "Expected: \(object2) to be identical to received: \(object1)"
        )
                
        XCTAssertEqual(
            makeMatcher(actualValue: object1, expectedValue: object1, evaluationType: .negated).evaluate().message,
            "Expected: \(object2) not to be identical to received: \(object1)"
        )
                
        // Successes
        XCTAssertEqual(
            makeMatcher(actualValue: object1, expectedValue: object1).evaluate().message,
            "Expected: \(object1) is identical to received: \(object1)"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: object1, expectedValue: object2, evaluationType: .negated).evaluate().message,
            "Expected: \(object2) is not identical to received: \(object1)"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toBeIdenticalTo"
       
        // when
        let actualMatcher = makeMatcher(actualValue: object1, expectedValue: object2)
        
        // then
        XCTAssertEqual(actualMatcher.matcherName, expectedResult)
    }
    
    func testReportEvaluationResult() throws {
        // given
        let reportExpectation = expectation(description: "toBeIdenticalTo() should report the evaluation result")
        
        mockedReporter.onReportResult = { _ in
            reportExpectation.fulfill()
        }
       
        // when
        expect(self.object1).toBeIdenticalTo(object2)
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToBeIdenticalToTests {
    class XWing {}
    
    func makeMatcher<T: AnyObject>(actualValue: T, expectedValue: T, evaluationType: EvaluationType = .positive) -> ToBeIdenticalTo<T> {
        return ToBeIdenticalTo(
            expectation: MockedData.mockedExpectation(value: actualValue, evaluationType: evaluationType),
            expectedValue: expectedValue,
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
