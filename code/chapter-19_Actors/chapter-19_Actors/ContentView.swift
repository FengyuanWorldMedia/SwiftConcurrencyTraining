//
//  ContentView.swift
//  chapter-19_Actors
//
//  Created by 丰源天下传媒 on 2023/4/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            NavigationStack {
                NavigationLink("有问题的计时器", destination: CounterTestView())
                NavigationLink("Actor计时器", destination: ActorCounterTestView())
            }.navigationTitle("Actor讲解")
                .navigationBarTitleDisplayMode(.inline)
        }// .background(Color.blue)
        .ignoresSafeArea(.all)
    }
}

 


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
