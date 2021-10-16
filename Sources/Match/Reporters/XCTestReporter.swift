//
//  XCTestReporter.swift
//  Match
//
//  Created by Michal on 16/10/2021.
//

import Foundation
import XCTest

/// Reporter that uses the XCTest framework to output the evaluation results.
///
/// This reporter only outputs the evaluations that failed. The succeeded ones are being ignored.
public final class XCTestReporter: ResultReporter {
    /// Creates the reporter instance.
    public init() {}
    
    public func reportResult(_ evaluationResult: EvaluationResultRepresentable) {
        guard evaluationResult.evaluationStatus == .failed else {
            return
        }
 
        guard let testCase = evaluationResult.evaluationContext.testCase else {
            XCTFail(evaluationResult.message)
            return
        }
        
        let issue = XCTIssue(type: .assertionFailure, compactDescription: evaluationResult.message)
        testCase.record(issue)
    }
}
