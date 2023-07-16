//
//  TaskGroupResult.swift
//  chapter-07_taskgroup
//
//  Created by 丰源天下传媒 on 2023/2/26.
//

import Foundation

func listPhotos4(inGallery name: String) async -> [String] {
    let result = ["image1", "image2", "image3"] 
    return result
}

func downloadPhoto4(named name: String) async -> String {
    print("下载了图片:\(name)")
    return name
}

func testTaskGroupResult() {
    print("testTaskGroupResult start---")
    Task {
        let groupResult = await withTaskGroup(of: String.self) { taskGroup -> String in
                let photoNames = await listPhotos4(inGallery: "Summer Vacation")
                for name in photoNames {
                    taskGroup.addTask { await downloadPhoto4(named: name) }
                }
                await taskGroup.waitForAll()
                return "已经下载了所有图片"
            }
        print(groupResult)
    }
    print("testTaskGroupResult end---")
}
