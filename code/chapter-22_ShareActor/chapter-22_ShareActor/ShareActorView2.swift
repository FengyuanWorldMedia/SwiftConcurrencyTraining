//
//  ShareActorView2.swift
//  chapter-22_ShareActor
//
//  Created by 丰源天下传媒 on 2023/4/29.
//

import SwiftUI

struct ShareActorView2: View {
    
    @EnvironmentObject var evnActorDataModel: EvnActorDataModel
    
    var body: some View {
        
        VStack {
             Text("Test \( self.evnActorDataModel.count1)")  // Actor-isolated property 'count1' can not be referenced from the main actor
            Text("Test ").task {
                Task.detached {
                    await evnActorDataModel.test()
                }
                Task.detached {
                    await evnActorDataModel.test()
                }
            }
            
            Text("Hello, World!Test \( self.evnActorDataModel.count)").task {
                await evnActorDataModel.testMain()
            }
        }
        
    }
}

struct ShareActorView2_Previews: PreviewProvider {
    static var previews: some View {
        ShareActorView2()
    }
}
