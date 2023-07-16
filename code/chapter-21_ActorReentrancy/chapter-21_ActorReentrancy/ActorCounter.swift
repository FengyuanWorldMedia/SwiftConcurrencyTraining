//
//  ActorCounter.swift
//  chapter-21_ActorReentrancy
//
//  Created by 丰源天下传媒 on 2023/4/23.
//

import Foundation

actor ActorCounter {
    var count = 0
    
    // increment 方法是排他调用的。
    func increment(tag: String) -> Int {
        print("\(tag) -- ActorCounter start --")
        sleep(5) // 5 second
        count += 1
        print("\(tag) -- ActorCounter end --")
        return count
    }
}
