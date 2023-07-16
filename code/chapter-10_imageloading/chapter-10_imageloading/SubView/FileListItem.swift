//
//  FileListItem.swift
//  chapter-10_imageloading
//
//  Created by 苏州丰源天下传媒 on 2023/3/10.
//

import Foundation
import SwiftUI

struct FileListItem: View {
  let file: DownloadFile
  var body: some View {
    VStack(spacing: 8) {
      HStack {
          Text(file.name.components(separatedBy:".")[0])
              .foregroundColor(Color.cyan)
        Spacer()
        Image(systemName: "chevron.right")
      }
      HStack {
        Image(systemName: "photo")
        Text(file.name.components(separatedBy:".")[1])
        Text(" ")
        Text(sizeFormatter.string(fromByteCount: Int64(file.size)))
        Text(" ")
        Text(dateFormatter.string(from: file.date))
        Spacer()
      }
      .padding(.leading, 10)
      .padding(.bottom, 10)
      .font(.caption)
      .foregroundColor(Color.gray)
    }
  }
}
