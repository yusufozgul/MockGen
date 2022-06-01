# Swift Mock Generator Xcode Extension

A simple Xcode extension for generate mock class.

<img width="256" alt="256@2x" src="https://user-images.githubusercontent.com/26109252/171494436-c8c7cb43-1c4a-40eb-8265-771333d68f06.png">

---


![MockGen](https://user-images.githubusercontent.com/26109252/171489814-f082e317-beef-4acb-8f8b-c66198ea2345.gif)

## How does it work
MockGen parse string source code and generate mock. Mostly thanks `SwiftSemantics` and `SwiftSyntax`
MockGen works with Xcode alert. You should first tap fix button when Xcode say `Type 'XClass' does not conform to protocol 'XProtocol'`. Then run extension. Extension reads your current file and generate mock. 
MockGen doesn't need to read your entire project. 

## Installation
- Download MockGen
- Move MockGen to Applications folder
- Open System Preferences
- Open Extensions and Xcode Source Editor. Activate MockGen

## Features
- Spy mock generation
- Simple and fast
- No need access all files
- Powered by Apples open source SwiftSyntax and other.

## Cons
- MockGen can't determinate variables accessors. All variables generate mocks with `get set` accessors.

---
ProductProtocol
```Swift
protocol ProductProtocol {
    var name: String { get }
    var favoriteStatus: String { get set }

    func openImages()
    func description() -> String
    func addToBasket(completion: (Bool) -> Void)
}
```

Xcode fixed MockProduct
```Swift
final class MockProduct: ProductProtocol {
    var name: String

    var favoriteStatus: String

    func openImages() {
        <#code#>
    }

    func description() -> String {
        <#code#>
    }

    func addToBasket(completion: (Bool) -> Void) {
        <#code#>
    }
}
```

MockGen generated mock
```Swift
final class MockProduct: ProductProtocol {
    var invokedNameSetter = false
    var invokedNameSetterCount = 0
    var invokedName: String?
    var invokedNameList: [String] = []
    var invokedNameGetter = false
    var invokedNameGetterCount = 0
    var stubbedName: String!
    var name: String {
        set {
            invokedNameSetter = true
            invokedNameSetterCount += 1
            invokedName = newValue
            invokedNameList.append(newValue)
        }
        get {
            invokedNameGetter = true
            invokedNameGetterCount += 1
            return stubbedName
        }
    }

    var invokedFavoriteStatusSetter = false
    var invokedFavoriteStatusSetterCount = 0
    var invokedFavoriteStatus: String?
    var invokedFavoriteStatusList: [String] = []
    var invokedFavoriteStatusGetter = false
    var invokedFavoriteStatusGetterCount = 0
    var stubbedFavoriteStatus: String!
    var favoriteStatus: String {
        set {
            invokedFavoriteStatusSetter = true
            invokedFavoriteStatusSetterCount += 1
            invokedFavoriteStatus = newValue
            invokedFavoriteStatusList.append(newValue)
        }
        get {
            invokedFavoriteStatusGetter = true
            invokedFavoriteStatusGetterCount += 1
            return stubbedFavoriteStatus
        }
    }

    var invokedOpenImages = false
    var invokedOpenImagesCount = 0
    func openImages() {
        invokedOpenImages = true
        invokedOpenImagesCount += 1
    }

    var invokedDescription = false
    var invokedDescriptionCount = 0
    var stubbedDescriptionResult: String!
    func description() -> String {
        invokedDescription = true
        invokedDescriptionCount += 1
        return stubbedDescriptionResult
    }

    var invokedAddToBasket = false
    var invokedAddToBasketCount = 0
    var stubbedAddToBasketCompletionResult: (Bool, Void)?
    func addToBasket(completion: (Bool) -> Void) {
        invokedAddToBasket = true
        invokedAddToBasketCount += 1
        if let result = stubbedAddToBasketCompletionResult {
            _ = completion(result.0)
        }
    }
}
```
---

## Similar Projects
- [SwiftMockGeneratorForXcode](https://github.com/seanhenry/SwiftMockGeneratorForXcode)
- [Rubicon](https://github.com/raptorxcz/Rubicon)
- [Parrot](https://github.com/Bayer-Group/Parrot)
- [mockolo](https://github.com/uber/mockolo)


## Credits
- [SwiftSemantics](https://github.com/SwiftDocOrg/SwiftSemantics) - Forked and updated [SwiftSemantics](https://github.com/yusufozgul/SwiftSemantics)
- [SwiftSyntax](https://github.com/apple/swift-syntax)
- [swift-format](https://github.com/apple/swift-format)
