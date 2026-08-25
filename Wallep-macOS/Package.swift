// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Wallep",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "wallep", targets: ["Wallep"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "Wallep",
            dependencies: [],
            path: "Sources/Wallep"
        )
    ]
)
