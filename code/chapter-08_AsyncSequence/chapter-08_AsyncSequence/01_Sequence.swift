//
//  01_Sequence.swift
//  chapter-08_AsyncSequence
//
//  Created by 丰源天下传媒 on 2023/3/4.
//

import Foundation

struct Countdown: Sequence {
    let start: Int
    func makeIterator() -> CountdownIterator {
         return CountdownIterator(self)
    }
}

struct CountdownIterator: IteratorProtocol {
    
     typealias Element = Int
     
     let countdown: Countdown
     var times = 0

     init(_ countdown: Countdown) {
         self.countdown = countdown
     }
     
     mutating func next() -> Element? {
         print("next")
         let nextNumber = countdown.start - times
         guard nextNumber > 0 else {
             return nil
         }
         times += 1
         return nextNumber
     }
}

func testSequence() {
    
    let threeTwoOne = Countdown(start: 3)
//    for count in threeTwoOne {
//        print("\(count)...")
//    }
//
//    // 理解contains，这里已经和有没有 真实的元素没有关系了。
//    let existFlag = threeTwoOne.contains(1)
//    print("1 \(existFlag)")
    _ = threeTwoOne.contains(2)
//    _ = threeTwoOne.contains(3)
//    _ = threeTwoOne.contains(4)
//
    let firstEle = threeTwoOne.first(where: { $0 > 2 })
//    print(firstEle!)
}

