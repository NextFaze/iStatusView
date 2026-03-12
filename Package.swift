// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "iStatusView",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "iStatusView",
            targets: ["iStatusView"]
        )
    ],
    targets: [
        .target(
            name: "iStatusView",
            path: "iStatusView/Classes"
        ),
        .testTarget(
            name: "iStatusViewTests",
            dependencies: ["iStatusView"],
            path: "Tests/iStatusViewTests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
