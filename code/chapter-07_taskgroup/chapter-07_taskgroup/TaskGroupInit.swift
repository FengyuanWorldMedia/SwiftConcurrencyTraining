//
//  TaskGroupInit.swift
//  chapter-07_taskgroup
//
//  Created by 丰源天下传媒 on 2023/2/26.
//

import Foundation

func listPhotos(inGallery name: String) async -> [String] {
    let result = ["image1", "image2", "image3"]
    return result
}

func downloadPhoto(named name: String) async -> String { 
    return name
}

func testTaskGroupInit() {
    print("testTaskGroupInit start---")
    Task {
        let groupResult = await withTaskGroup(of: String.self) { taskGroup -> String in
                let photoNames = await listPhotos(inGallery: "Summer Vacation")
                for name in photoNames {
                    taskGroup.addTask { await downloadPhoto(named: name) }
                }
                /// 获取 taskgroup 结果
                var sum = ""
                for await result in taskGroup {
                    sum += result
                    sum += "\n"
                }
                return sum
            }
        print(groupResult)
    }
    print("testTaskGroupInit end---")
}
