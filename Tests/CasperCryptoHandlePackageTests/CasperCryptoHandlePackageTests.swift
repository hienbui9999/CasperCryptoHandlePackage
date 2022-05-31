import XCTest
@testable import CasperCryptoHandlePackage

final class CasperCryptoHandlePackageTests: XCTestCase {
    func testExample() throws {
        let ed25519: Ed25519CrytoSwift  = Ed25519CrytoSwift();
       let result = ed25519.getPrivateKeyStringForPemFile(privateKeyStr: "alala bab");
        XCTAssert(result == ERROR_STRING)
    }
}
