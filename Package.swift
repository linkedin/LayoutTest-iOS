// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "LayoutTest",
    platforms: [.iOS(.v12)],
    products: [
        .library(name: "LayoutTest", targets: ["LayoutTest"]),
        .library(name: "LayoutTestBase", targets: ["LayoutTestBase"])
    ],
    targets: [
        .target(
            name: "LayoutTestBaseObjC",
            path: "LayoutTestBase",
            exclude: ["Info.plist", "Swift", "LayoutTestBase.h"],
            publicHeadersPath: "include",
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
            name: "LayoutTestBase",
            dependencies: ["LayoutTestBaseObjC"],
            path: "LayoutTestBase/Swift"
        ),
        .target(
            name: "LayoutTestObjC",
            dependencies: ["LayoutTestBaseObjC"],
            path: "LayoutTest/TestCase",
            publicHeadersPath: "include",
            linkerSettings: [.linkedFramework("XCTest")]
        ),
        .target(
            name: "LayoutTest",
            dependencies: ["LayoutTestObjC", "LayoutTestBase"],
            path: "LayoutTest/Swift"
        )
    ]
)
