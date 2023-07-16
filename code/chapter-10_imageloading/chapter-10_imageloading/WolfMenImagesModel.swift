//
//  SuperStorageModel.swift
//  chapter-10_imageloading
//
//  Created by 苏州丰源天下传媒 on 2023/3/10.
//

import Foundation

struct DownloadFile: Codable, Identifiable, Equatable {
  var id: String { return name }
  let name: String
  let size: Int
  let date: Date
  static let empty = DownloadFile(name: "", size: 0, date: Date())
}

struct DownloadInfo: Identifiable, Equatable {
  let id: UUID
  let name: String
  var progress: Double
}

enum ImageUrlEnum {
    case ImageList
    case ImagesStatus
    case DownLoad(String)
    case oneTimeDownload(String)
    case PartialDownLoad(String)
    var url: String {
        switch self {
            case .ImageList:
                return "http://localhost:8080/images/list"
            case .ImagesStatus:
                return "http://localhost:8080/images/status"
            case .DownLoad(let fileName):
                return "http://localhost:8080/images/download?\(fileName)"
            case .oneTimeDownload(let fileName):
                return "http://localhost:8080/images/oneTimeDownload?\(fileName)"
            case .PartialDownLoad(let fileName):
                return "http://localhost:8080/images/partialdownload?\(fileName)"
        }
    }
}

class WolfMenImagesModel: ObservableObject {
  /// 下载列表
  @Published var downloads: [DownloadInfo] = []
  /// 是否支持分段连续下载
  @TaskLocal static var supportsProgressDownloads = false
  
  func oneTimeDownload(file: DownloadFile) async throws -> Data {
    guard let url = URL(string: ImageUrlEnum.oneTimeDownload(file.name).url) else {
        throw "错误的 URL."
    }
    await addDownload(name: file.name)
    let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
    await updateDownload(name: file.name, progress: 1.0)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        throw "服务端错误."
    }
    return data
  }
  
  public func downloadWithProgress(file: DownloadFile) async throws -> Data {
     let fileName = file.name
     guard let url = URL(string: ImageUrlEnum.DownLoad(fileName).url) else {
        throw "错误的 URL."
     }
     if !Self.supportsProgressDownloads {
       throw CancellationError()
     }
     await addDownload(name: fileName)
     let result: (downloadStream: URLSession.AsyncBytes, response: URLResponse)
     result = try await URLSession.shared.bytes(from: url, delegate: nil)
     guard let errCd = (result.response as? HTTPURLResponse)?.statusCode, errCd == 200 else {
        throw "服务端错误."
     }
     var asyncDownloadIterator = result.downloadStream.makeAsyncIterator()
     var accumulator = LoadAccumulator(name: fileName, size: file.size)
     while await !stopDownloads, !accumulator.checkCompleted() {
       // 一次累加一个字节。
       while !accumulator.isBatchCompleted, let byte = try await asyncDownloadIterator.next() {
         accumulator.append(byte)
       }
       let progress = accumulator.progress
      // 更新画面
      Task.detached(priority: .medium) {
        await self.updateDownload(name: fileName, progress: progress)
      }
      print(accumulator.description)
    }
    return accumulator.data
  }
    
  // TODO: partialDownloadWithProgress 需要多次被调用，之后合并下载结果。然后显示。
  private func partialDownloadWithProgress(fileName: String, name: String, size: Int, offset: Int) async throws -> Data {
      guard let url = URL(string: ImageUrlEnum.PartialDownLoad(fileName).url) else {
          throw "错误的 URL."
      }
      if !Self.supportsProgressDownloads {
         throw CancellationError()
      }
      await addDownload(name: name)
      let result: (downloadStream: URLSession.AsyncBytes, response: URLResponse)
      let urlRequest = URLRequest(url: url, offset: offset, length: size)
      result = try await URLSession.shared.bytes(for: urlRequest, delegate: nil)
      guard let errCd = (result.response as? HTTPURLResponse)?.statusCode, errCd == 206 else {
        throw "服务端错误."
      }
      var asyncDownloadIterator = result.downloadStream.makeAsyncIterator()
      var accumulator = LoadAccumulator(name: name, size: size)
      while await !stopDownloads, !accumulator.checkCompleted() {
        while !accumulator.isBatchCompleted, let byte = try await asyncDownloadIterator.next() {
          accumulator.append(byte)
        }
        let progress = accumulator.progress
        Task.detached(priority: .medium) {
           await self.updateDownload(name: name, progress: progress)
        }
      }
      return accumulator.data
  }
  /// 停止下载
  @MainActor var stopDownloads = false

  @MainActor func reset() {
    stopDownloads = false
    downloads.removeAll()
  }

  func availableFiles() async throws -> [DownloadFile] {
    guard let url = URL(string: ImageUrlEnum.ImageList.url) else {
      throw "错误的 URL."
    }
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let errCd = (response as? HTTPURLResponse)?.statusCode, errCd == 200 else {
        throw "服务端错误."
    }
    guard let list = try? JSONDecoder().decode([DownloadFile].self, from: data) else {
        throw "服务端传回错误 文件列表格式."
    }
    return list
  }

  func status() async throws -> String {
    guard let url = URL(string: ImageUrlEnum.ImagesStatus.url) else {
        throw "错误的 URL."
    }
    let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
    guard let errCd = (response as? HTTPURLResponse)?.statusCode, errCd == 200 else {
       throw "服务端错误."
    }
    return String(decoding: data, as: UTF8.self)
  }
}

extension WolfMenImagesModel {
  /// 添加下载项目
  @MainActor func addDownload(name: String) {
    let downloadInfo = DownloadInfo(id: UUID(), name: name, progress: 0.0)
    downloads.append(downloadInfo)
  }
  /// 更新下载进度
  @MainActor func updateDownload(name: String, progress: Double) {
    if let index = downloads.firstIndex(where: { $0.name == name }) {
      var info = downloads[index]
      info.progress = progress
      downloads[index] = info
    }
  }
}
