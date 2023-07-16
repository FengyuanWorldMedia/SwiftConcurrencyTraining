//
//  TaskLocalView2.swift
//  chapter-09_TaskLocal
//
//  Created by 丰源天下传媒 on 2023/3/5.
//

import SwiftUI

struct TaskLocalView2: View {
    
    @ObservedObject var model: DataModel
    
    var body: some View {
        List {
            Section(
                content: {
                    ForEach(model.renameList, id: \.self) { name in
                        Text(name)
                    }
                    .fontWeight(.medium)
                },
                header: self.headerView
            )
        }
        .listStyle(PlainListStyle())
        .statusBar(hidden: true)
        .padding(.horizontal)
        .task {
            await model.updateName()
        }
    }
    
    func headerView() -> some View {
       Label("狼人花名册", systemImage: "book.circle")
            .foregroundColor(Color(uiColor: .brown))
            .font(.title)
            .padding(.bottom, 20)
    }
    
}

struct TaskLocalView2_Previews: PreviewProvider {
    static var previews: some View {
        TaskLocalView2(model: DataModel())
    }
}
