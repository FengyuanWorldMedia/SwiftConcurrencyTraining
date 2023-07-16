//
//  ContentView.swift
//  chapter-20_Sendable
//
//  Created by 丰源天下传媒 on 2023/4/22.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        VStack {
            Spacer()
            NavigationStack {
                NavigationLink("SendableTestView1", destination: SendableTestView1())
            }.navigationTitle("Sendable讲解")
                .navigationBarTitleDisplayMode(.inline)
            Spacer()
        }
        .border(Color(.blue),width: 2)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .edgesIgnoringSafeArea(.all)
//        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
