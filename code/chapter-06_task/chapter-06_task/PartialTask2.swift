//
//  PartialTask.swift
//  chapter-06_task
//
//  Created by 丰源天下传媒 on 2023/2/25.
//

import Foundation
  
 
func printLine(_ line :String) async {
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    print("fengyuantianxia:\(line)")
}

func searchCompanyInfo() async {
    let url = URL(string: "https://www.baidu.com/s?wd=fengyuantianxia")!
    do {
        for try await line in url.lines {
            await printLine(line)
        }
    } catch(let e) {
        print(e.localizedDescription)
    } 
}
 
