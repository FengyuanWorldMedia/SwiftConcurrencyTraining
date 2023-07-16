//
//  ContentView.swift
//  chapter-09_TaskLocal
//
//  Created by 丰源天下传媒 on 2023/3/5.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    TaskLocalView1()
                } label: {
                    Label("TaskLocalView1", systemImage: "\(1).circle")
                }
                NavigationLink {
                    TaskLocalView2(model: DataModel())
                } label: {
                    Label("TaskLocalView2", systemImage: "\(2).circle")
                }
                Spacer()
            }
           .navigationTitle("TaskLocal")
       }
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
