//
//  EvaluationStatus.swift
//  Match
//
//  Created by Michal on 16/10/2021.
//

import Foundation

/// Indicates the whether the evaluation succeeded or failed.
public enum EvaluationStatus: Equatable {
    /// Represents successful evaluation.
    case passed
    /// Represents failed evaluation.
    case failed
    
    /// Creates the status based on `Bool` value and evaluation type.
    ///
    /// - Parameters:
    ///     - boolValue: Indicates whether test under evaluation has passed or not. Use `true` for tests that passed the evaluation, otherwise use `false`.
    ///     - evaluationType: Indicated whether it was positive or negated evaluation.
    public init(boolValue: Bool, evaluationType: EvaluationType) {
        switch (boolValue, evaluationType) {
        case (false, .positive), (true, .negated):
            self = .failed
        default:
            self = .passed
        }
    }
}
