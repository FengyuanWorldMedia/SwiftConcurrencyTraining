//
//  02_AsyncSequence.swift
//  chapter-08_AsyncSequence
//
//  Created by 丰源天下传媒 on 2023/3/4.
//

import Foundation

struct Counter: AsyncSequence {
    typealias Element = Int
    let limit: Int
    func makeAsyncIterator() -> AsyncIterator {
        return AsyncIterator(limit: limit)
    }
}

struct AsyncIterator: AsyncIteratorProtocol {
    let limit: Int
    var current = 1
    mutating func next() async -> Int? {
        // 注意这里的判断
        guard !Task.isCancelled else {
            return nil
        }
        guard current <= limit else {
            return nil
        }
        let result = current
        current += 1
        return result
    }
}


func testAsyncSequence() {
    Task {
        let asyncCounter = Counter(limit: 3)
        for await count in asyncCounter {
            print("\(count)...")
        }
        // 理解contains，这里已经和有没有 真实的元素没有关系了。
        _ = await asyncCounter.contains(1)
        _ = await asyncCounter.contains(2)
        _ = await asyncCounter.contains(3)
        _ = await asyncCounter.contains(4)

        let firstEle = await asyncCounter.first(where: { $0 > 2 })
        print(firstEle!)
    }
}
