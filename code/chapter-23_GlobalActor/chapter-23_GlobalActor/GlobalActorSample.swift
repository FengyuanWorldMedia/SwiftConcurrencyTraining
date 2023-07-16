//
//  GlobalActorSample.swift
//  chapter-23_GlobalActor
//
//  Created by 丰源天下传媒 on 2023/4/30.
//

import Foundation

@globalActor
public struct WolfManGlobalActor {
  public actor WolfManActor {}
  public static let shared = WolfManActor()
}

extension WolfManGlobalActor {
    public static func run<T>(resultType: T.Type = T.self,
                           body: @WolfManGlobalActor @Sendable () throws -> T)
                            async rethrows -> T where T : Sendable {
        try await body()
    }
}
 
var wolfBlock: @WolfManGlobalActor @Sendable () -> Void = {
    globalCount1 += 1
}

@WolfManGlobalActor var globalCount1: Int = 0

@WolfManGlobalActor func increaseCount22() {
    globalCount1 += 1   // 相同的Actor，可以同步访问
}

@WolfManGlobalActor func increaseCount1() {
    globalCount1 += 1   // 相同的Actor，可以同步访问
    increaseCount22()
}

func notOnTheWolfManGlobalActor() async {
    
    await WolfManGlobalActor.run {
        globalCount1 = 12
        increaseCount1()
    }
    
   await wolfBlock()
    
    globalCount1 = 12 // error: 与WolfManGlobalActor隔离，无法同步调用
    increaseCount1() // error: 与WolfManGlobalActor隔离，无法同步调用
    await increaseCount1() // 异步调用跳到WolfManGlobalActor 进行同步（我们不知道在哪个线程上执行😅），可以正常调用
}
