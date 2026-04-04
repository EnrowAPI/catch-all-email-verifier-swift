// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "CatchAllEmailVerifier",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
    ],
    products: [
        .library(name: "CatchAllEmailVerifier", targets: ["CatchAllEmailVerifier"]),
    ],
    targets: [
        .target(name: "CatchAllEmailVerifier"),
    ]
)
