//
//  chapter_25_searchApp.swift
//  chapter-25_search
//
//  Created by 丰源天下传媒 on 2023/5/4.
//

import SwiftUI

@main
struct chapter_25_searchApp: App {
    var body: some Scene {
        WindowGroup {
            WolfSearchView()
                    .environmentObject(DataModel())
        }
    }
}
