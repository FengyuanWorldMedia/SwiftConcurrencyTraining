///*----------------------------------------------------------------
///  Copyright (c) 2023  Suzhou Fengyuan World Media Co.,Ltd
///
/// 文件名：main.swift
/// 文件功能描述：Swift Web Service for Concurrency Programming.
/// author：苏州丰源天下传媒
///----------------------------------------------------------------*/

import App
import Vapor

print("""
  /n
  ####-----------------------------------------------
        开心学编程
       《Swift并发编程Async-TaskGroup&Actors》
        Swift Web Service 配套示例
  -----------------------------------------------####
                                http://127.0.0.1:8080/
  /n
""")

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)



for e in app.routes.all {
    print(e.method)
    var path = ""
    for i in e.path {
        path = "\(path)/\(i)"
    }
    print("   http://127.0.0.1:8080\(path)")
}

print(app.directory.resourcesDirectory)
print(app.directory.publicDirectory)

//print(app.routes.all) // [Route]

try app.run()
