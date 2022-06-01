# CasperCryptoHandlePackage

## About this package

This package provides Ed25519 and Secp256k1 crypto tasks as library for ObjectiveC call.

This package includes the following functions for both Secp256k1 and Ed25519:

1. (PrivateKey,PublicKey) generation

2. Sign message

3. Verify message

4. Read PrivateKey/PublicKey from PEM file

5. Write PrivateKey/PublicKey to PEM file

All the functions of the classes can be call from ObjectiveC to do the crypto tasks.

## How to use this package from ObjectiveC package

From ObjectiveC package project, choose "Package.swift" file and add the following line of dependencies:

```Swift
  dependencies: [
        .package(name: "CasperCryptoHandlePackage", url: "https://github.com/hienbui9999/CasperCryptoHandlePackage.git", from: "1.0.6"),
    ]
```
Somehow it is like what is in this image, as you can see when the package is loaded, there will be "CasperCryptoHandlePackage 1.0.6" in the left panel 
<img width="1440" alt="Screen Shot 2022-06-01 at 10 01 12" src="https://user-images.githubusercontent.com/94465107/171319263-0ae34b32-d087-42ab-832b-829402bc9356.png">

Create 1 ObjectiveC source file, add the following line of importing at the beginning of the file

```Swift
@import CasperCryptoHandlePackage;
```
Now you can call Swift function of this package from ObjectiveC, such as this call to generate the (Private,Public) key pair

```Swift
-(CryptoKeyPair *) generateKey {
    CryptoKeyPair * ret = [[CryptoKeyPair alloc] init];
    Ed25519CrytoSwift * ed25519 = [[Ed25519CrytoSwift alloc] init];
    KeyPairClass * kpc = [ed25519 generateKeyPair];
    ret.privateKeyStr = kpc.privateKeyInStr;
    ret.publicKeyStr = kpc.publicKeyInStr;
    return ret;
}
```
in which the following call is call to Swift package:

```Swift
Ed25519CrytoSwift * ed25519 = [[Ed25519CrytoSwift alloc] init];
KeyPairClass * kpc = [ed25519 generateKeyPair];
```

Or if you wish to sign a message with Ed25519 crypto, in ObjectiveC you will write like this

```Swift
-(NSString*) signMessageWithValue:(NSString*) messageToSign withPrivateKey:(NSString*) privateKeyStr {
    Ed25519CrytoSwift * ed25519 = [[Ed25519CrytoSwift alloc] init];
    NSString * ret = [ed25519 signMessageStringWithMessageToSign:messageToSign privateKeyStr:privateKeyStr];
    return ret;
}
```
This ObjectiveC function simply call the Swift function to sign the message

```Swift
    Ed25519CrytoSwift * ed25519 = [[Ed25519CrytoSwift alloc] init];
    NSString * ret = [ed25519 signMessageStringWithMessageToSign:messageToSign privateKeyStr:privateKeyStr];
}
```

