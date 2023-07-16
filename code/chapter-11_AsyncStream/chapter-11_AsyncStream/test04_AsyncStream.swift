//
//  test04_AsyncStream.swift
//  chapter-11_AsyncStream
//
//  Created by 丰源天下传媒 on 2023/3/12.
//

import Foundation

struct IntGenerator04 {
    // 注意 onCancel 会被执行2次
    // 理解 https://developer.apple.com/documentation/swift/asyncstream/init(unfolding:oncancel:)
    static let stream = AsyncStream<Int> {
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        return Int.random(in: 1...10)  // 当返回nil 的时候，表示结束
    } onCancel: { @Sendable () in // 并发域之间传输是安全
        print("Canceled.")
    } 
}

func test04_AsyncStream() {
    let streamTask = Task {
        for await random in IntGenerator04.stream {
            print(random)
        }
    }
    Task {
        try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
        streamTask.cancel()
    }
}
