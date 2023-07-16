//
//  FileDetails.swift
//  chapter-10_imageloading
//
//  Created by 苏州丰源天下传媒 on 2023/3/10.
//
 
import SwiftUI

struct FileDetails: View {
  let file: DownloadFile
  let isDownloading: Bool

  @Binding var isDownloadActive: Bool
  let oneTimeDownloadAction: () -> Void
  let downloadWithProgressAction: () -> Void
    
  var body: some View {
    Section(content: {
      VStack(alignment: .leading) {
        HStack(spacing: 8) {
          if isDownloadActive {
            ProgressView()
          }
          Text(file.name)
            .font(.title3)
        }
        .padding(.leading, 8)
        Text(sizeFormatter.string(fromByteCount: Int64(file.size)))
          .font(.body)
          .foregroundColor(Color.indigo)
          .padding(.leading, 8)
        if !isDownloading {
          HStack {
            Button(action: oneTimeDownloadAction) {
              Image(systemName: "arrow.down.app")
              Text("一次下载")
            }
            .tint(Color.brown)
            Button(action: downloadWithProgressAction) {
              Image(systemName: "arrow.down.app.fill")
              Text("分段下载")
            }
            .tint(Color.green)
          }
          .buttonStyle(.bordered)
          .font(.subheadline)
        }
      }
    }, header: {
      Label("酷炫的脸谱下载", systemImage: "arrow.down.app")
        .font(.custom("SerreriaSobria", size: 27))
        .foregroundColor(Color.cyan)
        .padding(.bottom, 20)
    })
  }
}
