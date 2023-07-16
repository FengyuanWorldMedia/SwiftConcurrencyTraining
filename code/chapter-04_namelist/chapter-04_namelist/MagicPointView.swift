//
//  MagicPointView.swift
//  chapter-04_namelist
//
//  Created by 苏州丰源天下传媒 on 2023/02/26.
//


import SwiftUI

struct MagicPoint: Hashable, Codable {
  let name: String
  let value: Double
}

/// 魔法值显示
struct MagicPointView: View {
      let selectedNames: [String]
      @EnvironmentObject var model: WolfManModel
      @Environment(\.presentationMode) var presentationMode
      
      @State var lastErrorMessage = "" {
        didSet { isDisplayingError = true }
      }
      @State var isDisplayingError = false
    
      @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
      @State var imageIndex = 0
      @State var images = ["point.topleft.down.curvedto.point.bottomright.up",
                        "point.topleft.down.curvedto.point.filled.bottomright.up" ,
                        "point.topleft.down.curvedto.point.bottomright.up.fill",
                        "point.filled.topleft.down.curvedto.point.bottomright.up"]

      var body: some View {
        List {
          Section(content: {
            ForEach(model.magicPoints, id: \.name) { magicPoint in
              HStack {
                Text(magicPoint.name)
                Spacer()
                  .frame(maxWidth: .infinity)
                Text(String(format: "%.3f", arguments: [magicPoint.value]))
              }
            }
          }, header: {
              self.magicPointHeader()
          })
        }
        .alert("提醒信息", isPresented: $isDisplayingError, actions: {
          Button("关闭", role: .cancel) { }
        }, message: {
          Text(lastErrorMessage)
        })
        .listStyle(PlainListStyle())
        .font(.system(size:18))
        .padding(.horizontal)
        .task {
          do {
            print(selectedNames)
            try await model.magicPoints(selectedNames)
          } catch {
            if let error = error as? URLError, error.code == .cancelled {
              return
            }
            lastErrorMessage = "服务端停止推送数据"
            // lastErrorMessage = error.localizedDescription
          }
        }.onReceive(timer) { _ in
            imageIndex = (imageIndex + 1) % 4
        }.onDisappear() {
            print("stopTimer")
            self.stopSyncTask()
            self.stopTimer()
        }
    }
    
    func magicPointHeader() -> some View {
        HStack {
            Label("魔法值", systemImage: images[imageIndex])
              .foregroundColor(Color(uiColor: .systemGreen))
              .font(.system(size:30))
              .padding(.bottom, 20)
              .padding(.trailing, 30)
            
             Button(action: {
                 self.stopSyncTask()
                 self.stopTimer()
             }, label: {
                 Text("停止同步")
                     .foregroundColor(Color(uiColor: .systemGreen))
                     .font(.system(size:15))
             })
        }
    
    }
    
    func stopTimer() {
        self.timer.upstream.connect().cancel()
    }
    
    func stopSyncTask() {
        Task {
            do {
                let result = try await model.stopTask()
                print(result)
                stopTimer()
            } catch {
                await MainActor.run {
                    lastErrorMessage = error.localizedDescription
                }
            }
        }
    } 
    
}
