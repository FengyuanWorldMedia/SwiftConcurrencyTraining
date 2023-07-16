//
//  ContentView.swift
//  chapter-21_ActorReentrancy
//
//  Created by 丰源天下传媒 on 2023/4/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Button("ActorCounter test", action: {
                let counter = ActorCounter()
                
                Task.detached { print(await counter.increment(tag: "001")) }
                Task.detached { print(await counter.increment(tag: "002")) }
                Task.detached { print(await counter.increment(tag: "003")) }
            })
            
            Button("ActorCounter2 test", action: {
                let counter = ActorCounter2()
                Task.detached { print(await counter.increment(tag: "001")) }
                Task.detached { print(await counter.increment(tag: "002")) }
                Task.detached { print(await counter.increment(tag: "003")) }
            })
            Button("ActorCounter3 test", action: {
                let counter = ActorCounter3()
                Task.detached { print(await counter.increment(tag: "001")) }
                Task.detached { print(await counter.increment(tag: "002")) }
                Task.detached { print(await counter.increment(tag: "003")) }
            })
            Button("ActorCounter4 test", action: {
                let counter = ActorCounter4()
                Task.detached { print(await counter.increment(tag: "001")) }
                Task.detached { print(await counter.increment(tag: "002")) }
                Task.detached { print(await counter.increment(tag: "003")) }
            })
            
            Button("Nonisolated test", action: {
                let wolfMan = WolfMan(name: "狼人1号", rankingNo: "第一勇士")
                if let encoded = try? JSONEncoder().encode(wolfMan) {
                    let json = String(decoding: encoded, as: UTF8.self)
                    print(json)
                }
            })
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
