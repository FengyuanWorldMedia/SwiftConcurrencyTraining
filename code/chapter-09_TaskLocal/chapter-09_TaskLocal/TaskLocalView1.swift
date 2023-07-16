//
//  TaskLocalView1.swift
//  chapter-09_TaskLocal
//
//  Created by 丰源天下传媒 on 2023/3/5.
//

import SwiftUI

struct CompanyInfo {
    @TaskLocal static var name = "丰源天下"
}

struct TaskLocalView1: View {
    var body: some View {
        VStack {
            Button("测试TaskLocal", action: {
                testTaskLocal()
            })
        }
    }
     
    func testTaskLocal() {
        Task {
            try await CompanyInfo.$name.withValue("丰源天下-科技") {
                print("Start of task1: \(CompanyInfo.name)")
                try await Task.sleep(nanoseconds: 1_000_000)
                print("End of task1: \(CompanyInfo.name)")
            }
            print("111 of tasks: \(CompanyInfo.name)")
        }

        Task {
            try await CompanyInfo.$name.withValue("丰源天下-传媒") {
                print("Start of task2: \(CompanyInfo.name)")
                try await Task.sleep(nanoseconds: 1_000_000)
                print("End of task2: \(CompanyInfo.name)")
            }
            print("222 of tasks: \(CompanyInfo.name)")
        }
        print("Outside of tasks: \(CompanyInfo.name)")
    }
    
}

struct TaskLocalView1_Previews: PreviewProvider {
    static var previews: some View {
        TaskLocalView1()
    }
}
