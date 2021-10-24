# Matchers
List of available matchers.

## toBeEqual()
Tests whether the two values are equal.

This matcher works with any type that conforms to the `Equatable` protocol:
```swift
expect(2).toBeEqual(5) // Fails
expect(2).toBeEqual(2) // Passes

expect([1, 2, 3]).toBeEqual([3, 2, 1]) // Fails
expect([1, 2, 3]).toBeEqual([1, 2, 3]) // Passes

expect("Anakin").toBeEqual("Vader") // Fails
expect("Anakin").toBeEqual("Anakin") // Passes
expect("Anakin").toBeEqual("anakin") // Fails
expect("Anakin").toBeEqual("anakin", comparisonOptions: .caseInsensitive) // Passes
```

When comparing `FloatingPoint` numbers use the `toBeCloseTo()` instead.


## toBeIdenticalTo()
Tests whether the two values are identical (share the same memory).

This matcher works with any type that conforms to the `AnyObject` protocol:
```swift
final class Car {
   let color: String
}

let car1 = Car(color: "red")
let car2 = Car(color: "red")

expect(car1).toBeIdenticalTo(car2) // Fails
expect(car1).toBeIdenticalTo(car1) // Passes
```

## toBeTypeOf()
Tests whether the actual value is type of the expected type.

```swift
expect("Anakin").toBeTypeOf(Int.self) // Fails
expect("Anakin").toBeTypeOf(String.self) // Passes
```

This matcher also verifies whether a value or an object conforms to protocol, and can verify the inheritance:
```swift
protocol Fighter {}
class TieFighter: Fighter {}
final class TieBomber: TieFighter {}

expect(TieFighter()).toBeTypeOf(Fighter.self) // Passes
expect(TieBomber()).toBeTypeOf(TieFighter.self) // Passes
expect(TieBomber()).toBeTypeOf(Fighter.self) // Passes
```


## toBeCloseTo()
Tests whether the two values are close to each other within a specified precision.

This matcher uses the `abs(actualValue - expectedValue) <= precision` formula to determine whether the values are close to each other.

By default, the `ToBeCloseTo.defaultPrecision` precision is used. It can be change with the second parameter:
```swift
expect(3.005).toBeCloseTo(3.001) // Fails
expect(3.005).toBeCloseTo(3.001, within: 0.01) //Passes
```

## toBeGreaterThan()
Tests whether the actual value is greater than expected value.

This matcher works with any type that conforms to the `Comparable` protocol:
```swift
expect(2).ToBeGreaterThan(0) // Passes
expect(2).toBeGreaterThan(5) // Fails
expect(2).toBeGreaterThan(2) // Fails
```

## toBeGreaterThanOrEqualTo()
Tests whether the actual value is greater than or equal to expected value.

This matcher works with any type that conforms to the `Comparable` protocol:
```swift
expect(2).toBeGreaterThanOrEqualTo(0) // Passes
expect(2).toBeGreaterThanOrEqualTo(2) // Passes
expect(2).toBeGreaterThanOrEqualTo(5) // Fails
```

## toBeLessThan()
Tests whether the actual value is less than expected value.

This matcher works with any type that conforms to the `Comparable` protocol:
```swift
expect(2).toBeLessThan(5) // Passes
expect(5).toBeLessThan(2) // Fails
expect(2).toBeLessThan(2) // Fails
```

## toBeLessThanOrEqualTo()
Tests whether the actual value is less than or equal to expected value.

This matcher works with any type that conforms to the `Comparable` protocol:
```swift
expect(2).toBeLessThanOrEqualTo(5) // Passes
expect(2).toBeLessThanOrEqualTo(2) // Passes
expect(5).toBeLessThanOrEqualTo(2) // Fails
```

## toBeTruthy()
Tests whether the value is Truthy.

```swift
expect("Anakin".isEmpty).toBeTruthy() // Fails
expect("".isEmpty).toBeTruthy() // Passes
```

## toBeFalsy()
Tests whether the value is Falsy.

```swift
expect("Anakin".isEmpty).toBeFalsy() // Passes
expect("".isEmpty).toBeFalsy() // Fails
```

## toBeNil()
Tests whether the value is `nil`.

```swift
let optional: String? = nil
expect(optional).toBeNil() // Passes
expect(optional).not.toBeNil() // Fails
```

## toBeEmpty()
Tests whether a collection of values is empty.

This matcher works with any type that conforms to the `Collection` protocol, like `Array` or `String`:
```swift
expect([1, 2, 3]).toBeEmpty() // Fails
expect([Int]()).toBeEmpty() //Passes

expect("Luke Skywalker").toBeEmpty() // Fails
expect("").toBeEmpty() // Passes
```

## toHaveCount()
Tests whether a collection has a expected number of elements

This matcher works with any type that conforms to the `Collection` protocol:
```swift
expect("Anakin").toHaveCount(2) // Fails
expect("Anakin").toHaveCount(6) // Passes

expect([1, 2, 3, 4]).toHaveCount(2) // Fails
expect([1, 2, 3, 4]).toHaveCount(4) // Passes
```

## toBeWithin()
Tests whether the actual value is within a range.

Open range:
```swift
expect(15).toBeWithin(0..<10) // Fails
expect(10).toBeWithin(0..<10) // Fails
expect(7).toBeWithin(0..<10) // Passes
```

Closed range:
```swift
expect(15).toBeWithin(0...10) // Fails
expect(10).toBeWithin(0...10) // Passes
expect(7).toBeWithin(0...10) // Passes
```

## toContain()
Verifies whether the actual value contains all the expected values.

Sequence:
```swift
expect([1, 2, 3, 4, 5]).toContain(1) // Passes
expect([1, 2, 3, 4, 5]).toContain([2, 3]) // Passes
expect([1, 2, 3, 4, 5]).toContain(7) // Fails
expect([1, 2, 3, 4, 5]).toContain([1, 7]) // Fails
```

SetAlgebra:
```swift
struct RefreshOptions: OptionSet {
    let rawValue: Int8

    static let hourly = RefreshOptions(rawValue: 1 << 0)
    static let daily = RefreshOptions(rawValue: 1 << 1)
    static let weekly = RefreshOptions(rawValue: 1 << 2)
    static let monthly = RefreshOptions(rawValue: 1 << 3)
    static let yearly = RefreshOptions(rawValue: 1 << 4)
}

let set: RefreshOptions = [.hourly, .daily, .weekly, .monthly]

expect(set).toContain(.daily) // Passes
expect(set).toContain([.hourly, .daily]) // Passes
expect(set).toContain(.yearly) // Fails
expect(set).toContain([.daily, .yearly]) // Fails
```

String:
```swift
expect("Anakin").toContain("Anakin") // Passes
expect("Anakin").toContain("anakin") // Fails
expect("Anakin").toContain("anakin", comparisonOptions: .caseInsensitive) // Passes
```

## toStartWith()
Tests whether a String starts the expected substring.

```swift
expect("Anakin").toStartWith("Ana") // Passes
expect("Anakin").toStartWith("ana") // Fails
expect("Anakin").toStartWith("ana", comparisonOptions: .caseInsensitive) // Passes
```


## toEndWith() 
Tests whether a String ends the expected substring.

```swift
expect("Anakin").toEndWith("kin") // Passes
expect("Anakin").toEndWith("KiN") // Fails
expect("Anakin").toEndWith("KiN", comparisonOptions: .caseInsensitive) // Passes
```

## toThrow()
Tests whether the expression thrown an Error.


Did throw any error?
```swift
expect({ try throwError(NetworkingError.server) }).toThrow() // Passes
expect({ try throwError(nil) }).toThrow() // Fails
```

Did throw an Error of specified type?
```swift
expect({ try throwError(NetworkingError.server) }).toThrow(NetworkingError.self) // Passes
expect({ try throwError(HttpError.badRequest) }).toThrow(NetworkingError.self) // Fails
```

Did throw a specific Error?
```swift
 expect({ try throwError(NetworkingError.server) }).toThrow(NetworkingError.server) // Passes
 expect({ try throwError(HttpError.badRequest) }).toThrow(HttpError.notFound) // Fails
```
