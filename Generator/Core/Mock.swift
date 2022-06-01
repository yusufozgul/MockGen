//
//  Mock.swift
//  MockGen
//
//  Created by Yusuf Özgül on 29.05.2022.
//

import Foundation

class Mock: TextOutputStream {
    var mockClass: String = ""

    @discardableResult
    func addNewLine() -> Self {
        mockClass += "\n"
        return self
    }

    @discardableResult
    func add(_ text: String) -> Self {
        mockClass += text
        return self
    }

    @discardableResult
    func addToNewLine(_ text: String) -> Self {
        addNewLine()
        add(text)
        return self
    }

    func write(_ string: String) {
        mockClass = string
    }

}
