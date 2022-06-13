//
//  Array+Extensions.swift
//  MockGenerator
//
//  Created by Yusuf Özgül on 13.06.2022.
//

import Foundation

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
