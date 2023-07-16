//
//  Nonisolated.swift
//  chapter-21_ActorReentrancy
//
//  Created by 丰源天下传媒 on 2023/4/23.
//

import Foundation

actor WolfMan: Codable {
    enum CodingKeys: CodingKey {
        case name, rankingNo
    }
    let name: String
    let rankingNo: String
    
    nonisolated var myName: String {
        return self.name
    }
    
    // 需要隔离
    var isFighting = false
    
    init(name: String, rankingNo: String) {
        self.name = name
        self.rankingNo = rankingNo
    }

    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(rankingNo, forKey: .rankingNo)
    }
}



