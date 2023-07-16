//
//  SendableTestView1.swift
//  chapter-20_Sendable
//
//  Created by 丰源天下传媒 on 2023/4/22.
//

import SwiftUI

struct SendableTestView1: View {
    @State var intValue = 1
    var body: some View {
        VStack {
            Button(action: {
                Task{
                    await printRankingNo1()
                    await printCounter()
                }
            }, label: {
                Text("Click")
            })
        }
    }

    func printRankingNo1() async {
        let rankingNo = 100
        // @discardableResult
        // public Task#init(priority: TaskPriority? = nil, operation: @escaping @Sendable () async -> Success)
        Task { print(rankingNo) }
        Task { print(rankingNo) }
    }
    
//    Any values that the function or closure captures must be sendable. In addition, sendable closures must use only by-value captures, and the captured values must be of a sendable type.
    func printRankingNo2() async {
        var rankingNo: Int = 100
        Task { [rankingNo] in
            print(rankingNo)
        }
        Task { [rankingNo] in
            print(rankingNo)
        }
    }
    
    func printCounter() async {
        let counter = Counter()
        Task {
            print(await counter.increment())
        }
        Task {
            print(await counter.increment())
        }
    }
    
    func printCounter() {
        var sendableClosure = { @Sendable (number: Int) -> String in
            if number > 12 {
                return "More than a dozen."
            } else {
                return "Less than a dozen"
            }
        }
        Task { [sendableClosure] in
            sendableClosure(1)
        }
        Task { [sendableClosure] in
            sendableClosure(2)
        }
    }
}


actor Counter {
    var count = 0
    func increment() -> Int {
        count += 1
        return count
    }
}

struct SendableTestView1_Previews: PreviewProvider {
    static var previews: some View {
        SendableTestView1()
    }
}
