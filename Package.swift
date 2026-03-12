// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "iStatusView",
    platforms: [
        .iOS(.v15)
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
    swiftLanguageModes: [.v6]
)
