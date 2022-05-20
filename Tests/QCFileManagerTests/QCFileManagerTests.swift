import XCTest
@testable import QCFileManager

final class QCFileManagerTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(QCFileManager().text, "Hello, World!")
    }
}
