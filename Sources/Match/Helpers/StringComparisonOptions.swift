//
//  StringComparisonOptions.swift
//  Match
//
//  Created by Michal on 18/10/2021.
//

import Foundation

/// Indicates how to compare two strings
public enum StringComparisonOptions: CustomStringConvertible {
    /// Compare respecting case sensitivity.
    case caseSensitive
    /// Compare ignoring case sensitivity.
    case caseInsensitive
    
    /// Returns human-readable description of the current option.
    public var description: String {
        switch self {
        case .caseInsensitive: return "case insensitive"
        case .caseSensitive: return "case sensitive"
        }
    }
}
