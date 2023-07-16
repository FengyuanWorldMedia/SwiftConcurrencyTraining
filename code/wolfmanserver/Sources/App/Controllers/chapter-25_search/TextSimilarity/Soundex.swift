//
//  Soundex.swift
//  
//
//  Created by 苏州丰源天下传媒 on 2023/5/4.
//
  
import Foundation

// Soundex代码计算
// 调用示例：Soundex.soundex(s: "handsome") // H532
class Soundex {
    private static func getCodeByChar(c: Character) -> String {
        switch(c) {
        case "B", "F","P", "V" : return "1"
        case "C","G","J","K","Q","S","X","Z" : return "2"
        case "D", "T" : return "3"
        case "L" : return "4"
        case "M", "N" : return "5"
        case "R" : return "6"
        default:
            return "" // 忽略元音
        }
    }
    static func soundex(s: String) -> String{
        var code: String
        var previous: String
        var soundex: String
        // 第一个字母
        code = "\(String(describing: s.localizedUppercase.character(at: 0)!))"
        previous = "7"
        let aArray = Array(s.localizedUppercase)
        for i in 1..<aArray.count {
            let current = getCodeByChar(c: aArray[i])
            if current.count > 0 && current != previous {
                code = "\(code)\(current)";
            }
            previous = current
        }
        soundex = String("\(code)0000".prefix(4))
        return soundex
    }
    
    static func isSoundexSimilar(strA: String , strB: String) -> Bool {
        soundex(s: strA) == soundex(s: strB)
    }
}
