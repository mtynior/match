//
//  StringComparisonOptions.swift
//  Match
//
//  Created by Michal on 18/10/2021.
//

import Foundation

public enum StringComparisonOptions: CustomStringConvertible {
    case caseSensitive
    case caseInsensitive
    
    public var description: String {
        switch self {
        case .caseInsensitive: return "case insensitive"
        case .caseSensitive: return "case sensitive"
        }
    }
}
