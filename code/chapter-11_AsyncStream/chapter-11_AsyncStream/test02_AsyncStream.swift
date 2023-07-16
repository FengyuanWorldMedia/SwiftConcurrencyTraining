//
//  test02_AsyncStream.swift
//  chapter-11_AsyncStream
//
//  Created by 丰源天下传媒 on 2023/3/12.
//

import Foundation

struct IntGenerator02 {
    // 理解 bufferingPolicy https://developer.apple.com/documentation/swift/asyncstream/init(_:bufferingpolicy:_:)
    static let stream = AsyncStream<Int>(bufferingPolicy: .bufferingOldest(1)) { continuation in
        Task.detached {
            for i in 0..<100 {
                try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
                continuation.yield(i) // 生产者
            }
            continuation.finish()
        }
    }
}

func test02_AsyncStream() {
    Task {
        for await i in IntGenerator02.stream { // 消费者
             try await Task.sleep(nanoseconds: 6 * 1_000_000_000)
             print(i)
         }
    }
}

