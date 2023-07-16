//
//  FilePreview.swift
//  chapter-10_imageloading
//
//  Created by 苏州丰源天下传媒 on 2023/3/10.
//
 
import SwiftUI

struct FilePreview: View {
  let fileData: Data
  var body: some View {
    Section("图片预览") {
      VStack(alignment: .center) {
        if let image = UIImage(data: fileData) {
          Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxHeight: 600)
            .cornerRadius(10)
        } else {
          Text("--没有数据--")
        }
      }
    }
  }
}
