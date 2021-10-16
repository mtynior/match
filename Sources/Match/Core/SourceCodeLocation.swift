//
//  SourceCodeLocation.swift
//  Match
//
//  Created by Michal on 16/10/2021.
//

import Foundation

/// A Structure that contains a location in the Source Code
public struct SourceCodeLocation {
    /// The file where evaluation was triggered.
    public let file: String
    
    /// The line number where the evaluation was triggered.
    public let line: UInt
}
