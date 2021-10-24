# Installation

Learn how to integrate Match library with your project.

### Swift Package Manager
You can add Match to your project by adding it as a dependency in your Package.swift file:
```swift
// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyProject",
    products: [
        .library(name: "MyProject", targets: ["MyProject"])
    ],
    dependencies: [
         .package(url: "https://github.com/mtynior/Match.git", .upToNextMajor(from: "0.5.0")),
    ],
    targets: [
        .target(name: "MyProject", dependencies: []),
        .testTarget(name: "MyProject", dependencies: ["Match"])
    ]
)

```

### Xcode
![Xcode Match setup](https://res.cloudinary.com/mtynior/image/upload/v1634748957/development/match_xcode_oleolc.jpg)


Open your project in Xcode, then:
1. Click File -> Add Packages,
2. In the search bar type: `https://github.com/mtynior/match.git` and press `Enter`,
3. Once Xcode finds the library, set Dependency rule to `Up to next major version`,
4. Click Add Package,
5. Select the Test Target (If you have multiple test targets, you can add the dependency manually from Xcode )
6. Confirm selection by clicking on Add Package.
