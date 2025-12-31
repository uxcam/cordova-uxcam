// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "CordovaUxcam",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CordovaUxcam",
            targets: ["CordovaUxcam"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", "6.0.0"..<"9.0.0")
    ],
    targets: [
        .target(
            name: "CordovaUxcam",
            dependencies: [
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                "UXCam"
            ],
            path: "src/ios",
            exclude: ["UXCam.xcframework"],
            sources: ["CDVUXCam.m"],
            publicHeadersPath: ".",
            linkerSettings: [
                .linkedFramework("CoreTelephony"),
                .linkedFramework("AVFoundation"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("CoreMedia"),
                .linkedFramework("CoreVideo"),
                .linkedFramework("MobileCoreServices"),
                .linkedFramework("QuartzCore"),
                .linkedFramework("SystemConfiguration"),
                .linkedFramework("Security"),
                .linkedFramework("Foundation"),
                .linkedFramework("ExternalAccessory"),
                .linkedLibrary("z"),
                .linkedLibrary("c++"),
                .linkedLibrary("iconv")
            ]
        ),
        .binaryTarget(
            name: "UXCam",
            path: "src/ios/UXCam.xcframework"
        )
    ]
)
