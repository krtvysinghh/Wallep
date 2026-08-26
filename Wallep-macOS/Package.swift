// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Wallep",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "wallep", targets: ["WallepApp"]),
        .executable(name: "wallep-tests", targets: ["WallepUnitTests"]),
        .library(name: "WallepKit", targets: ["WallepKit"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "WallepKit",
            dependencies: [],
            path: "Sources/Wallep"
        ),
        .executableTarget(
            name: "WallepApp",
            dependencies: ["WallepKit"],
            path: "Sources/WallepApp"
        ),
        .executableTarget(
            name: "WallepUnitTests",
            dependencies: ["WallepKit"],
            path: "Sources/WallepUnitTests"
        )
    ]
)
