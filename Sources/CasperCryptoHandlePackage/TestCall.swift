import Foundation
import SwiftECC
import Blake2
@objcMembers public class Sample1:NSObject {
    public var name:String = ""
    public var age:UInt = 10
    public func sayHello() {
        print("Hello, my name is:\(name) and age is:\(age)")
    }
    public func sayHello2(newName:String,newAge:UInt) {
        self.name = newName
        self.age = newAge
        print("From hello 2, my new name is:\(name) and new age is:\(age)")
    }
}
@objcMembers public class Blake2Handler:NSObject {
    public func getBlake2b(serialStr:String) -> String{
        let blake2Data = Data(serialStr.hexaBytes)
        let hash = try! Blake2.hash(.b2b, size: 32, data: blake2Data)
        return hash.hexEncodedString()
    }
}
@objcMembers public class TestCall:NSObject {
    public func getBlake2b(serialStr:String) -> String{
        let blake2Data = Data(serialStr.hexaBytes)
        let hash = try! Blake2.hash(.b2b, size: 32, data: blake2Data)
        return hash.hexEncodedString()
    }
    public func TestFunc() {
        print ("---- AAAAAAAA --- TEst func called successfully ---- AAAAAAAA --- ");
        print ("---- AAAAAAAA --- TEst func called successfully ---- AAAAAAAA --- ");
        print ("---- AAAAAAAA --- TEst func called successfully ---- AAAAAAAA --- ");
        print ("---- AAAAAAAA --- TEst func called successfully ---- AAAAAAAA --- ");
        print ("---- AAAAAAAA --- TEst func called successfully ---- AAAAAAAA --- ");
        let ed =  Ed25519Cryto();
        ed.generateKeyPair();
    }
    public func TestParameter(para1:String,para2:UInt,para3:Sample1) {
        print("Test parameter function call with para1:\(para1), para2:\(para2)")
        print("And here is sample 1 information")
        para3.sayHello();
        para3.sayHello2(newName: "Nguyen Tien COng", newAge: 100);
    }
    @objc func TestFunc2() {
        print ("---- AAAAAAAA --- TEst func 22called successfully ---- AAAAAAAA --- ");
        print ("---- AAAAAAAA --- TEst func 22called successfully ---- AAAAAAAA --- ");
        print ("---- AAAAAAAA --- TEst func 22called successfully ---- AAAAAAAA --- ");
        print ("---- AAAAAAAA --- TEst func 22called successfully ---- AAAAAAAA --- ");
        print ("---- AAAAAAAA --- TEst func 22called successfully ---- AAAAAAAA --- ");
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
