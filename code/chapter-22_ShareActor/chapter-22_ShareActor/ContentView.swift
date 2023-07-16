//
//  ContentView.swift
//  chapter-22_ShareActor
//
//  Created by 丰源天下传媒 on 2023/4/23.
//

import SwiftUI

struct ContentView: View {
     
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink("ShareActorView1", destination: ShareActorView1())
                NavigationLink("ShareActorView11", destination: ShareActorView11())
                NavigationLink("ShareActorView2", destination: ShareActorView2().environmentObject(EvnActorDataModel()))
                NavigationLink("ShareActorView22", destination: ShareActorView22().environmentObject(EvnActorDataModel22()))
                Spacer()
            }
        }
        .navigationTitle("ShareActor讲解")
        .navigationBarTitleDisplayMode(.inline)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
