//
//  ActorCounterTestView.swift
//  chapter-19_Actors
//
//  Created by 丰源天下传媒 on 2023/4/22.
//

import SwiftUI

struct ActorCounterTestView: View {
    let counter = ActorCounter()
    
    var body: some View {
        VStack {
            Text("ActorCounter不会产生问题")
            Button(action: {
                Task.detached {
                    print(await counter.increment())
                }
                Task.detached {
                    print(await counter.increment())
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


actor ActorCounter {
    var count = 0
    func increment() -> Int {
        count += 1
        return count
    }
}

struct ActorCounterTestView_Previews: PreviewProvider {
    static var previews: some View {
        ActorCounterTestView()
    }
}
