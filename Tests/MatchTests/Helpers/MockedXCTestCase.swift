//
//  MockedXCTestCase.swift
//  Match
//
//  Created by Michal on 24/10/2021.
//

import XCTest

final class MockedXCTestCase: XCTestCase {
    var onRecord: ((XCTIssue) -> Void)?
    
    override func record(_ issue: XCTIssue) {
        onRecord?(issue)
    }
}
