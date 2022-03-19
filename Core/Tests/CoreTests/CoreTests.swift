import XCTest
@testable import Core

final class CoreTests: XCTestCase
{
    func testParseTypeDouble()
    {
        let arguments = ["-143.24"]
        let double: Double? = parseType(from: arguments)
        XCTAssertEqual(double, -143.24)
    }
    
    func testParseTypeBoolean()
    {
        let arguments = ["true"]
        let bool: Bool? = parseType(from: arguments)
        XCTAssertEqual(bool, true)
    }
}
