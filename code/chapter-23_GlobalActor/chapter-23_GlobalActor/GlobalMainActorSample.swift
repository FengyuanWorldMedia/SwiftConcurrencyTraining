//
//  GlobalMainActorSample.swift
//  chapter-23_GlobalActor
//
//  Created by 丰源天下传媒 on 2023/4/30.
//

import Foundation

@MainActor var globalCount: Int = 0

@MainActor func increaseCount11() {
    globalCount += 2   // 相同的Actor，可以同步访问
}

@MainActor func increaseCount() {
    globalCount += 1   // 相同的Actor，可以同步访问
    increaseCount11()
}

func notOnTheMainActor() async {
    globalCount = 12 // error: 与MainActor隔离，无法同步调用
    increaseCount() // error: 与MainActor隔离，无法同步调用
    
    await MainActor.run {
        globalCount += 1
        increaseCount11()
    }
    
    await increaseCount() // 异步调用跳到主线程，可以正常调用
}
