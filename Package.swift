// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CasperCryptoHandlePackage",
    platforms: [
        .iOS(.v13), .tvOS(.v14), .watchOS(.v7), .macOS(.v10_15)
        ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CasperCryptoHandlePackage",
            targets: ["CasperCryptoHandlePackage"]),
    ],
    dependencies: [
        .package(name: "SwiftECC", url: "https://github.com/leif-ibsen/SwiftECC", from: "3.3.0"),
        .package(name:"Blake2",url: "https://github.com/tesseract-one/Blake2.swift.git", from: "0.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CasperCryptoHandlePackage",
            dependencies: ["SwiftECC","Blake2"]),
        .testTarget(
            name: "CasperCryptoHandlePackageTests",
            dependencies: ["CasperCryptoHandlePackage","SwiftECC","Blake2"]),
    ]
)
