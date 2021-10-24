# ``Match``

A simple and lightweight matching library for XCTest framework.

## Overview

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

## Getting Started
- <doc:Installation>
- <doc:Matchers>

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
