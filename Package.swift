// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "STLocation",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "STLocation",
            targets: ["STLocation"]
        ),
    ],
    targets: [
        .target(
            name: "STLocation",
            path: "Sources"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
