// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "CordovaUxcam",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CordovaUxcam",
            targets: ["UXCamPlugin"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", "6.0.0"..<"9.0.0"),
        .package(url: "https://github.com/uxcam/uxcam-ios-sdk.git", from: "3.7.7")
    ],
    targets: [
        .target(
            name: "UXCamPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "UXCam", package: "uxcam-ios-sdk")
            ],
            path: "src/ios",
            sources: ["UXCamPlugin.swift"]
        )
    ]
)
