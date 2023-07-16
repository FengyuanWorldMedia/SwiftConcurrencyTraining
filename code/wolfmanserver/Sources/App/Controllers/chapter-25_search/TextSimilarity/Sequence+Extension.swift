//
//  File.swift
//  
//
//  Created by 苏州丰源天下传媒 on 2023/5/5.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
