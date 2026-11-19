// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "LayoutTest",
    platforms: [.iOS(.v12)],
    products: [
        .library(name: "LayoutTest", targets: ["LayoutTest"]),
        .library(name: "LayoutTestBase", targets: ["LayoutTestBaseSwift"])
    ],
    targets: [
        .target(
            name: "LayoutTestBase",
            path: "LayoutTestBase",
            exclude: ["Info.plist", "Swift", "LayoutTestBase.h"],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("Autolayout"),
                .headerSearchPath("Catalog"),
                .headerSearchPath("Config"),
                .headerSearchPath("Core"),
                .headerSearchPath("Core/Generators"),
                .headerSearchPath("Core/Generators/Private"),
                .headerSearchPath("Core/Helpers"),
                .headerSearchPath("Core/Testers"),
                .headerSearchPath("Core/ViewSizing"),
                .headerSearchPath("UIViewHelpers")
            ]
        ),
        .target(
            name: "LayoutTestBaseSwift",
            dependencies: ["LayoutTestBase"],
            path: "LayoutTestBase/Swift"
        ),
        .target(
            name: "LayoutTestObjC",
            dependencies: ["LayoutTestBase"],
            path: "LayoutTest/TestCase",
            publicHeadersPath: ".",
            linkerSettings: [.linkedFramework("XCTest")]
        ),
        .target(
            name: "LayoutTest",
            dependencies: ["LayoutTestObjC", "LayoutTestBaseSwift"],
            path: "LayoutTest/Swift"
        )
    ]
)
