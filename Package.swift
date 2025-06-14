// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TabBar",
    platforms: [.iOS(
        .v17
    )],
    products: [
        .library(
            name: "TabBar",
            targets: ["TabBar"]
        ),
    ],
    targets: [
        .target(
            name: "TabBar",
            resources: [.copy(
                "Resources/PrivacyInfo.xcprivacy"
            )]
        ),
        .testTarget(
            name: "TabBarTests",
            dependencies: ["TabBar"]
        ),
    ]
)
