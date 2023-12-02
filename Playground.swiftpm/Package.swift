// swift-tools-version: 5.9

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Playground",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .iOSApplication(
            name: "Playground",
            targets: ["AppModule"],
            bundleIdentifier: "A0FDF4CE-4E44-4488-8A37-EEDAF8850E71",
            teamIdentifier: "",
            displayVersion: "1.0",
            bundleVersion: "1",
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    
    dependencies: [
        .package(path: "../")
    ],
    
    targets: [
        .executableTarget(
            name: "AppModule",
            
            dependencies: [
                .product(
                    name: "TabBar",
                    package: "TabBar"
                )
            ],
            
            path: "."
        )
    ]
)
