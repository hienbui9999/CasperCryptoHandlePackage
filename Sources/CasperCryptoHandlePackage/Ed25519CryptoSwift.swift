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
@objcMembers public class SwiftUtilClass:NSObject {
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
        if (strArray.isEmpty) {
            return ERROR_STRING
        }
        if (strArray.count < 2) {
            return ERROR_STRING;
        }
        var privateKeyArray:Array<UInt8> = Array<UInt8>();
        for i in strArray {
            if(!i.isNumber) {
                return ERROR_STRING;
            }
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
        if (strArray.isEmpty) {
            return ERROR_STRING
        }
        if (strArray.count < 2) {
            return ERROR_STRING;
        }
        var publicKeyArray:Array<UInt8> = Array<UInt8>();
        for i in strArray {
            if(!i.isNumber) {
                return ERROR_STRING;
            }
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
        if (strArray.isEmpty) {
            return ERROR_STRING
        }
        if (strArray.count < 2) {
            return ERROR_STRING;
        }
        var privateKeyArray:Array<UInt8> = Array<UInt8>();
        for i in strArray {
            if(!i.isNumber) {
                return ERROR_STRING;
            }
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
        if (strArray.isEmpty) {
            return false
        }
        if (strArray.count < 2) {
            return false;
        }
        var publicKeyArray:Array<UInt8> = Array<UInt8>();
        for i in strArray {
            if(!i.isNumber) {
                return false;
            }
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
}

extension StringProtocol {
    var data: Data { Data(utf8) }
    var base64Encoded: Data { data.base64EncodedData() }
    var base64Decoded: Data? { Data(base64Encoded: string) }
}

extension LosslessStringConvertible {
    var string: String { .init(self) }
}

extension Sequence where Element == UInt8 {
    var data: Data { .init(self) }
    var base64Decoded: Data? { Data(base64Encoded: data) }
    var string: String? { String(bytes: self, encoding: .utf8) }
}

extension Data {

  ///  A hexadecimal string representation of the bytes.
  func hexEncodedString() -> String {
    let hexDigits = Array("0123456789abcdef".utf16)
    var hexChars = [UTF16.CodeUnit]()
    hexChars.reserveCapacity(count * 2)
    for byte in self {
      let (index1, index2) = Int(byte).quotientAndRemainder(dividingBy: 16)
      hexChars.append(hexDigits[index1])
      hexChars.append(hexDigits[index2])
    }
    return String(utf16CodeUnits: hexChars, count: hexChars.count)
  }
}

extension String {
    func substring(from: Int?, to: Int?) -> String {
            if let start = from {
                guard start < self.count else {
                    return ""
                }
            }

            if let end = to {
                guard end >= 0 else {
                    return ""
                }
            }

            if let start = from, let end = to {
                guard end - start >= 0 else {
                    return ""
                }
            }

            let startIndex: String.Index
            if let start = from, start >= 0 {
                startIndex = self.index(self.startIndex, offsetBy: start)
            } else {
                startIndex = self.startIndex
            }

            let endIndex: String.Index
            if let end = to, end >= 0, end < self.count {
                endIndex = self.index(self.startIndex, offsetBy: end + 1)
            } else {
                endIndex = self.endIndex
            }

            return String(self[startIndex ..< endIndex])
        }

        func substring(from: Int) -> String {
            return self.substring(from: from, to: nil)
        }

        func substring(to: Int) -> String {
            return self.substring(from: nil, to: to)
        }

        func substring(from: Int?, length: Int) -> String {
            guard length > 0 else {
                return ""
            }

            let end: Int
            if let start = from, start > 0 {
                end = start + length - 1
            } else {
                end = length - 1
            }

            return self.substring(from: from, to: end)
        }

        func substring(length: Int, to: Int?) -> String {
            guard let end = to, end > 0, length > 0 else {
                return ""
            }

            let start: Int
            if let end = to, end - length > 0 {
                start = end - length + 1
            } else {
                start = 0
            }

            return self.substring(from: start, to: to)
        }
    var isNumber: Bool {
            return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
  ///  A data representation of the hexadecimal bytes in this string.
  func hexDecodedData() -> Data {
    // Get the UTF8 characters of this string
    let chars = Array(utf8)
    // Keep the bytes in an UInt8 array and later convert it to Data
    var bytes = [UInt8]()
    bytes.reserveCapacity(count / 2)
    // It is a lot faster to use a lookup map instead of strtoul
    let map: [UInt8] = [
      0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, // 01234567
      0x08, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // 89: <=>?
      0x00, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x00, // @ABCDEFG
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  // HIJKLMNO
    ]
    // Grab two characters at a time, map them and turn it into a byte
    for i in stride(from: 0, to: count, by: 2) {
      let index1 = Int(chars[i] & 0x1F ^ 0x10)
      let index2 = Int(chars[i + 1] & 0x1F ^ 0x10)
      bytes.append(map[index1] << 4 | map[index2])
    }
    return Data(bytes)
  }
    
func hexToString()->String{
        var finalString = ""
        let chars = Array(self)
        for count in stride(from: 0, to: chars.count - 1, by: 2){
            let firstDigit =  Int.init("\(chars[count])", radix: 16) ?? 0
            let lastDigit = Int.init("\(chars[count + 1])", radix: 16) ?? 0
            let decimal = firstDigit * 16 + lastDigit
            let decimalString = String(format: "%c", decimal) as String
            finalString.append(Character.init(decimalString))
        }
        return finalString
    }
    var hexadecimal: Data? {
        var data = Data(capacity: count / 2)
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }
        guard data.count > 0 else { return nil }
        return data
    }
}

extension Data {
    
    init?(base64EncodedURLSafe string: String, options: Base64DecodingOptions = []) {
        let string = string
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        self.init(base64Encoded: string, options: options)
    }
    
    public var bytes: Array<UInt8> {
      Array(self)
    }

}

extension StringProtocol {
    var hexaData: Data { .init(hexa) }
    var hexaBytes: [UInt8] { .init(hexa) }
    private var hexa: UnfoldSequence<UInt8, Index> {
        sequence(state: startIndex) { startIndex in
            guard startIndex < self.endIndex else { return nil }
            let endIndex = self.index(startIndex, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { startIndex = endIndex }
            return UInt8(self[startIndex..<endIndex], radix: 16)
        }
    }
}
extension String {
    @inlinable
    public var bytes: Array<UInt8> {
      data(using: String.Encoding.utf8, allowLossyConversion: true)?.bytes ?? Array(utf8)
    }
}
