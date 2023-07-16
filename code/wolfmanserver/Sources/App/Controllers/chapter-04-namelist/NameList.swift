//
//  NameList.swift
//  
//
//  Created by 苏州丰源天下传媒 on 2023/02/26.
//

import Foundation
import Vapor

//fileprivate let names = ["狼人1号", "狼人2号", "狼人3号", "狼人4号", "狼人5号", "狼人6号", "狼人7号", "狼人8号", "狼人9号", "狼人10号", "狼人11号"]
fileprivate let names = ["WolfMan-No.1", "WolfMan-No.2", "WolfMan-No.3", "WolfMan-No.4"]

fileprivate var isRunningTask = false

struct MagicPoint: Codable {
  let name: String
  var value: Double
}

struct NameList {
  static func routes(_ app: Application) throws {

    app.get("wolfman", "names") { req -> Response in
      let responseData = try! JSONEncoder().encode(names)
      return Response(body: .init(data: responseData))
    }

    app.get("wolfman", "magicpoints") { req -> Response in
      
      let params = try? req.query.decode(String.self)
      let names = params?.components(separatedBy: ",").filter(names.contains)

      guard let names = names, !names.isEmpty else {
        let responseData = try! JSONSerialization.data(withJSONObject: ["error": "没有可用的狼人名称."], options: .prettyPrinted)
        return Response(status: .internalServerError, body: .init(data: responseData))
      }
      
      var magicPoints: [MagicPoint] =  names.map { MagicPoint(name: $0, value: Double.random(in: 10...100)) }
      
      let response = Response(body: .init(stream: { writer in
        // 初次写入数据
        let initialResponse = try! JSONEncoder().encode(magicPoints) + "\n".data(using: .utf8)!
        writer.write(.buffer(.init(data: initialResponse)), promise: nil)
        isRunningTask = true
        req.eventLoop.scheduleRepeatedTask(initialDelay: .zero, delay: .seconds(1)) { task in
          magicPoints = magicPoints.map { MagicPoint(name: $0.name, value: max(0, $0.value + Double.random(in: -5...5))) }
          print("往数据流写入:\(Date().description)")
          // dump(magicPoints)
          let updateResponse = try! JSONEncoder().encode(magicPoints) + "\n".data(using: .utf8)!
          writer.write(.buffer(.init(data: updateResponse)), promise: nil)
          // 停掉数据的写入
          if !isRunningTask {
              _ = writer.write(.end)
              print("req.eventLoop.scheduleRepeatedTask stop")
              task.cancel()
              try req.eventLoop.close()
          }
        }
      }))

      response.headers.add(name: .contentType, value: "application/octet-stream")
      return response
    }
    
     
   app.get("wolfman", "stoptask") { req -> Response in
      print("wolfman/stoptask")
      isRunningTask = false
      let responseData = try! JSONEncoder().encode("OK")
      return Response(body: .init(data: responseData))
   }
  }
    
}
