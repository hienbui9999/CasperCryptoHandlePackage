import XCTest
@testable import CasperCryptoHandlePackage

final class CasperCryptoHandlePackageTests: XCTestCase {
    func testExample() throws {
        let ed25519: Ed25519CrytoSwift  = Ed25519CrytoSwift()
       let result = ed25519.getPrivateKeyStringForPemFile(privateKeyStr: "alala bab")
        XCTAssert(result == ERROR_STRING)
        let result2 = ed25519.getPrivateKeyStringForPemFile(privateKeyStr: "1_a_2_b")
         XCTAssert(result2 == ERROR_STRING)
        let result3 = ed25519.getPrivateKeyStringForPemFile(privateKeyStr: "1_2_2_3")
         XCTAssert(result3 == ERROR_STRING)
    }
    func testSecp256k1() {
        let secp256k1 : Secp256k1CryptoSwift = Secp256k1CryptoSwift()
        let keyPair:KeyPairClass = secp256k1.generateKeyPair()
        let message = "8e9351d1f3de0e5e833fe0cb723485ebcc7d9fcf92888b2795281b1a35496ad6"
        let signature = secp256k1.signMessage(messageToSign: message, withPrivateKeyPemString: keyPair.privateKeyInStr)
        let verifyResult = secp256k1.verifyMessage(withPublicKeyPemString: keyPair.publicKeyInStr, signature: signature, plainMessage: message)
    }
}
