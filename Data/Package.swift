// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "Data",
            targets: ["Data"])
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(url: "https://github.com/emelagumat/MLDCore.git", branch: "develop")
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: [
                "Domain",
                .product(name: "APIClient", package: "MLDCore")
            ]
        ),
        .testTarget(
            name: "DataTests",
            dependencies: ["Data"])
    ]
)
