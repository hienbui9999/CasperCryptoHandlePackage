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
    //messageToSign is the deploy hash when do put_deploy RPC call
    public func signMessage(messageToSign: String, withPrivateKeyPemString: String) -> String {
        do {
            let privateKey = try ECPrivateKey.init(pem: withPrivateKeyPemString)
            let signature = privateKey.sign(msg: Data(messageToSign.hexaBytes), deterministic: false)
            let domain = Domain.instance(curve: .EC256k1)
            let signature2 = ECSignature.init(domain: domain, r: signature.r, s: signature.s)
            return signature2.r.data.hexEncodedString() + signature2.s.data.hexEncodedString()
        } catch {
            return ERROR_STRING
        }
    }
    public func verifyMessage(withPublicKeyPemString: String, signature: String, plainMessage: String) -> Bool {
        do {
            let publicKey = try ECPublicKey.init(pem: withPublicKeyPemString)
            let signatureLength = signature.count;
            let rPart : String = signature.substring(from: 0, to: signatureLength/2);
            let sPart : String = signature.substring(from: signatureLength/2, to: signatureLength);
            print("Full signature:\(signature), rPart:\(rPart), sPart:\(sPart)")
           // let rString = ""//signature r hex decode => data=>r
           // let sString = ""//signature s hex decode => data=>s
            let signature2 = ECSignature.init(domain: Domain.instance(curve: .EC256k1) , r: rPart, s: sPart)
            let trueMessage = publicKey.verify(signature: signature2, msg: plainMessage.bytes)
            return true
        } catch {
            return false
        }
    }

/*
    public func verifyMessage(withPublicKey: ECPublicKey, signature: ECSignature, plainMessage: Data) -> Bool {
        let trueMessage = withPublicKey.verify(signature: signature, msg: plainMessage.bytes)
        return trueMessage
    }
*/
}
