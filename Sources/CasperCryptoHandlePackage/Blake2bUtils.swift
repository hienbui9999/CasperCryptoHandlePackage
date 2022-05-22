import Foundation
import Blake2
@objcMembers public class Blake2Handler:NSObject {
    public func getBlake2b(serialStr:String) -> String{
        let blake2Data = Data(serialStr.hexaBytes)
        let hash = try! Blake2.hash(.b2b, size: 32, data: blake2Data)
        return hash.hexEncodedString()
    }
}
