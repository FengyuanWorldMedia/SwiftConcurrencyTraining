//
//  TaskResult.swift
//  chapter-06_task
//
//  Created by 苏州丰源天下传媒 on 2023/2/25.
//

import Foundation

func taskResult() async {
    // Task#init(priority: TaskPriority? = nil, operation: @escaping @Sendable () async throws -> Success)
    let searchTask = Task { ()  -> String in
        let url = URL(string: "https://www.baidu.com/s?wd=fengyuantianxia")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return String(decoding: data, as: UTF8.self)
    }
    // 获取结果
    do {
        let result = try await searchTask.result.get()
        print(result)
    } catch (let e) {
        print(e.localizedDescription)
    }
}

func testTaskResult () {
    Task {
        await taskResult()
    }
}
