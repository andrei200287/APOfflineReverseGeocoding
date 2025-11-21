// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APOfflineReverseGeocoding",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_10)
    ],
    products: [
        .library(
            name: "APOfflineReverseGeocoding",
            targets: ["APOfflineReverseGeocoding"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "APOfflineReverseGeocoding",
            dependencies: [],
            path: "APOfflineReverseGeocoding",
            exclude: [],
            sources: [
                "APCountry.m",
                "APReverseGeocoding.m",
                "Internal/APCountryInfoBuilder.m",
                "Internal/APPolygon.m"
            ],
            resources: [
                .process("GeoJSON/countries.geo.json")
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("Internal")
            ]
        ),
    ]
)

