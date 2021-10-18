//
//  ToContainSetAlgebraTests.swift
//  Match
//
//  Created by Michal on 18/10/2021.
//

import XCTest
@testable import Match

final class ToContainSetAlgebraTests: XCTestCase {
    private let set: RefreshOptions = [.hourly, .daily, .weekly, .monthly]

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
            makeMatcher(actualValue: set, expectedValues: [.daily]).evaluate().evaluationStatus,
            .passed,
            "ToContainSetAlgebra should be evaluated as `passed` when a SetAlgebra contains a value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: set, expectedValues: [.yearly]).evaluate().evaluationStatus,
            .failed,
            "ToContainSetAlgebra should be evaluated as `failed` when a SetAlgebra does not contain a value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: set, expectedValues: [.daily, .weekly]).evaluate().evaluationStatus,
            .passed,
            "ToContainSetAlgebra should be evaluated as `passed` when a SetAlgebra contains all expected values"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: set, expectedValues: [.daily, .yearly]).evaluate().evaluationStatus,
            .failed,
            "ToContainSetAlgebra should be evaluated as `failed` when a SetAlgebra does not contain all expected values"
        )
    }
    
    func testNegatedEvaluation() throws {
        XCTAssertEqual(
            makeMatcher(actualValue: set, expectedValues: [.daily], evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToContainSetAlgebra should be evaluated as `failed` when a SetAlgebra contains a value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: set, expectedValues: [.yearly], evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToContainSetAlgebra should be evaluated as `passed` when a SetAlgebra does not contain a value"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: set, expectedValues: [.daily, .weekly], evaluationType: .negated).evaluate().evaluationStatus,
            .failed,
            "Negated ToContainSetAlgebra should be evaluated as `failed` when a SetAlgebra contains all expected values"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: set, expectedValues: [.daily, .yearly], evaluationType: .negated).evaluate().evaluationStatus,
            .passed,
            "Negated ToContainSetAlgebra should be evaluated as `passed` when a SetAlgebra does not contain all expected values"
        )
    }
        
    func testMessages() throws {
        let set: RefreshOptions = [.hourly, .daily, .weekly, .monthly]

        // Failures
        XCTAssertEqual(
            makeMatcher(actualValue: set, expectedValues: [.yearly]).evaluate().message,
            "Expected the: RefreshOptions(rawValue: 15) to contain: RefreshOptions(rawValue: 16), but it does not"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: set, expectedValues: [.daily], evaluationType: .negated).evaluate().message,
            "Expected the: RefreshOptions(rawValue: 15) not to contain: RefreshOptions(rawValue: 2), but it does"
        )
        
        // Successes
        XCTAssertEqual(
            makeMatcher(actualValue: set, expectedValues: [.daily]).evaluate().message,
            "Received: RefreshOptions(rawValue: 15) does contain: RefreshOptions(rawValue: 2)"
        )
        
        XCTAssertEqual(
            makeMatcher(actualValue: set, expectedValues: [.yearly], evaluationType: .negated).evaluate().message,
            "Received: RefreshOptions(rawValue: 15) does not contain: RefreshOptions(rawValue: 16)"
        )
    }
    
    func testMatcherName() throws {
        // given
        let expectedResult = "toContain"
       
        // when
        let actualMatcher = makeMatcher(actualValue: set, expectedValues: [.yearly])
        
        // then
        XCTAssertEqual(actualMatcher.matcherName, expectedResult)
    }
    
    func testReportEvaluationResult() throws {
        // given
        let reportExpectation = expectation(description: "toContain() should report the evaluation result")
        
        mockedReporter.onReportResult = { _ in
            reportExpectation.fulfill()
        }
       
        // and

        // when
        expect(self.set).toContain(.monthly)
        
        // then
        waitForExpectations(timeout: 5)
    }
}

private extension ToContainSetAlgebraTests {
    struct RefreshOptions: OptionSet {
        let rawValue: Int8

        static let hourly = RefreshOptions(rawValue: 1 << 0)
        static let daily = RefreshOptions(rawValue: 1 << 1)
        static let weekly = RefreshOptions(rawValue: 1 << 2)
        static let monthly = RefreshOptions(rawValue: 1 << 3)
        static let yearly = RefreshOptions(rawValue: 1 << 4)
    }
    
    func makeMatcher<T: SetAlgebra>(actualValue: T, expectedValues: [T.Element], evaluationType: EvaluationType = .positive) -> ToContainSetAlgebra<T> {
        return ToContainSetAlgebra(
            expectation: MockedData.mockedExpectation(value: actualValue, evaluationType: evaluationType),
            expectedValues: expectedValues,
            sourceCodeLocation: MockedData.mockedSourceCodeLocation()
        )
    }
}
