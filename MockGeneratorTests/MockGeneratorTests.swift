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
    }

}
