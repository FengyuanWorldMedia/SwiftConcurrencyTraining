//
//  ShareActorView2.swift
//  chapter-22_ShareActor
//
//  Created by 丰源天下传媒 on 2023/4/29.
//

import SwiftUI

struct ShareActorView22: View {
    
    @EnvironmentObject var evnActorDataModel: EvnActorDataModel22
    
    var body: some View {
        
        VStack {
            Text("Test \( self.evnActorDataModel.count1)").task {
                Task.detached {
                    await evnActorDataModel.test(no: "1")
                }
                Task.detached {
                    await evnActorDataModel.test(no: "2")
                }
                Task.detached {
                    await evnActorDataModel.test(no: "3")
                }
                Task.detached {
                    await evnActorDataModel.test(no: "4")
                }
                Task.detached {
                    await evnActorDataModel.test(no: "5")
                }
                Task.detached {
                    await evnActorDataModel.test(no: "6")
                }
            }
        }
        
    }
}

struct ShareActorView22_Previews: PreviewProvider {
    static var previews: some View {
        ShareActorView22()
    }
}
