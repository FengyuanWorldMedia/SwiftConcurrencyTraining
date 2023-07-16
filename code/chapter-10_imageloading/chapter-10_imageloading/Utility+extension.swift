//
//  Utility.swift
//  chapter-10_imageloading
//
//  Created by 苏州丰源天下传媒 on 2023/3/10.
//

import Foundation

let sizeFormatter: ByteCountFormatter = {
  let formatter = ByteCountFormatter()
   formatter.allowedUnits = [.useKB]
   formatter.isAdaptive = true
   return formatter
}()

let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .short
  formatter.timeStyle = .short
  return formatter
}()

extension String: LocalizedError {
  public var errorDescription: String? {
    return self
  }
}

extension URLRequest {
  init(url: URL, offset: Int, length: Int) {
    self.init(url: url)
    addValue("bytes=\(offset)-\(offset + length - 1)", forHTTPHeaderField: "Range")
  }
}
