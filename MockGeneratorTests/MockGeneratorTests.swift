//
//  MockGeneratorTests.swift
//  MockGeneratorTests
//
//  Created by Yusuf Özgül on 4.06.2022.
//

import XCTest
@testable import MockGenerator

class MockGeneratorTests: XCTestCase {
    var spyGenerator: SpyGenerator!
    var xcode: MockXcodeProtocol!

    override func setUp() {
        super.setUp()
        xcode = .init()
        spyGenerator = .init(buffer: xcode)
        xcode.stubbedIndentationWidth = 4
        xcode.stubbedUsesTabsForIndentation = false
    }

    func test_generate_JustVariable_ReturnMock() throws {
        let file = """
class TestClass: TestProtocol {
    var someVariable: Data
}
"""

        let mock = """
class TestClass: TestProtocol {
    var invokedSomeVariableSetter = false
    var invokedSomeVariableSetterCount = 0
    var invokedSomeVariable: Data?
    var invokedSomeVariableList: [Data] = []
    var invokedSomeVariableGetter = false
    var invokedSomeVariableGetterCount = 0
    var stubbedSomeVariable: Data!
    var someVariable: Data {
        set {
            invokedSomeVariableSetter = true
            invokedSomeVariableSetterCount += 1
            invokedSomeVariable = newValue
            invokedSomeVariableList.append(newValue)
        }
        get {
            invokedSomeVariableGetter = true
            invokedSomeVariableGetterCount += 1
            return stubbedSomeVariable
        }
    }

}

"""

        XCTAssertEqual(try spyGenerator.generate(source: file), mock)
    }

    func test_generate_JustSimpleFunction_ReturnMock() throws {
        let file = """
class TestClass: TestProtocol {
    func setValue() {
        <#code#>
    }
}
"""

        let mock = """
class TestClass: TestProtocol {
    var invokedSetValue = false
    var invokedSetValueCount = 0
    func setValue() {
        invokedSetValue = true
        invokedSetValueCount += 1
    }

}

"""

        XCTAssertEqual(try spyGenerator.generate(source: file), mock)
    }

    func test_generate_JustInputFunction_ReturnMock() throws {
        let file = """
class TestClass: TestProtocol {
    func setValue(data: NSObject) {
        <#code#>
    }
}
"""

        let mock = """
class TestClass: TestProtocol {
    var invokedSetValue = false
    var invokedSetValueCount = 0
    var invokedSetValueParameters: (data: NSObject, Void)?
    var invokedSetValueParametersList: [(data: NSObject, Void)] = []
    func setValue(data: NSObject) {
        invokedSetValue = true
        invokedSetValueCount += 1
        invokedSetValueParameters = (data, ())
        invokedSetValueParametersList.append((data, ()))
    }

}

"""

        XCTAssertEqual(try spyGenerator.generate(source: file), mock)
    }

    func test_generate_JustOutputFunction_ReturnMock() throws {
        let file = """
class TestClass: TestProtocol {
    func getValue() -> Error {
        <#code#>
    }
}
"""

        let mock = """
class TestClass: TestProtocol {
    var invokedGetValue = false
    var invokedGetValueCount = 0
    var stubbedGetValueResult: Error!
    func getValue() -> Error {
        invokedGetValue = true
        invokedGetValueCount += 1
        return stubbedGetValueResult
    }

}

"""

        XCTAssertEqual(try spyGenerator.generate(source: file), mock)
    }

    func test_generate_JustClosureFunction_ReturnMock() throws {
        let file = """
class TestClass: TestProtocol {
    func fetchValue(completion: (String) -> Void) {
        <#code#>
    }
}
"""

        let mock = """
class TestClass: TestProtocol {
    var invokedFetchValue = false
    var invokedFetchValueCount = 0
    var stubbedFetchValueCompletionResult: (String, Void)?
    func fetchValue(completion: (String) -> Void) {
        invokedFetchValue = true
        invokedFetchValueCount += 1
        if let result = stubbedFetchValueCompletionResult {
            _ = completion(result.0)
        }
    }

}

"""

        XCTAssertEqual(try spyGenerator.generate(source: file), mock)
    }

    func test_generate_WithDefaultValue_ReturnMock() throws {
        let file = """
class TestClass: TestProtocol {
    var testString: String
    var testInt: Int
    var testDouble: Double
    var testFloat: Float
    var testCGFloat: CGFloat
    var testBool: Bool

    func fetchValue() -> Bool {
        <#code#>
    }
}
"""

        let mock = """
class TestClass: TestProtocol {
    var invokedTestStringSetter = false
    var invokedTestStringSetterCount = 0
    var invokedTestString: String?
    var invokedTestStringList: [String] = []
    var invokedTestStringGetter = false
    var invokedTestStringGetterCount = 0
    var stubbedTestString: String! = ""
    var testString: String {
        set {
            invokedTestStringSetter = true
            invokedTestStringSetterCount += 1
            invokedTestString = newValue
            invokedTestStringList.append(newValue)
        }
        get {
            invokedTestStringGetter = true
            invokedTestStringGetterCount += 1
            return stubbedTestString
        }
    }

    var invokedTestIntSetter = false
    var invokedTestIntSetterCount = 0
    var invokedTestInt: Int?
    var invokedTestIntList: [Int] = []
    var invokedTestIntGetter = false
    var invokedTestIntGetterCount = 0
    var stubbedTestInt: Int! = 0
    var testInt: Int {
        set {
            invokedTestIntSetter = true
            invokedTestIntSetterCount += 1
            invokedTestInt = newValue
            invokedTestIntList.append(newValue)
        }
        get {
            invokedTestIntGetter = true
            invokedTestIntGetterCount += 1
            return stubbedTestInt
        }
    }

    var invokedTestDoubleSetter = false
    var invokedTestDoubleSetterCount = 0
    var invokedTestDouble: Double?
    var invokedTestDoubleList: [Double] = []
    var invokedTestDoubleGetter = false
    var invokedTestDoubleGetterCount = 0
    var stubbedTestDouble: Double! = 0.0
    var testDouble: Double {
        set {
            invokedTestDoubleSetter = true
            invokedTestDoubleSetterCount += 1
            invokedTestDouble = newValue
            invokedTestDoubleList.append(newValue)
        }
        get {
            invokedTestDoubleGetter = true
            invokedTestDoubleGetterCount += 1
            return stubbedTestDouble
        }
    }

    var invokedTestFloatSetter = false
    var invokedTestFloatSetterCount = 0
    var invokedTestFloat: Float?
    var invokedTestFloatList: [Float] = []
    var invokedTestFloatGetter = false
    var invokedTestFloatGetterCount = 0
    var stubbedTestFloat: Float! = 0.0
    var testFloat: Float {
        set {
            invokedTestFloatSetter = true
            invokedTestFloatSetterCount += 1
            invokedTestFloat = newValue
            invokedTestFloatList.append(newValue)
        }
        get {
            invokedTestFloatGetter = true
            invokedTestFloatGetterCount += 1
            return stubbedTestFloat
        }
    }

    var invokedTestCGFloatSetter = false
    var invokedTestCGFloatSetterCount = 0
    var invokedTestCGFloat: CGFloat?
    var invokedTestCGFloatList: [CGFloat] = []
    var invokedTestCGFloatGetter = false
    var invokedTestCGFloatGetterCount = 0
    var stubbedTestCGFloat: CGFloat! = 0.0
    var testCGFloat: CGFloat {
        set {
            invokedTestCGFloatSetter = true
            invokedTestCGFloatSetterCount += 1
            invokedTestCGFloat = newValue
            invokedTestCGFloatList.append(newValue)
        }
        get {
            invokedTestCGFloatGetter = true
            invokedTestCGFloatGetterCount += 1
            return stubbedTestCGFloat
        }
    }

    var invokedTestBoolSetter = false
    var invokedTestBoolSetterCount = 0
    var invokedTestBool: Bool?
    var invokedTestBoolList: [Bool] = []
    var invokedTestBoolGetter = false
    var invokedTestBoolGetterCount = 0
    var stubbedTestBool: Bool! = false
    var testBool: Bool {
        set {
            invokedTestBoolSetter = true
            invokedTestBoolSetterCount += 1
            invokedTestBool = newValue
            invokedTestBoolList.append(newValue)
        }
        get {
            invokedTestBoolGetter = true
            invokedTestBoolGetterCount += 1
            return stubbedTestBool
        }
    }

    var invokedFetchValue = false
    var invokedFetchValueCount = 0
    var stubbedFetchValueResult: Bool!
    func fetchValue() -> Bool {
        invokedFetchValue = true
        invokedFetchValueCount += 1
        return stubbedFetchValueResult
    }

}

"""

        XCTAssertEqual(try spyGenerator.generate(source: file), mock)
    }

    func test_generate_StaticVariable_ReturnMock() throws {
        let file = """
class TestClass: TestProtocol {
    static var testString: String
}
"""

        let mock = """
class TestClass: TestProtocol {
    var invokedTestStringSetter = false
    var invokedTestStringSetterCount = 0
    var invokedTestString: String?
    var invokedTestStringList: [String] = []
    var invokedTestStringGetter = false
    var invokedTestStringGetterCount = 0
    var stubbedTestString: String! = ""
    static var testString: String {
        set {
            invokedTestStringSetter = true
            invokedTestStringSetterCount += 1
            invokedTestString = newValue
            invokedTestStringList.append(newValue)
        }
        get {
            invokedTestStringGetter = true
            invokedTestStringGetterCount += 1
            return stubbedTestString
        }
    }

}

"""

        XCTAssertEqual(try spyGenerator.generate(source: file), mock)
    }

    func test_generate_ParameterLabels_ReturnMock() throws {
        let file = """
class TestClass: TestProtocol {
    func setValue(from data: NSObject) {
        <#code#>
    }

    func setDate(_ date: Date) {
        <#code#>
    }
}
"""

        let mock = """
class TestClass: TestProtocol {
    var invokedSetValue = false
    var invokedSetValueCount = 0
    var invokedSetValueParameters: (data: NSObject, Void)?
    var invokedSetValueParametersList: [(data: NSObject, Void)] = []
    func setValue(from data: NSObject) {
        invokedSetValue = true
        invokedSetValueCount += 1
        invokedSetValueParameters = (data, ())
        invokedSetValueParametersList.append((data, ()))
    }

    var invokedSetDate = false
    var invokedSetDateCount = 0
    var invokedSetDateParameters: (date: Date, Void)?
    var invokedSetDateParametersList: [(date: Date, Void)] = []
    func setDate(_ date: Date) {
        invokedSetDate = true
        invokedSetDateCount += 1
        invokedSetDateParameters = (date, ())
        invokedSetDateParametersList.append((date, ()))
    }

}

"""

        XCTAssertEqual(try spyGenerator.generate(source: file), mock)
    }

    func test_generate_MethodOverloading_ReturnMock() throws {
        let file = """
class TestClass: TestProtocol {
    func setValue(intValue: Int) {
        <#code#>
    }

    func setValue(stringValue: String) {
        <#code#>
    }

    func setValue(boolValue: Bool) {
        <#code#>
    }

    func setValue(boolValue: Bool, defaultFalse: Bool) {
        <#code#>
    }
}
"""

        let mock = """
class TestClass: TestProtocol {
    var invokedSetValueIntValue = false
    var invokedSetValueIntValueCount = 0
    var invokedSetValueIntValueParameters: (intValue: Int, Void)?
    var invokedSetValueIntValueParametersList: [(intValue: Int, Void)] = []
    func setValue(intValue: Int) {
        invokedSetValueIntValue = true
        invokedSetValueIntValueCount += 1
        invokedSetValueIntValueParameters = (intValue, ())
        invokedSetValueIntValueParametersList.append((intValue, ()))
    }

    var invokedSetValueStringValue = false
    var invokedSetValueStringValueCount = 0
    var invokedSetValueStringValueParameters: (stringValue: String, Void)?
    var invokedSetValueStringValueParametersList: [(stringValue: String, Void)] = []
    func setValue(stringValue: String) {
        invokedSetValueStringValue = true
        invokedSetValueStringValueCount += 1
        invokedSetValueStringValueParameters = (stringValue, ())
        invokedSetValueStringValueParametersList.append((stringValue, ()))
    }

    var invokedSetValueBoolValue = false
    var invokedSetValueBoolValueCount = 0
    var invokedSetValueBoolValueParameters: (boolValue: Bool, Void)?
    var invokedSetValueBoolValueParametersList: [(boolValue: Bool, Void)] = []
    func setValue(boolValue: Bool) {
        invokedSetValueBoolValue = true
        invokedSetValueBoolValueCount += 1
        invokedSetValueBoolValueParameters = (boolValue, ())
        invokedSetValueBoolValueParametersList.append((boolValue, ()))
    }

    var invokedSetValueBoolValueDefaultFalse = false
    var invokedSetValueBoolValueDefaultFalseCount = 0
    var invokedSetValueBoolValueDefaultFalseParameters: (boolValue: Bool, defaultFalse: Bool, Void)?
    var invokedSetValueBoolValueDefaultFalseParametersList:
        [(boolValue: Bool, defaultFalse: Bool, Void)] = []
    func setValue(boolValue: Bool, defaultFalse: Bool) {
        invokedSetValueBoolValueDefaultFalse = true
        invokedSetValueBoolValueDefaultFalseCount += 1
        invokedSetValueBoolValueDefaultFalseParameters = (boolValue, defaultFalse, ())
        invokedSetValueBoolValueDefaultFalseParametersList.append((boolValue, defaultFalse, ()))
    }

}

"""

        XCTAssertEqual(try spyGenerator.generate(source: file), mock)
    }
}
