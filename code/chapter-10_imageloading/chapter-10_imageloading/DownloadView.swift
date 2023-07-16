//
//  DownloadView.swift
//  chapter-10_imageloading
//
//  Created by 苏州丰源天下传媒 on 2023/3/10.
//

import SwiftUI
import Combine
 
struct DownloadView: View {
    
  let file: DownloadFile
  @EnvironmentObject var model: WolfMenImagesModel
  @State var fileData: Data?
  // 下载进度条
  @State var isDownloadActive = false
  @State var duration = ""
  @State var downloadTask: Task<Void, Error>? {
    didSet {
      timerTask?.cancel()
      guard isDownloadActive else { return }
      let startTime = Date().timeIntervalSince1970
      let timerSequence = Timer
        .publish(every: 1, tolerance: 1, on: .main, in: .common)
        .autoconnect()
        .map { date -> String in
          let duration = Int(date.timeIntervalSince1970 - startTime)
          return "\(duration)s"
        }
        //AsyncPublisher<String>
        .values
      timerTask = Task {
        for await duration in timerSequence {
            if !isDownloadActive {
                break
            }
          self.duration = duration
        }
      }
    }
  }
  @State var timerTask: Task<Void, Error>?
  @State var lastErrorMessage = "None" {
      didSet {
        isDisplayingError = true
      }
    }
  @State var isDisplayingError = false
    
  var body: some View {
    List {
      FileDetails(
        file: file,
        isDownloading: !model.downloads.isEmpty,
        isDownloadActive: $isDownloadActive,
        oneTimeDownloadAction: {
          isDownloadActive = true
          Task {
            do {
              fileData = try await model.oneTimeDownload(file: file)
              await MainActor.run {
                  model.downloads = []
              }
            } catch { }
            isDownloadActive = false
          }
        },
        downloadWithProgressAction: {
          isDownloadActive = true
          downloadTask = Task {
            do {
              try await WolfMenImagesModel
                .$supportsProgressDownloads
                .withValue(file.name.hasSuffix(".jpg")) {
                fileData = try await model.downloadWithProgress(file: file)
                await MainActor.run {
                    model.downloads = []
                }
              }
            } catch {
                self.lastErrorMessage = "不支持分段下载 或 下载出现异常"
            }
            isDownloadActive = false
          }
        }
      )
      if !model.downloads.isEmpty {
        // 显示进度条
        Downloads(downloads: model.downloads)
      }

      if !duration.isEmpty {
        Text("下载用时: \(duration)")
          .font(.caption)
      }

      if let fileData = fileData {
        // 显示预览
        FilePreview(fileData: fileData)
      }
    }
    .animation(.easeOut(duration: 0.33), value: model.downloads)
    .listStyle(InsetGroupedListStyle())
    .toolbar(content: {
      Button(action: {
        model.stopDownloads = true
        timerTask?.cancel()
      }, label: { Text("取消下载") })
        .disabled(model.downloads.isEmpty)
    })
    .alert("错误信息", isPresented: $isDisplayingError, actions: {
      Button("关闭", role: .cancel) { }
    }, message: {
      Text(lastErrorMessage)
    })
    .onDisappear {
      fileData = nil
      model.reset()
      downloadTask?.cancel()
    }
  }
}
