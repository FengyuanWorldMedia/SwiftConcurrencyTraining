//
//  03_AsyncLineSequence.swift
//  chapter-08_AsyncSequence
//
//  Created by 丰源天下传媒 on 2023/3/4.
//

import Foundation

// 理解： AsyncLineSequence 定义
func testAsyncLineSequence () {
    Task {
        let url = URL(string: "https://www.apple.com/")!
        for try await line in url.lines {
            print(line + "🌟")
        }
    }
}
