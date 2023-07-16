//
//  ByteAccumulator.swift
//  chapter-10_imageloading
//
//  Created by 苏州丰源天下传媒 on 2023/3/10.
//

import Foundation

struct LoadAccumulator: CustomStringConvertible {
  private var offset = 0
  private var counter = -1
  private let name: String
  private let size: Int
  private let chunkCount: Int
  private var bytes: [UInt8]
  var data: Data { return Data(bytes[0..<offset]) }

  /// 创建字节累加器
  init(name: String, size: Int) {
    self.name = name
    self.size = size
    chunkCount = max(Int(Double(size) / 20), 1)
    bytes = [UInt8](repeating: 0, count: size)
  }

  /// 添加一个字节
  mutating func append(_ byte: UInt8) {
    bytes[offset] = byte
    counter += 1
    offset += 1
  }

  /// 本次有没有下载完
  var isBatchCompleted: Bool {
    return counter >= chunkCount
  }

  mutating func checkCompleted() -> Bool {
    defer { counter = 0 }
    return counter == 0
  }

  /// 下载进度.
  var progress: Double {
    Double(offset) / Double(size)
  }

  var description: String {
    "[\(name)] \(sizeFormatter.string(fromByteCount: Int64(offset)))"
  }
}
