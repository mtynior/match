//
//  XCTestReporterTests.swift
//  Match
//
//  Created by Michal on 24/10/2021.
//

import XCTest
@testable import Match

final class XCTestReporterTests: XCTestCase {
    func testReportResultWithTestCase() {
        // given
        let expectedMessage = "Expected value: 5 is not greater than received: 88"
        
        // and
        let recordIssueExpectation = expectation(description: "Should call XCTestCase.recordIssue(:)")
        let mockedTestCase = MockedXCTestCase()
        mockedTestCase.onRecord = { issue in
            if issue.compactDescription == expectedMessage {
                recordIssueExpectation.fulfill()
            }
        }
        
        // and
        let evaluationResult = EvaluationResult(
            message: expectedMessage,
            evaluationStatus: .failed,
            evaluationContext: EvaluationContext(
                testCase: mockedTestCase,
                matcherName: "testMatcher",
                sourceCodeLocation: MockedData.mockedSourceCodeLocation()
            )
        )
        
        // when
        let reporter = XCTestReporter()
        reporter.reportResult(evaluationResult)
        
        // then
        waitForExpectations(timeout: 10)
    }
    
    func testReportResultWithoutTestCase() {
        // given
        let expectedMessage = "a failure message."
        
        // and
        let evaluationResult = EvaluationResult(
            message: expectedMessage,
            evaluationStatus: .failed,
            evaluationContext: EvaluationContext(
                testCase: nil,
                matcherName: "testMatcher",
                sourceCodeLocation: SourceCodeLocation(file: #file, line: 69)
            )
        )
        
        // and
        let options = XCTExpectedFailure.Options()
        options.issueMatcher = { issue in
            return issue.type == .assertionFailure && issue.compactDescription.contains(expectedMessage)
        }
            
        // then
        XCTExpectFailure("Should report failure", options: options) {
            // when
            let reporter = XCTestReporter()
            reporter.reportResult(evaluationResult)
        }
    }
}
