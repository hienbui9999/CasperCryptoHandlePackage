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
    func testEd25519() {
        let ed25519:Ed25519CrytoSwift = Ed25519CrytoSwift()
        let keyPair : KeyPairClass = ed25519.generateKeyPair()
        let message = "1aa6e0b31ad18a0bc4dbcdf6b40980e32c8b106eace5ecf7970a3f84a07707f0"
        let signature = ed25519.signMessageString(messageToSign: message, privateKeyStr: keyPair.privateKeyInStr)
        XCTAssert(signature.count == 128)
        let verifyResult = ed25519.verifyMessage(signedMessage: signature, publicKeyToVerifyString: keyPair.publicKeyInStr, originalMessage: message)
        XCTAssert(verifyResult == true)
    }
    func testSecp256k1() {
        let secp256k1 : Secp256k1CryptoSwift = Secp256k1CryptoSwift()
        let keyPair:KeyPairClass = secp256k1.generateKeyPair()
        let message = "8e9351d1f3de0e5e833fe0cb723485ebcc7d9fcf92888b2795281b1a35496ad6"
        let signature = secp256k1.signMessage(messageToSign: message, withPrivateKeyPemString: keyPair.privateKeyInStr)
        XCTAssert(signature.count == 128)
        let verifyResult = secp256k1.verifyMessage(withPublicKeyPemString: keyPair.publicKeyInStr, signature: signature, plainMessage: message)
        XCTAssert(verifyResult == true)
    }
}
