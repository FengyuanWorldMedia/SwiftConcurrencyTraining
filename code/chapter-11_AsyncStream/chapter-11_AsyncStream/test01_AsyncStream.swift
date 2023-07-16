//
//  test01_AsyncStream.swift
//  chapter-11_AsyncStream
//
//  Created by 丰源天下传媒 on 2023/3/12.
//

import Foundation

struct IntGenerator01 {
    static let stream = AsyncStream<Int>() { continuation in
        Task {
            for i in 0..<10 {
                try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
                continuation.yield(i) // 生产者
            }
            continuation.finish()
        }
    }
}

func test01_AsyncStream() {
    Task {
        for await i in IntGenerator01.stream { // 消费者
             print(i)
         }
    }
}

