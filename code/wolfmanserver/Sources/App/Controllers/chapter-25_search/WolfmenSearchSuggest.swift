//
//  WolfmenSearchSuggest.swift
//
//
//  Created by 苏州丰源天下传媒 on 2023/5/4.
//

import Foundation
import Vapor

struct WolfmenSearchSuggest {
  
  static func routes(_ app: Application) throws {
     
    app.get("search", "suggest") { req -> Response in
        guard let keyword = try? req.query.get(String.self, at: "keyword") else {
           let status = HTTPResponseStatus.custom(code: 400, reasonPhrase: "Bad Request")
           let responseData = try! JSONSerialization.data(withJSONObject: ["error": "Param:keyword not found."], options: .prettyPrinted)
           return Response(status: status, body: .init(data: responseData))
        }
        // 如果名字（例如：Aarav Barnes）中，Soundex代码有一个是一致的，则可以作为输入候补。
        let searchTask = Task { () -> [SuggestInfo] in
            let groupResult = try? await withThrowingTaskGroup(of: NameInfo?.self, returning: [SuggestInfo].self) { taskGroup -> [SuggestInfo] in
                                        for nameInfo in WolfmenSearchAll.nameInfoList {
                                            taskGroup.addTask {
                                               await compareBySoundex(nameInfo: nameInfo, searchKey: keyword)
                                            }
                                        }
                                        // await taskGroup.waitForAll()
                                        var result: [SuggestInfo] = []
                                        for try await value in taskGroup {
                                            if let suggetNameInfo = value {
                                                result.append(SuggestInfo(id: suggetNameInfo.id ,
                                                                        suggest: suggetNameInfo.name,
                                                                        desc: suggetNameInfo.desc))
                                            }
                                        }
                                       return result
                                }
            return groupResult ?? []
       }
       // 获取结果
       var suggestList: [SuggestInfo] = []
       do {
           suggestList = try await searchTask.result.get()
       } catch (let e) {
           print(e.localizedDescription)
       }
        let responseData = try! JSONEncoder().encode(suggestList)
        return Response(body: .init(data: responseData))
    }
  }
    
  private static func compareBySoundex(nameInfo: NameInfo, searchKey: String) async -> NameInfo? {
    let name = nameInfo.name
    let subNames = name.components(separatedBy: " ")
    let firstName = subNames[0].trim()
    let secondName = subNames[1].trim()
    let soundexSimilarFlag = Soundex.isSoundexSimilar(strA: firstName, strB: searchKey) ||
                                Soundex.isSoundexSimilar(strA: secondName, strB: searchKey)
    return soundexSimilarFlag ? nameInfo : nil
  }
    
}
