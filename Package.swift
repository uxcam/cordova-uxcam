// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "CordovaUxcam",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "CordovaUxcam",
            targets: ["CordovaUxcam"]
        )   
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", "6.0.0"..<"9.0.0"),
        .package(url: "https://github.com/uxcam/uxcam-ios-sdk.git", from: "3.7.5")
    ],
    targets: [
        .target(
            name: "CordovaUxcam",
            dependencies: [
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "UXCam", package: "uxcam-ios-sdk")
            ],
            path: "src/ios",
            sources: ["CDVUXCam.m"],
            publicHeadersPath: "."
        )
    ]
)
