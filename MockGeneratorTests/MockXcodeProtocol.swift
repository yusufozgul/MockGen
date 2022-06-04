//
//  MockXcodeProtocol.swift
//  MockGeneratorTests
//
//  Created by Yusuf Özgül on 4.06.2022.
//

@testable import MockGenerator

final class MockXcodeProtocol: XcodeProtocol {
    var invokedUsesTabsForIndentationGetter = false
    var invokedUsesTabsForIndentationGetterCount = 0
    var stubbedUsesTabsForIndentation: Bool! = false

    var usesTabsForIndentation: Bool {
        invokedUsesTabsForIndentationGetter = true
        invokedUsesTabsForIndentationGetterCount += 1
        return stubbedUsesTabsForIndentation
    }

    var invokedIndentationWidthGetter = false
    var invokedIndentationWidthGetterCount = 0
    var stubbedIndentationWidth: Int! = 0

    var indentationWidth: Int {
        invokedIndentationWidthGetter = true
        invokedIndentationWidthGetterCount += 1
        return stubbedIndentationWidth
    }
}
