//
//  MockedReporter.swift
//  Match
//
//  Created by Michal on 17/10/2021.
//

@testable import Match

final class MockedReporter: ResultReporter {
    var onReportResult: ((EvaluationResultRepresentable) -> Void)?
    
    func reportResult(_ evaluationResult: EvaluationResultRepresentable) {
        onReportResult?(evaluationResult)
    }
}
