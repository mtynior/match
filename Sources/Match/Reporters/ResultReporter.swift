//
//  ResultReporter.swift
//  Match
//
//  Created by Michal on 16/10/2021.
//

import Foundation

/// Describes the Reporters that output the evaluation results
public protocol ResultReporter {
    /// Reports the evaluation result.
    ///
    /// - Parameters:
    ///     - evaluationResult: Evaluation result generated by a Matcher.
    func reportResult(_ evaluationResult: EvaluationResultRepresentable)
}
