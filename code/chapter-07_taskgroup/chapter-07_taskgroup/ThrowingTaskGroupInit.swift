//
//  ThrowingTaskGroupInit.swift
//  chapter-07_taskgroup
//
//  Created by 丰源天下传媒 on 2023/2/26.
//

import Foundation

func listPhotos2(inGallery name: String) async -> [String] {
    let result = ["image1", "image2", "image3"]
    return result
}

func downloadPhoto2(named name: String) async throws -> String { 
    return name
}

func testThrowingTaskGroupInit() {
    print("testThrowingTaskGroupInit start---")
    Task {
        let groupResult = try await withThrowingTaskGroup(of: String.self) { taskGroup -> String in
                let photoNames = await listPhotos2(inGallery: "Summer Vacation")
                for name in photoNames {
                    taskGroup.addTask { try await downloadPhoto2(named: name) }
                }
                /// 获取 taskgroup 结果
                var sum = ""
                for try await result in taskGroup {
                    sum += result
                    sum += "\n"
                }
                return sum
            }
        print(groupResult)
    }
    print("testThrowingTaskGroupInit end---")
}
