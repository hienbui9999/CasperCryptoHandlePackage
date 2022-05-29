import Foundation
import Blake2
// This class give the utility to get the black2b256 value for a given string, used as library function for ObjectiveC
@objcMembers public class Blake2Handler:NSObject {
    public func getBlake2b(serialStr:String) -> String{
        let blake2Data = Data(serialStr.hexaBytes)
        let hash = try! Blake2.hash(.b2b, size: 32, data: blake2Data)
        return hash.hexEncodedString()
    }
}
