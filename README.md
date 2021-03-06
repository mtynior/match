
<div align="center">
    <img src="https://res.cloudinary.com/mtynior/image/upload/v1634743098/development/match_logo.png" width="256">
    <h1>Match</h1>
    <h3>A simple and lightweight matching library for XCTest framework.</h3>
</div>

<p align="center">
  <img src="https://img.shields.io/badge/language-Swift-orange" />
  <a href="https://github.com/mtynior/match/actions/workflows/test_package_prod_env.yml">
    <img src="https://github.com/mtynior/match/actions/workflows/test_package_prod_env.yml/badge.svg?branch=main"/>
  </a>
  <a href="https://codecov.io/gh/mtynior/match">
    <img src="https://codecov.io/gh/mtynior/match/branch/main/graph/badge.svg?token=56Q5BQF40Z"/>
  </a>  
  <img src="https://img.shields.io/badge/license-MIT-blue.svg" />
</p>

## Getting started 

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

<p align="center">
    <img src="https://res.cloudinary.com/mtynior/image/upload/v1634748957/development/match_xcode_oleolc.jpg">
</p>


Open your project in Xcode, then:
1. Click File -> Add Packages,
2. In the search bar type: `https://github.com/mtynior/match.git` and press `Enter`,
3. Once Xcode finds the library, set Dependency rule to `Up to next major version`,
4. Click Add Package,
5. Select the Test Target (If you have multiple test targets, you can add the dependency manually from Xcode )
6. Confirm selection by clicking on Add Package.

### Writing tests
Now, when we have library integrated with our project, let's write some tests.

Imagine that we have a function that adds two numbers:
```swift
func sum(_ a: Int, _ b: Int) -> Int {
    a + b
}
```

Not we can test our function using XCTest Framework and the Match:
```swift
import XCTest
import Match
@testable MyProject

final class SumTests: XCTestCase {
    func testAddingTwoNumbers() {
        // given
        let expectedValue = 5
        
        // when
        let actualValue = sum(2, 3)

        // then
        expect(actualValue).toBeEqual(expectedValue) // Passes: "Expected: 5 is equal to received: 5"
    }
}
```

If we implemented the `sum` function correctly the test above will pass.

But let's see what will happen when we make a mistake in the `sum` implementation:
```swift
func sum(_ a: Int, _ b: Int) -> Int {
    a * b
}
```

Now, our test should fail:
```swift
import XCTest
import Match
@testable MyProject

final class SumTests: XCTestCase {
    func testAddingTwoNumbers() {
        // given
        let expectedValue = 5 
        
        // when
        let actualValue = sum(2, 3)

        // then
        expect(actualValue).toBeEqual(expectedValue) // Fails: "Expected: 5 to be equal to received: 6"
    }
}
```

That's it. Now, check how to use the rest of the [Matchers](./Sources/Match/Docs/Match.docc/Matchers.md) and start testig.

## Credits
Icon is made by [Freepik](https://www.freepik.com) and was available at [FlatIcon](https://www.flaticon.com/free-icon/matches_208364).

## License
Match is released under the MIT license. See LICENSE for details.
