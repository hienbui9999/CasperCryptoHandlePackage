import Foundation
import SwiftECC
/**
 Secp256k1 wrapper class. This class allow user to do the following task in secp256k1 encryption:
 - Generate private key, public key
 - Load private key, public key from Pem file
 - Write private key, public key to Pem file
 - Sign message
 - Verify message
 */
@objcMembers public class Secp256k1CryptoSwift :NSObject {
    /// Generate key pair
    public func generateKeyPair() -> KeyPairClass {
        let ret = KeyPairClass();
        let domain = Domain.instance(curve: .EC256k1)
        let (publicKey, privateKey) = domain.makeKeyPair()
        ret.privateKeyInStr = privateKey.pem
        ret.publicKeyInStr = publicKey.pem
        print("private der bytes is:\(privateKey.der)")
        print("public der bytes is:\(publicKey.der)")
        return ret
    }
/**
   This function checks if a pem string can turn to a private key
   - Parameter: Pem string
   - Returns: true if the pem can generate the private key, false otherwise
   */
    public func checkPrivateKeyPemStringValid(pemString: String) -> Bool {
        do {
            let privateKey = try ECPrivateKey.init(pem: pemString)
            return true
        } catch {
            return false
        }
    }
    /**
       This function checks if a pem string can turn to a public key
       - Parameter: Pem string
       - Returns: true if the pem can generate the public key, false otherwise
       */
    public func checkPublicKeyPemStringValid(pemString: String) -> Bool {
        do {
            let publicKey = try ECPublicKey.init(pem: pemString)
            return true
        } catch {
            return false
        }
    }

    public func signMessage(messageToSign: Data, withPrivateKey: ECPrivateKey) -> ECSignature {
        print("With EC, private key information s asSignedBytes:\(withPrivateKey.s.asSignedBytes())")
        let signatureF = withPrivateKey.sign(msg: messageToSign, deterministic: false)
        let signatureF1 = withPrivateKey.sign(msg: messageToSign, deterministic: false)
        let signatureF2 = withPrivateKey.sign(msg: messageToSign, deterministic: false)
        let signatureT = withPrivateKey.sign(msg: messageToSign, deterministic: true)
        print("signature determistic true full:02 :\(signatureT.r.data.hexEncodedString())\(signatureT.s.data.hexEncodedString())")
        print("signature determistic false 1 full:02\(signatureF.r.data.hexEncodedString())\(signatureF.s.data.hexEncodedString())")
        print("signature determistic false 2 full:02\(signatureF1.r.data.hexEncodedString())\(signatureF1.s.data.hexEncodedString())")
        print("signature determistic false 3 full:02\(signatureF2.r.data.hexEncodedString())\(signatureF2.s.data.hexEncodedString())")
        
        let signature = withPrivateKey.sign(msg: messageToSign, deterministic: false)

       // withPrivateKey.si
        let domain = Domain.instance(curve: .EC256k1)
        let signature2 = ECSignature.init(domain: domain, r: signature.r, s: signature.s)
        return signature2
       // return signature
    }

    public func verifyMessage(withPublicKey: ECPublicKey, signature: ECSignature, plainMessage: Data) -> Bool {
        let trueMessage = withPublicKey.verify(signature: signature, msg: plainMessage.bytes)
        return trueMessage
    }

    public func readPrivateKeyFromFileLocalDocuments(pemFileName: String) throws -> ECPrivateKey {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(pemFileName)
            do {
                var text2 = try String(contentsOf: fileURL, encoding: .utf8)
                if !text2.contains(prefixPemPrivateStr) && !text2.contains(prefixPemPrivateECStr) {
                    throw PemFileHandlerError.invalidPemKeyPrefix
                }
                if !text2.contains(suffixPemPrivateStr) && !text2.contains(suffixPemPrivateECStr) {
                    throw PemFileHandlerError.invalidPemKeySuffix
                }
                if text2.contains(prefixPemPrivateStr) {
                    text2 = text2.replacingOccurrences(of: prefixPemPrivateStr, with: prefixPemPrivateECStr)
                    text2 = text2.replacingOccurrences(of: suffixPemPrivateStr, with: suffixPemPrivateECStr)
                }
                let privateKey = try ECPrivateKey.init(pem: text2)
                return privateKey
            } catch {
                throw PemFileHandlerError.invalidPemKeyFormat
            }
        } else {
            NSLog("File not found")
            throw PemFileHandlerError.readPemFileNotFound
        }
    }

    public func writePrivateKeyToPemFileInDocumentsFolder(privateKeyToWrite: ECPrivateKey, fileName: String) throws -> Bool {
        let text = privateKeyToWrite.pem
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                return true
            }
            catch {
                throw PemFileHandlerError.writePemFileError
            }
        } else {
            throw PemFileHandlerError.writePemFileError
        }
    }

    public func writePublicKeyToPemFileInDocumentsFolder(publicKeyToWrite: ECPublicKey, fileName: String) throws -> Bool {
        let text = publicKeyToWrite.pem
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                return true
            }
            catch {
                throw PemFileHandlerError.writePemFileError
            }
        } else {
            throw PemFileHandlerError.writePemFileError
        }
    }

    public func readPublicKeyFromFileLocalDocuments(pemFileName: String) throws -> ECPublicKey {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(pemFileName)
            do {
                var text2 = try String(contentsOf: fileURL, encoding: .utf8)
                if !text2.contains(prefixPemPublicStr) && !text2.contains(prefixPemPublicECStr) {
                    throw PemFileHandlerError.invalidPemKeyPrefix
                }
                if !text2.contains(suffixPemPublicStr) && !text2.contains(suffixPemPublicECStr) {
                    throw PemFileHandlerError.invalidPemKeySuffix
                }
                if text2.contains(prefixPemPublicStr) {
                    text2 = text2.replacingOccurrences(of: prefixPemPublicStr, with: prefixPemPublicECStr)
                    text2 = text2.replacingOccurrences(of: suffixPemPublicStr, with: suffixPemPublicECStr)
                }
                let publicKey = try ECPublicKey.init(pem: text2.string)
                return publicKey
            } catch {
                throw PemFileHandlerError.invalidPemKeyFormat
            }
        } else {
            NSLog("File not found")
            throw PemFileHandlerError.readPemFileNotFound
        }
    }

}
