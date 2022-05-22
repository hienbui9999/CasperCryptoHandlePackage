import Foundation
import CryptoKit
/// Enumeration for parse pem file error
public enum PemFileHandlerError: Error {
    case readPemFileNotFound
    case readPemDirectoryNotFound
    case writePemFileError
    case invalidPemKeyFormat
    case invalidPemKeySuffix
    case invalidPemKeyPrefix
    case none
}
public enum SignActionError: Error {
    case signMessageError
    case verifyMessageError
}
/// Enumeration for generate key error
public enum GenerateKeyError: Error {
    case privateKeyGenerateError
    case publicKeyGenerateError
}
/// Const Error String when a method return an error or get a throw from a try/catch block
let ERROR_STRING:String = "ERROR_ERROR"
/// prefix for private key in a pem file
let prefixPemPrivateStr: String = "-----BEGIN PRIVATE KEY-----"
let prefixPemPrivateECStr: String = "-----BEGIN EC PRIVATE KEY-----"
/// suffix for private key in a pem file
let suffixPemPrivateStr: String = "-----END PRIVATE KEY-----"
let suffixPemPrivateECStr: String = "-----END EC PRIVATE KEY-----"
/// prefix for public key in a pem file
let prefixPemPublicStr: String = "-----BEGIN PUBLIC KEY-----"
let prefixPemPublicECStr: String = "-----BEGIN EC PUBLIC KEY-----"
/// suffix for public key in a pem file
let suffixPemPublicStr: String = "-----END PUBLIC KEY-----"
let suffixPemPublicECStr: String = "-----END EC PUBLIC KEY-----"
/// Prefix to add for private key in Base64 String. Since the generated keys are in 32 bytes, they need to add prefix to make the full key stored in PEM file
let prefixPrivateKeyStr: String = "MC4CAQAwBQYDK2VwBCIEI"
/// Prefix to add for public key in Base64 String. Since the generated keys are in 32 bytes, they need to add prefix to make the full key stored in PEM file
let prefixPublicKeyStr: String = "MCowBQYDK2VwAyEA"
/// Prefix to add for private key in Bytes Data Hexa. Since the generated keys are in 32 bytes, they need to add prefix to make the full key stored in PEM file
let prefixPublicKeyData = Data([0x30, 0x2A, 0x30, 0x05, 0x06, 0x03, 0x2B, 0x65, 0x70, 0x03, 0x21, 0x00])
/// Prefix to add for public key in Bytes Data Hexa. Since the generated keys are in 32 bytes, they need to add prefix to make the full key stored in PEM file
let prefixPrivateKeyData = Data([0x30, 0x2e, 0x02, 0x01, 0x00, 0x30, 0x05, 0x06, 0x03, 0x2b, 0x65, 0x70, 0x04, 0x22,0x04,0x20])
/// Prefix to add for private key in Bytes Data Decimal. Since the generated keys are in 32 bytes, they need to add prefix to make the full key stored in PEM file
let prefixPrivateKeyDataBytes = Data([48, 46, 2, 1, 0, 48, 5, 6, 3, 43, 101, 112, 4, 34, 4, 32])
/// Prefix to add for public key in Bytes Data Decimal. Since the generated keys are in 32 bytes, they need to add prefix to make the full key stored in PEM file
let prefixPublicKeyDataBytes = Data([48, 42, 48, 5, 6, 3, 43, 101, 112, 3, 33, 0])
/// Prefix to add for private key in Hexa String. Since the generated keys are in 32 bytes, they need to add prefix to make the full key stored in PEM file
let prefixPrivateKeyHexaStr: String = "302e020100300506032b657004220420"
/// Prefix to add for public key in Hexa String. Since the generated keys are in 32 bytes, they need to add prefix to make the full key stored in PEM file
let prefixPublicKeyHexaStr: String = "302a300506032b656e032100"
/// Class to handle the following actions on Ed25519 encryption:  key generation, read key from PEM file,  write key to PEM file, sign message, verify message
@objcMembers public class KeyPairClass:NSObject {
    public var privateKeyInStr:String!;
    public var publicKeyInStr:String!;
}
@objcMembers public class Ed25519CrytoSwift:NSObject {
    public var privateKey: Curve25519.Signing.PrivateKey!
    public var publicKey: Curve25519.Signing.PublicKey!
    /// Generate key pair
    public func generateKeyPair() -> KeyPairClass {
        let ret = KeyPairClass();
        privateKey = Curve25519.Signing.PrivateKey.init()
        publicKey = privateKey.publicKey
        let privateKeyBytes = privateKey.rawRepresentation.bytes
        var privateKeyStr = ""
        for i in privateKeyBytes {
            privateKeyStr = privateKeyStr + String(i) + "_"
        }
        let index = privateKeyStr.index(privateKeyStr.endIndex, offsetBy: -2)
        privateKeyStr = String(privateKeyStr[...index])
        ret.privateKeyInStr = privateKeyStr
        let publicKeyBytes = publicKey.rawRepresentation.bytes
        var publicKeyStr = ""
        for i in publicKeyBytes {
            publicKeyStr = publicKeyStr + String(i) + "_"
        }
        let index2 = publicKeyStr.index(publicKeyStr.endIndex, offsetBy: -2)
        publicKeyStr = String(publicKeyStr[...index2])
        ret.publicKeyInStr = publicKeyStr
        return ret;
    }
    /// This function generate private key string to write to pem file
    public func getPrivateKeyStringForPemFile(privateKeyStr:String) -> String {
        let strArray : Array = privateKeyStr.components(separatedBy: "_");
        var privateKeyArray:Array<UInt8> = Array<UInt8>();
        for i in strArray {
            privateKeyArray.append(UInt8(i)!)
        }
        do {
            let privateKey:Curve25519.Signing.PrivateKey = try Curve25519.Signing.PrivateKey.init(rawRepresentation: privateKeyArray)
            let privateKeyInBase64 = (prefixPrivateKeyData + privateKey.rawRepresentation).base64EncodedString()
            var text = "-----BEGIN PRIVATE KEY-----"
            text = text + "\n" + privateKeyInBase64
            text = text + "\n" + "-----END PRIVATE KEY-----"
            return text
        } catch {
            return ERROR_STRING
        }
    }
    
    /// This function generate public key string to write to pem file
    public func getPublicKeyStringForPemFile(publicKeyStr:String) -> String {
        let strArray : Array = publicKeyStr.components(separatedBy: "_");
        var publicKeyArray:Array<UInt8> = Array<UInt8>();
        for i in strArray {
            publicKeyArray.append(UInt8(i)!)
        }
        do {
            let publicKey:Curve25519.Signing.PublicKey = try Curve25519.Signing.PublicKey.init(rawRepresentation: publicKeyArray)
            let publicKeyInBase64 = (prefixPublicKeyData + publicKey.rawRepresentation).base64EncodedString()
            var text = "-----BEGIN PUBLIC KEY-----"
            text = text + "\n" + publicKeyInBase64
            text = text + "\n" + "-----END PUBLIC KEY-----"
            return text
        } catch {
            return ERROR_STRING
        }
    }
    /*
    /// Write public key to pem file
    public func writePublicKeyToPemFile(publicKeyToWrite: Curve25519.Signing.PublicKey, fileName: String) throws {
        let publicKeyInBase64 = (prefixPublicKeyData + publicKeyToWrite.rawRepresentation).base64EncodedString()
        var text = "-----BEGIN PUBLIC KEY-----"
        text = text + "\n" + publicKeyInBase64
        text = text + "\n" + "-----END PUBLIC KEY-----"
        
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let fileURL = thisDirectory.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
                //NSLog("Ed25519 Private key file does not exist, about to create new one!")
            }
           // NSLog("Delete auto generated Ed25519 private file.")
        }
        do {
            try text.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {
            throw PemFileHandlerError.writePemFileError
        }
    }
*/
    public func getPrivateKeyStringFromPemString(pemStr: String) -> String {
        let pemIndex = pemStr.index(pemStr.startIndex, offsetBy: 21)
        let privateBase64: String = String(pemStr[pemIndex..<pemStr.endIndex])
        let fullPemKeyBase64 = prefixPrivateKeyStr + privateBase64
        if let privateBase64FromPem = fullPemKeyBase64.base64Decoded {
            let base64ToBytes = privateBase64FromPem.bytes
            let privateBytes = base64ToBytes[prefixPrivateKeyData.count..<base64ToBytes.count]
            do {
                let privateKey = try Curve25519.Signing.PrivateKey.init(rawRepresentation: privateBytes)
                let privateKeyBytes = privateKey.rawRepresentation.bytes
                var privateKeyStr = ""
                for i in privateKeyBytes {
                    privateKeyStr = privateKeyStr + String(i) + "_"
                }
                let index = privateKeyStr.index(privateKeyStr.endIndex, offsetBy: -2)
                privateKeyStr = String(privateKeyStr[...index])
                return privateKeyStr
            } catch {
                return ERROR_STRING
            }
        } else {
            return ERROR_STRING
        }
    }
    
    public func getPublicKeyStringFromPemString(pemStr: String) -> String {
        var pemStr2 = pemStr.trimmingCharacters(in: .whitespacesAndNewlines)
        if pemStr2.count > 60 {
            let index = pemStr.index(pemStr.startIndex, offsetBy: 65)
            let realPemStr = String(pemStr2[..<index])
            pemStr2 = realPemStr
        }
        pemStr2 = pemStr.trimmingCharacters(in: .whitespacesAndNewlines)
        let pemIndex = pemStr.index(pemStr2.startIndex, offsetBy: 16)
        let publicBase64: String = String(pemStr2[pemIndex..<pemStr2.endIndex])
        if let base64DecodeShort = publicBase64.base64Decoded {
            do {
                let publicKeyFromPem = try Curve25519.Signing.PublicKey.init(rawRepresentation: base64DecodeShort.bytes)
                let publicKeyBytes = publicKeyFromPem.rawRepresentation.bytes
                var publicKeyStr = ""
                for i in publicKeyBytes {
                    publicKeyStr = publicKeyStr + String(i) + "_"
                }
                let index2 = publicKeyStr.index(publicKeyStr.endIndex, offsetBy: -2)
                publicKeyStr = String(publicKeyStr[...index2])
                return publicKeyStr
            } catch {
                return ERROR_STRING
            }
        } else {
            return ERROR_STRING
        }
    }
    // This function sign the message (in String format) with given private key (in String format)
    public func signMessageString(messageToSign:String,privateKeyStr:String) -> String {
        //first change to String to Bytes to make private key
        let dataToSign = Data(messageToSign.hexaBytes);
        let strArray : Array = privateKeyStr.components(separatedBy: "_");
        var privateKeyArray:Array<UInt8> = Array<UInt8>();
        for i in strArray {
            privateKeyArray.append(UInt8(i)!)
        }
        do {
            let privateKey:Curve25519.Signing.PrivateKey = try Curve25519.Signing.PrivateKey.init(rawRepresentation: privateKeyArray)
            let signedMessage = try privateKey.signature(for: dataToSign)
            let signatureValue:String = signedMessage.hexEncodedString()
            return signatureValue
        } catch {
            return ERROR_STRING
        }
    }
    // This function verify the signed message (in String format) with given public key (in String format) and original message (in String format)
    public func verifyMessage(signedMessage:String,publicKeyToVerifyString:String,originalMessage:String)-> Bool {
        let strArray : Array = publicKeyToVerifyString.components(separatedBy: "_");
        var publicKeyArray:Array<UInt8> = Array<UInt8>();
        for i in strArray {
            publicKeyArray.append(UInt8(i)!)
        }
        do {
        let publicKey = try Curve25519.Signing.PublicKey.init(rawRepresentation: publicKeyArray)
            let signMessageStr = signedMessage.hexadecimal
            if publicKey.isValidSignature(Data(signMessageStr!.bytes), for: Data(originalMessage.hexaBytes)) {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    public func generateTime() -> String {
        let timestamp = NSDate().timeIntervalSince1970
        let tE = String(timestamp).components(separatedBy: ".")
        let mili = tE[1]
        let indexMili = mili.index(mili.startIndex, offsetBy: 3)
        let miliStr = mili[..<indexMili]
        let myTimeInterval = TimeInterval(timestamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        let timeStr = String(time.description)
        let timeElements = timeStr.components(separatedBy: " ")
        let newTimeStr = timeElements[0] + "T" + timeElements[1] + ".\(miliStr)Z"
        return newTimeStr
    }
}

