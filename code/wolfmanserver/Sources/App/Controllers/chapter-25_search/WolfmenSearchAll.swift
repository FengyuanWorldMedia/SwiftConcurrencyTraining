//
//  WolfmenSearchAll.swift
//
//
//  Created by 苏州丰源天下传媒 on 2023/5/4.
//

import Foundation
import Vapor

struct WolfmenSearchAll {
 
    static var nameInfoList = [NameInfo]()
    
    static func routes(_ app: Application) throws {
        nameInfoList = WolfmenSearchDataModel.loadNameListFromCsv()
        app.get("search", "names") { req -> Response in
            let responseData = try! JSONEncoder().encode(nameInfoList)
            return Response(body: .init(data: responseData))
        }
    }
}
