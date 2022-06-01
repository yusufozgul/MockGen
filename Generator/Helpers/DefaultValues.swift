//
//  DefaultValues.swift
//  SwiftMockGen
//
//  Created by Yusuf Özgül on 1.06.2022.
//

import Foundation

enum DefaultValues: String {
    case `String`
    case `Int`
    case `Double`, `Float`, `CGFloat`
    case `Bool`

    var defaultValue: String {
        switch self {
        case .String:
            return #""""#
        case .Int:
            return "0"
        case .Double, .Float, .CGFloat:
            return "0.0"
        case .Bool:
            return "false"
        }
    }
}
