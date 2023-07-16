//
//  ShareActorView1.swift
//  chapter-22_ShareActor
//
//  Created by 丰源天下传媒 on 2023/4/29.
//

import SwiftUI

class CountObject: ObservableObject {
    @Published var count1 = 0
    @MainActor @Published var count = 0
     
    func test() async {
        // count += 1
        do {
            // 加入断点进行调试，检查线程信息
            try await Task.sleep(for: .seconds(2))
        } catch {
            return
        }
        // 如果class是 @MainActor，则在主线程上；如果不是，则在后台线程上
        await MainActor.run {
            count += 1
        }
        await MainActor.run {
            count1 += 1
        }
    }
}


struct ShareActorView1: View {
    
    @StateObject var object = CountObject()
    
    var body: some View {
        Text("Test")
          .task {
               await object.test()
          }
    }
}

struct ShareActorView1_Previews: PreviewProvider {
    static var previews: some View {
        ShareActorView1()
    }
}
