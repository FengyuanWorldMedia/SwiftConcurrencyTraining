//
//  02_Continuation.swift
//  chapter-12_Continuation
//
//  Created by 丰源天下传媒 on 2023/3/14.
//

import Foundation

func getWolfManNames2(completion: @escaping () -> Void) {
    DispatchQueue.main.async {
        completion()
    }
}

func getWolfManNames2() async {
    // await withUnsafeContinuation 的返回值为 Void 类型
    // withUnsafeContinuation 和 withCheckedContinuation 一样，只不过是 牺牲了check resume调用时间，提高了性能。
    // 有可能出现为定义的执行结果。
    // 性能有要求的时候，使用withUnsafeContinuation。
    //https://developer.apple.com/documentation/swift/unsafecontinuation
    await withUnsafeContinuation { (continuation: UnsafeContinuation<Void, Never>)  -> Void in
        getWolfManNames2 {
            /// 通过continuation.resume ， 代替completion ,  返回 Void
//            continuation.resume()
        }
    }
}

func test02_Continuation() {
    Task {
       await getWolfManNames2()
       print("test02_Continuation End")
    }
}

