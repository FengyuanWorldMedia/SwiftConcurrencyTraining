//
//  WolfmenSearchDataModel.swift
//
//
//  Created by 苏州丰源天下传媒 on 2023/5/4.
//

import Foundation
import Vapor

struct NameInfo: Identifiable, Codable, Hashable {
    let id: Int
    var name: String
    var desc: String
}

struct SuggestInfo: Identifiable, Codable, Hashable {
    let id: Int
    var suggest: String
    var desc: String
}

class WolfmenSearchDataModel {
    static func loadNameListFromCsv() -> [NameInfo] {
        var nameInfoList = [NameInfo]()
        let directory = DirectoryConfiguration.detect()
        // /Users/user/Downloads/vapor_work_folder/nameList.csv
        let wokingFolder = directory.workingDirectory
        let csvFilePath = wokingFolder + "/nameList.csv"
        guard let csvFile: FileHandle = FileHandle(forReadingAtPath: csvFilePath) else {
            return nameInfoList
        }
        guard let contentData: Data = try? csvFile.readToEnd()  else {
            return nameInfoList
        }
        let contentStr = String(decoding: contentData, as: UTF8.self)
        let nameLines : [String] = contentStr.components(separatedBy: "\n")
        
        nameInfoList = nameLines.map { line in
            let cols = line.components(separatedBy: ",")
            return NameInfo(id: Int(cols[0])!, name: cols[1], desc: cols[2])
        }
        return nameInfoList
    }
    
}
