//
//  CancelTaskGroup.swift
//  chapter-07_taskgroup
//
//  Created by 丰源天下传媒 on 2023/2/26.
//

import Foundation

func listPhotos3(inGallery name: String) async -> [String?] {
    let result = [nil, "image2", "image3"] 
    return result
}

func downloadPhoto3(named name: String?) async -> String? {
    return name
}

func testCancelTaskGroup() {
    print("testCancelTaskGroup start---")
    Task {
        let groupResult = await withTaskGroup(of: Optional<String>.self) { taskGroup -> String in
                let photoNames = await listPhotos3(inGallery: "Summer Vacation")
                for name in photoNames {
                    taskGroup.addTask { await downloadPhoto3(named: name) }
                }
                /// 获取 taskgroup 结果
                var sum = ""
                for await result in taskGroup {
                    if let result = result {
                        sum += result
                        sum += "\n"
                    } else {
                        // 图片名列表中含有nil，taskgroup取消；即使取消了，之前的结果也会正常返回。
                        print("cancelAll")
                        taskGroup.cancelAll()
                    }
                }
                return sum
            }
        print(groupResult)
    }
    print("testCancelTaskGroup end---")
}
