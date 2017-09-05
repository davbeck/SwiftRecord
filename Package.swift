// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftRecord",
    products: [
        .library(
            name: "SwiftRecord",
            targets: ["SwiftRecord"]),
        .library(
            name: "SwiftRecordPostgres",
            targets: ["SwiftRecordPostgres"]),
    ],
    dependencies: [
        .package(url: "https://github.com/davbeck/PG.swift.git", from: "0.1.1"),
        .package(url: "https://github.com/davbeck/AsyncKit.git", from: "0.0.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftRecord",
            dependencies: [
                "AsyncKit",
            ]),
        .target(
            name: "SwiftRecordPostgres",
            dependencies: [
                "SwiftRecord",
                "PG",
                "AsyncKit",
            ]),
        .testTarget(
            name: "SwiftRecordTests",
            dependencies: [
                "SwiftRecord",
                "SwiftRecordPostgres"
            ]),
    ]
)
