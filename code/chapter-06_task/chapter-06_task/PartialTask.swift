//
//  PartialTask.swift
//  chapter-06_task
//
//  Created by 丰源天下传媒 on 2023/2/25.
//

import Foundation
  
func getParam() async -> String {
    return "丰源天下".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
}

func processLine(_ line :String) async {
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    print("丰源天下:\(line)")
}

func receiveNotications() async {
    let param = await getParam()
    let url = URL(string: "https://www.baidu.com/s?wd=\(param)")!
    do {
        for try await line in url.lines { 
          await processLine(line)
        }
    } catch(let e) {
        print(e.localizedDescription)
    }
}

 

