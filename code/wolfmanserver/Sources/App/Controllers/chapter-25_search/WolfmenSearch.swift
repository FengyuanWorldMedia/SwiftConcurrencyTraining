//
//  WolfmenSearch.swift
//  
//
//  Created by 苏州丰源天下传媒 on 2023/5/4.
//

import Foundation
import Vapor

struct WolfmenSearch {
  
  static func routes(_ app: Application) throws {
    
    app.get("search", "searchname") { req -> Response in
         guard let keyword = try? req.query.get(String.self, at: "keyword"),
                let scope = try? req.query.get(String.self, at: "scope") else {
             let status = HTTPResponseStatus.custom(code: 400, reasonPhrase: "Bad Request")
             let responseData = try! JSONSerialization.data(withJSONObject: ["error": "Param: keyword or scope not found."], options: .prettyPrinted)
             return Response(status: status, body: .init(data: responseData))
         }
        
        print("keyword:\(keyword), scope:\(scope)")
        
         var searchByIdFlag = false
         switch scope {
            case "ById":
                searchByIdFlag = true
                print("ById")
            case "ByName":
                print("ByName")
            default:
              if keyword.isNumber {
                  searchByIdFlag = true
                  print("All -- ById")
              } else {
                  print("All -- ByName")
              }
         }
         var result: [NameInfo] = []
         if searchByIdFlag {
            result = searchById(keyword: keyword)
         } else {
            result = await searchByName(keyword: keyword)
         }
        let responseData = try! JSONEncoder().encode(result.uniqued())
         return Response(body: .init(data: responseData))
    }
  }

   private static func searchById(keyword: String) -> [NameInfo] {
      let allNames = WolfmenSearchAll.nameInfoList
      return allNames.filter { nameInfo in
          return String(nameInfo.id).contains(keyword)
      }
   }
   
   private static func searchByName(keyword: String) async -> [NameInfo] {
      let allNames = WolfmenSearchAll.nameInfoList
      // 如果名字（例如：Aarav Barnes）中，Soundex代码有一个是一致的，则可以作为输入候补。
      let searchTask = Task { () -> [NameInfo] in
          let groupResult = try? await withThrowingTaskGroup(of: NameInfo?.self, returning: [NameInfo].self) { taskGroup -> [NameInfo] in
                                      for nameInfo in allNames {
                                          let subKeywords = keyword.components(separatedBy: " ")
                                          for subKey in subKeywords {
                                              taskGroup.addTask {
                                                 await compareByLevenshteinDistance(nameInfo: nameInfo, searchKey: subKey)
                                              }
                                          }
                                      }
                                      // await taskGroup.waitForAll()
                                      var result: [NameInfo] = []
                                      for try await value in taskGroup {
                                          if let searchNameInfo = value {
                                              result.append(NameInfo(id: searchNameInfo.id ,
                                                                      name: searchNameInfo.name,
                                                                      desc: searchNameInfo.desc))
                                          }
                                      }
                                     return result
                              }
          return groupResult ?? []
     }
      var result: [NameInfo] = []
      do {
          result = try await searchTask.result.get()
      } catch (let e) {
          print(e.localizedDescription)
      }
      return result
  }
    
  private static func compareByLevenshteinDistance(nameInfo: NameInfo, searchKey: String) async -> NameInfo? {
        let name = nameInfo.name
        let subNames = name.components(separatedBy: " ")
        let firstName = subNames[0]
        let secondName = subNames[1]
      
        var editDistance = levenshteinDistance(strA: firstName, strB: searchKey)
        var similarity = 1 - Double(editDistance) / Double(firstName.count)
        if similarity >= 0.8 {
            print("id:\(nameInfo.id), FirstName: \(firstName), searchKey: \(searchKey), 编辑距离: \(editDistance), similarity: \(similarity)")
            return nameInfo
        }
        editDistance = levenshteinDistance(strA: secondName, strB: searchKey)
        similarity = 1 - Double(editDistance) / Double(secondName.count)
        if similarity >= 0.8 {
            print("id:\(nameInfo.id), SecondName: \(secondName), searchKey: \(searchKey), 编辑距离: \(editDistance), similarity: \(similarity)")
            return nameInfo
        }
        return nil
  }
}
