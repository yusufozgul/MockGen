//
//  XcodeProtocol.swift
//  MockGenerator
//
//  Created by Yusuf Özgül on 4.06.2022.
//

import Foundation

public protocol XcodeProtocol {
    var usesTabsForIndentation: Bool { get }
    var indentationWidth: Int { get }
}
