//
//  DataModel.swift
//  chapter-09_TaskLocal
//
//  Created by 丰源天下传媒 on 2023/3/5.
//

import Foundation

fileprivate func generateCurrentTimeStamp () -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd hh:mm:ss.SSS"
    return (formatter.string(from: Date()) as NSString) as String
}

fileprivate func generateRandomInt () -> Int {
    return Int.random(in: 1...100)
}


class DataModel: ObservableObject {
    var nameList: [String] = ["wolf-man1", "bear-man1", "wolf-man2","bear-man2","bear-man3"]
    @TaskLocal static var processingLabel = -1
    @Published var renameList: [String] = []
    
    // 在不同的task中，共享TaskLocal 值
    func checkName(name: String) async throws -> String {
        print("\(name): \(DataModel.processingLabel) start....")
        var result = ""
        // 可以看出，即使中途被更新了，仍然保持了最初的设值。
        if name == "bear-man1" {
            try! await Task.sleep(nanoseconds: 1_000_000_000)
        }
        
        if name.contains("wolf") {
            result = "No 1. \(name) \(DataModel.processingLabel)"
        }
        if name.contains("bear") {
            result = "No 2. \(name) \(DataModel.processingLabel)"
        }
        print("\(name): \(DataModel.processingLabel) end....")
        return result
    }
    
    // 产生TaskLocal 值
    func rename(name: String) async throws -> String {
        let label = generateRandomInt()
        var result = ""
        try await DataModel.$processingLabel.withValue(label) {
            print("rename \(name): \(DataModel.processingLabel) start....")
            result = try await checkName(name: name)
            print("rename \(name): \(DataModel.processingLabel) end....")
        }
        return result
    }
    
    @MainActor func updateName() async {
        self.renameList = []
        await withTaskGroup(of: String.self) { taskGroup -> Void in
            for name in nameList {
                taskGroup.addTask { try! await self.rename(name: name) }
            }
            /// 获取 taskgroup 结果
            for await result in taskGroup {
                // @MainActor 是不是可以优化一下呢？
                self.renameList.append(result)
            }
        }
    }
    
    // 优化updateName
    func updateName2() async {
        await MainActor.run {
            self.renameList = []
        }
        await withTaskGroup(of: String.self) { taskGroup -> Void in
            for name in nameList {
                taskGroup.addTask { try! await self.rename(name: name) }
            }
            /// 获取 taskgroup 结果
            for await result in taskGroup {
                await MainActor.run {
                    self.renameList.append(result)
                }
            }
        }
    }
    
}
