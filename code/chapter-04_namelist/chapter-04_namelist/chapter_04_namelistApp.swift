//
//  chapter_04_namelistApp.swift
//  chapter-04_namelist
//
//  Created by 苏州丰源天下传媒 on 2022/11/13.
//

import SwiftUI

@main
struct chapter_04_namelistApp: App {
    var body: some Scene {
        WindowGroup {
            WolfmanNameListView(model: WolfManModel())
        }
    }
}
