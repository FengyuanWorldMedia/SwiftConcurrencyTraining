//
//  EvnActorDataModel.swift
//  chapter-22_ShareActor
//
//  Created by 丰源天下传媒 on 2023/4/29.
//

import Foundation

actor EvnActorDataModel: ObservableObject {
    
    @Published var count1 = 0
    @MainActor @Published var count = 0
    
    func test() {
        if count1 % 2 != 0 {
            count1 += 1
        } else {
            count1 += 2
        }
    }
    
    func getCount1() -> Int {
        return count1
    }
    func testMain() async {
        await MainActor.run {
            if count % 2 != 0 {
                count += 1
            } else {
                count += 2
            }
        }
    }
}

@MainActor
class EvnActorDataModel22: ObservableObject {
    
    @Published var count1 = 0
    
    func test(no: String) {
        print("No : \(no) -- start")
        if count1 % 2 != 0 {
            count1 += 1
        } else {
            count1 += 2
        }
        print("No : \(no) -- end")
    }
    
}
