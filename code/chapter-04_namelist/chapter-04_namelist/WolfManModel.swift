//
//  LittleJohnModel.swift
//  chapter-04_namelist
//
//  Created by 苏州丰源天下传媒 on 2023/02/26.
//

import Foundation

extension String: Error { }

class WolfManModel: ObservableObject {
  
  @Published private(set) var magicPoints: [MagicPoint] = []
  
  func magicPoints(_ seletedNames: [String]) async throws {
    /// 注意这里的 DispatchQueue.main.sync 使用。
    DispatchQueue.main.sync {
        magicPoints = []
    }
    
    let names = seletedNames.joined(separator: ",")
      
    guard let url = URL(string: "http://127.0.0.1:8080/wolfman/magicpoints?\(names)") else {
      throw "错误的URL"
    }

    print(url.absoluteString)
    
    let (stream, response) = try await liveURLSession.bytes(from: url)

    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      throw "服务端错误"
    }

    /// try wait 使用
    for try await line in stream.lines {
        let str = String(decoding: Data(line.utf8), as: UTF8.self)
        print(">>>>> \(str)")
        if str.isEmpty {
           break
        }
        let sortedMagicPoints = try JSONDecoder()
                    .decode([MagicPoint].self, from: Data(line.utf8))
                    .sorted(by: { $0.name < $1.name })
        
        // MainActor.run 的用法
        await MainActor.run {
            magicPoints = sortedMagicPoints
        }
    }
  }

  func nameList() async throws -> [String] {
     guard let url = URL(string: "http://127.0.0.1:8080/wolfman/names") else {
       throw "错误的URL"
     }

     let (data, response) = try await URLSession.shared.data(from: url)

     guard (response as? HTTPURLResponse)?.statusCode == 200 else {
       throw "服务端错误"
     }

     return try JSONDecoder().decode([String].self, from: data)
  }
    
  
 func stopTask() async throws -> String {
   guard let url = URL(string: "http://127.0.0.1:8080/wolfman/stoptask") else {
      throw "错误的URL"
   }
   let (data, response) = try await URLSession.shared.data(from: url)
   guard (response as? HTTPURLResponse)?.statusCode == 200 else {
     throw "服务端错误"
   }
   return try JSONDecoder().decode(String.self, from: data)
 }

  /// 重点: 允许请求无限期运行的URL会话，以便我们可以从服务器接收实时更新。
  private lazy var liveURLSession: URLSession = {
     var configuration = URLSessionConfiguration.default
     configuration.timeoutIntervalForRequest = .infinity
     return URLSession(configuration: configuration)
  }()
}
