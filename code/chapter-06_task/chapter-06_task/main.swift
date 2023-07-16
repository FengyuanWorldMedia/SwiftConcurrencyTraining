//
//  main.swift
//  chapter-06_task
//
//  Created by 丰源天下传媒 on 2023/2/25.
//

import Foundation

// part1.
//func main() {
//    Task {
//        await receiveNotications()
//    }
//}
//main()

// part2.
//func main() {
//    let task1 = Task {
//        async let void11: Void = receiveNotications()
//        async let void12: Void = searchCompanyInfo()
//        let _ = await [void11, void12]
//    }
//
//    Task {
//        async let void: Void = try! Task.sleep(nanoseconds: UInt64(4 * 1_000_000_000))
//        await void
//        task1.cancel()
//        print("task1 is cancelled; \(task1.isCancelled)")
//    }
//}
//main()

// part3.
testTaskResult()

dispatchMain()
