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
@objcMembers public class TestCall:NSObject {
    public func TestFunc() {
        print ("---- AAAAAAAA --- TEst func called successfully ---- AAAAAAAA --- ");
        print ("---- AAAAAAAA --- TEst func called successfully ---- AAAAAAAA --- ");
        print ("---- AAAAAAAA --- TEst func called successfully ---- AAAAAAAA --- ");
        print ("---- AAAAAAAA --- TEst func called successfully ---- AAAAAAAA --- ");
        print ("---- AAAAAAAA --- TEst func called successfully ---- AAAAAAAA --- ");
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
