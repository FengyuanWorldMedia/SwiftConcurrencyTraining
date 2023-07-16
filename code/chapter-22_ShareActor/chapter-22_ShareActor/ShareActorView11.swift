//
//  ShareActorView1.swift
//  chapter-22_ShareActor
//
//  Created by 丰源天下传媒 on 2023/4/29.
//

import SwiftUI

class CountObject11: ObservableObject {
    @MainActor @Published var count = 0
     
    func test() async {
        do {
            try await Task.sleep(for: .seconds(2))
        } catch {
            return
        }
        // 想一想，为什么没有出现线程安全问题。
        await MainActor.run {
            if count % 2 != 0 {
                count += 1
            } else {
                count += 2
            }
        }
    }
}


struct ShareActorView11: View {
    
    @StateObject var object = CountObject11()
    
    var body: some View {
        VStack {
            Text("Test")
              .task {
                  print("11")
                   await object.test()
              }
            Text("Test")
              .task {
                  print("12")
                   await object.test()
              }
        }
      
    }
}

struct ShareActorView11_Previews: PreviewProvider {
    static var previews: some View {
        ShareActorView11()
    }
}
