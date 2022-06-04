//
//  String+Extension.swift
//  MockGen
//
//  Created by Yusuf Özgül on 29.05.2022.
//

import Foundation

extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
}

extension String {
    var lines: [String] {
        components(separatedBy: "\n")
    }
}
