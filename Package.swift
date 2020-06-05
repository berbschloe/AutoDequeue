// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "AutoDequeue",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "AutoDequeue", targets: ["AutoDequeue"]),
    ],
    targets: [
        .target(name: "AutoDequeue", path: "AutoDequeue"),
        .testTarget(name: "AutoDequeueTests", dependencies: ["AutoDequeue"]),
    ]
)
