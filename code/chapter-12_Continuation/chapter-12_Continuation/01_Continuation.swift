//
//  01_Continuation.swift
//  chapter-12_Continuation
//
//  Created by 丰源天下传媒 on 2023/3/14.
//

import Foundation

func getWolfManNames(completion: @escaping ([String]) -> Void) {
    DispatchQueue.main.async {
        print("getWolfManNames")
        completion(["狼人1号-无敌", "狼人2号-旋风"])
    }
}

func getWolfManNames() async -> [String] {
    /// Suspends the current task,
    /// then calls the given closure with a checked continuation for the current task.
    // await withCheckedContinuation 的返回值为 [String] 类型
    // 非常重要的一点是： 确保continuation.resume 只被调用一次。
    return await withCheckedContinuation { (continuation: CheckedContinuation<[String], Never>) -> Void in
        getWolfManNames { items in
            /// 通过continuation.resume  接管来自 completion 的参数， 返回 String数组
//            continuation.resume(returning: items)
        }
    }
}


func test01_Continuation() {
    Task {
       let items = await getWolfManNames()
       for item in items {
         print(item)
       }
    }
}
