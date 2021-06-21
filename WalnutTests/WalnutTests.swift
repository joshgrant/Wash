//
//  WalnutTests.swift
//  WalnutTests
//
//  Created by Joshua Grant on 6/6/21.
//

import XCTest
@testable import Walnut

class WalnutTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
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
