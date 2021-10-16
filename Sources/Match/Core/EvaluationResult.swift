//
//  EvaluationResult.swift
//  Match
//
//  Created by Michal on 16/10/2021.
//

import Foundation
import XCTest

/// Represents a result of an evaluation.
public protocol EvaluationResultRepresentable {
    /// Message generated by a Matcher.
    var message: String { get }
    
    /// Status of an evaluation.
    var evaluationStatus: EvaluationStatus { get }
    
    /// Context used by a Matcher when evaluating a result.
    var evaluationContext: EvaluationContext { get }
}

/// A Structure that contains the result of an evaluation.
public struct EvaluationResult: EvaluationResultRepresentable {
    public let message: String
    public let evaluationStatus: EvaluationStatus
    public let evaluationContext: EvaluationContext
    
    /// Creates an instance based using message, evaluation status and context.
    ///
    /// - Parameters:
    ///     - message: Message generated by a Matcher.
    ///     - evaluationStatus: Status of the evaluation.
    ///     - evaluationContext: Context used by a Matcher when evaluating a result.
    public init(message: String, evaluationStatus: EvaluationStatus, evaluationContext: EvaluationContext) {
        self.message = message
        self.evaluationStatus = evaluationStatus
        self.evaluationContext = evaluationContext
    }
}
