//
//  GenError.swift
//  MockGen
//
//  Created by Yusuf Özgül on 29.05.2022.
//

import Foundation

public enum GenError: String, Error {
    case classNameError

    public var error: Error {
        switch self {
        case .classNameError:
            return NSError(domain: "MockGen", code: 1, userInfo: [NSLocalizedDescriptionKey: "Class not found"])
        }
    }
}
