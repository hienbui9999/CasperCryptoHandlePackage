import XCTest
@testable import CasperCryptoHandlePackage

final class CasperCryptoHandlePackageTests: XCTestCase {
    func testExample() throws {
        let ed25519: Ed25519CrytoSwift  = Ed25519CrytoSwift();
       let result = ed25519.getPrivateKeyStringForPemFile(privateKeyStr: "alala bab");
        XCTAssert(result == ERROR_STRING)
        let result2 = ed25519.getPrivateKeyStringForPemFile(privateKeyStr: "1_a_2_b");
         XCTAssert(result2 == ERROR_STRING)
        let result3 = ed25519.getPrivateKeyStringForPemFile(privateKeyStr: "1_2_2_3");
         XCTAssert(result3 == ERROR_STRING)
        let publicKeyStr : String = "193_217_81_235_134_72_92_67_132_237_25_54_134_236_29_81_142_154_51_32_139_95_107_91_197_217_99_130_145_16_30_32"
        let publicKey = ed25519.getPublicKeyStringFromPemString(pemStr: publicKeyStr)
        
    }
}
