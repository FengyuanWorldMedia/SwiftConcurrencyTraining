//
//  Downloads.swift
//  chapter-10_imageloading
//
//  Created by 苏州丰源天下传媒 on 2023/3/10.
//

import SwiftUI

struct Downloads: View {
  let downloads: [DownloadInfo]
  var body: some View {
    ForEach(downloads) { download in
      VStack(alignment: .leading) {
        Text(download.name).font(.caption)
        ProgressView(value: download.progress)
      }
    }
  }
}
