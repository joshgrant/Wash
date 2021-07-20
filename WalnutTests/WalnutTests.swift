//
//  WalnutTests.swift
//  WalnutTests
//
//  Created by Joshua Grant on 6/6/21.
//

import XCTest
@testable import Walnut

class WalnutTests: XCTestCase
{
    func testInsertSpacesBetweenCamelCaseWords()
    {
        let input: [String] = ["TestWord", "CoolstorybeaNs", "   WWW   ", "none but this is cool"]
        let output: [String] = ["Test Word", "Coolstorybea Ns", "W W W", "none but this is cool"]
        
        for (i, o) in zip(input, output)
        {
            let result = i.insertSpacesBetweenCamelCaseWords()
            XCTAssertEqual(result, o)
        }
    }
}
