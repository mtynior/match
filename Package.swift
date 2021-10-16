// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Match",
    products: [
        .library(name: "Match", targets: ["Match"])
    ],
    dependencies: [],
    targets: [
        .target(name: "Match", dependencies: []),
        .testTarget(
            name: "MatchTests", dependencies: ["Match"])
    ]
)
