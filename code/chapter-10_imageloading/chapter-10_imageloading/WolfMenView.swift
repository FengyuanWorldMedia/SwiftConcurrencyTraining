//
//  WolfMenView.swift
//  chapter-10_imageloading
//
//  Created by 苏州丰源天下传媒 on 2023/3/10.
//

import SwiftUI
 
struct WolfMenView: View {
  let model: WolfMenImagesModel
  @State var files: [DownloadFile] = []
  @State var status = ""
  @State var selected = DownloadFile.empty {
    didSet {
      isDisplayingDownload = true
    }
  }
  @State var isDisplayingDownload = false
  @State var lastErrorMessage = "None" {
    didSet {
      isDisplayingError = true
    }
  }
  @State var isDisplayingError = false

  var body: some View {
    NavigationView {
      VStack {
        NavigationLink(destination: DownloadView(file: selected).environmentObject(model),
                       isActive: $isDisplayingDownload) {
          EmptyView()
        }.hidden()
          
        List {
          Section(content: {
            if files.isEmpty {
              ProgressView().padding()
            }
            ForEach(files) { file in
              Button(action: {
                selected = file
              }, label: {
                FileListItem(file: file)
              })
            }
          }, header: {
            Label("狼人脸谱", systemImage: "lock.icloud")
              .font(.custom("SerreriaSobria", size: 20))
              .foregroundColor(Color.cyan)
              .padding(.bottom, 20)
          }, footer: {
            Text(status)
          })
        }
        .listStyle(InsetGroupedListStyle())
        .animation(.easeOut(duration: 0.33), value: files)
      }
      .alert("错误信息", isPresented: $isDisplayingError, actions: {
        Button("关闭", role: .cancel) { }
      }, message: {
        Text(lastErrorMessage)
      })
      .task {
        guard files.isEmpty else { return }
        do {
          async let files = try model.availableFiles()
          async let status = try model.status()
          let (filesResult, statusResult) = try await (files, status)
          self.files = filesResult
          self.status = statusResult
        } catch {
          lastErrorMessage = error.localizedDescription
        }
      }
    }
  }
}
