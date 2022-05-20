import XCTest
@testable import CasperCryptoHandlePackage

final class CasperCryptoHandlePackageTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CasperCryptoHandlePackage().text, "Hello, World!")
        let c = CasperCryptoHandlePackage()
        c.TestFunc()
        let tc = TestCall()
        tc.TestFunc()
    }
}
