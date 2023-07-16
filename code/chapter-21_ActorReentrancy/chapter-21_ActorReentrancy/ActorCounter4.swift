//
//  ActorCounter4.swift
//  chapter-21_ActorReentrancy
//
//  Created by 丰源天下传媒 on 2023/4/23.
//

import Foundation

actor ActorCounter4 {
   var count: Int = 0
   // increment 方法不是排他调用的。设计的时候需要注意。
   // 由于await的执行， actor内部状态可以被其他task改变。也就是increment可以同时执行。
   // 从await后 的执行，仍然actor是线程安全的。（开启Debug模式）
   func increment(tag: String) async -> Int {
       print("\(tag) -- ActorCounter4 start --")
       count += 1
       sleep(2)
       print("\(tag) -- ActorCounter4 start 1--")
       try! await Task.sleep(nanoseconds: 1_000_000_000)
       print("\(tag) -- ActorCounter4 start 2--")
       count += 1
       print("\(tag) -- ActorCounter4 end --")
       return count
   }
}
 
