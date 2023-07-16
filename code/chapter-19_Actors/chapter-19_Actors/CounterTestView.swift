//
//  CounterTestView.swift
//  chapter-19_Actors
//
//  Created by 丰源天下传媒 on 2023/4/22.
//

import SwiftUI

struct CounterTestView: View {
    let counter = Counter()
    
    var body: some View {
        VStack {
            Text("有可能产生数据不一致")
            Button(action: {
                Task.detached {
                    print(counter.increment())
                }
                Task.detached {
                    print(counter.increment())
                }
            }, label: {
                Image(systemName: "hourglass.bottomhalf.filled")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
            })
            .frame(width: 150,height: 50)
            .border(.blue)
            .background(Color.white)
            
        }
        .padding()
    }
}


class Counter {
    var count = 0
    func increment() -> Int {
        count += 1
        return count
    }
}
 
struct CounterTestView_Previews: PreviewProvider {
    static var previews: some View {
        CounterTestView()
    }
}
