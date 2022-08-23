// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "combine-schedulers",
  platforms: [
    .iOS(.v12),
    .macOS(.v10_14),
    .tvOS(.v12),
    .watchOS(.v5),
  ],
  products: [
    .library(
      name: "CombineSchedulers",
      targets: ["CombineSchedulers"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/OpenCombine/OpenCombine", from: "0.13.0"),
    .package(url: "https://github.com/pavelosipov/xctest-dynamic-overlay", from: "0.3.1")
  ],
  targets: [
    .target(
      name: "CombineSchedulers",
      dependencies: [
        .product(name: "OpenCombine", package: "OpenCombine"),
        .product(name: "OpenCombineFoundation", package: "OpenCombine"),
        .product(name: "OpenCombineDispatch", package: "OpenCombine"),
        .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay")
      ]
    ),
    .testTarget(
      name: "CombineSchedulersTests",
      dependencies: [
        "CombineSchedulers"
      ]
    ),
  ]
)
