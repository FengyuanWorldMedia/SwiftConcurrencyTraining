//
//  DataModel.swift
//  chapter-25_search
//
//  Created by 丰源天下传媒 on 2023/5/4.
//

import Foundation

extension String: Error { }

extension String {
    var urlEncoded: String {
        let allowedCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "~-_."))
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
    }
}


struct NameInfo: Identifiable, Codable {
    let id: Int
    var name: String
    var desc: String
}

struct SuggestInfo: Identifiable, Codable {
    let id: Int
    var suggest: String
    var desc: String
}

enum SearchScope: String, CaseIterable {
    case byId = "ById"
    case byName = "ByName"
    case all = "All"
}
 
@MainActor
class DataModel : ObservableObject {
    
    nonisolated let appName = "狼人故事之容错点名"
    
    @Published var nameList: [NameInfo] = []
    @Published var suggestList: [SuggestInfo] = []
    
    @Published var searchScope: SearchScope = .all
    @Published var searchTermCount: [String:Int] = [:]
    
    // 初期画面的 名称一览
    func nameList() async throws -> [NameInfo] {
        guard let url = URL(string: HttpLinkEnum.NameList.rawValue) else {
         throw "错误的URL"
       }
       let (data, response) = try await URLSession.shared.data(from: url)
       guard (response as? HTTPURLResponse)?.statusCode == 200 else {
         throw "服务端错误"
       }
       return try JSONDecoder().decode([NameInfo].self, from: data)
    }
    
    // 输入候补
    func suggestList(keyword: String) async throws -> [SuggestInfo] {
       let urlStr = "\(HttpLinkEnum.SuggestList.rawValue)?keyword=\(keyword)"
       guard let url = URL(string: urlStr) else {
         throw "错误的URL"
       }
       let (data, response) = try await URLSession.shared.data(from: url)
       guard (response as? HTTPURLResponse)?.statusCode == 200 else {
         throw "服务端错误"
       }
       return try JSONDecoder().decode([SuggestInfo].self, from: data)
    }
    
    // 检索结果
    func searchNameList(keyword: String, searchScope: SearchScope = .all) async throws -> [NameInfo] {
       let urlStr = "\(HttpLinkEnum.SearchNameList.rawValue)?keyword=\(keyword.urlEncoded)&scope=\(searchScope.rawValue)"
       guard let url = URL(string: urlStr) else {
          throw "错误的URL"
       }
       let (data, response) = try await URLSession.shared.data(from: url)
       guard (response as? HTTPURLResponse)?.statusCode == 200 else {
         throw "服务端错误"
       }
       return try JSONDecoder().decode([NameInfo].self, from: data)
    }
}
