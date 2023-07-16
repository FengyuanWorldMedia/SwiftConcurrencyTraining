//
//  WolfmenImages.swift
//
//
//  Created by 苏州丰源天下传媒 on 2023/03/11.
//

import Foundation
import Vapor

extension String: LocalizedError {
  public var errorDescription: String? {
    return self
  }
}

struct DownloadFile: Codable, CustomStringConvertible {
  init(name: String, size: Int, create: Date) {
    self.name = name
    self.size = size
    self.date = create
  }
  let name: String
  let size: Int
  let date: Date
  var description: String {
      return "FileName:\(name), size:\(size), created at :\(date)"
  }
}

struct WolfmenImages {
    
  static var images = [DownloadFile]()
  
  static func loopAllImagesInWorkingFolder() {
      let directory = DirectoryConfiguration.detect()
      // /Users/user/Downloads/vapor_work_folder
      let wokingFolder = directory.workingDirectory
      let enumerator = FileManager.default.enumerator(atPath: wokingFolder)
      while let element = enumerator?.nextObject() as? String {
          if element.contains(".DS_Store") {
              continue
          }
          if let fType = enumerator?.fileAttributes?[FileAttributeKey.type] as? FileAttributeType,
             let create = enumerator?.fileAttributes?[FileAttributeKey.creationDate] as? Date {
              switch fType {
                  case .typeRegular:
                      registImageWithUrl(wokingFolder, element, create)
                  case .typeDirectory:
                      print("Do nothing")
                  default :
                      print("Do nothing")
              }
          }
      }
  }

  static func registImageWithUrl(_ folderPath: String, _ fileName: String, _ createDate: Date) {
      if !fileName.contains(".png") && !fileName.contains(".jpg") {
          print("这不是一个图片，\(folderPath)\(fileName)")
          return
      }
      do {
          let data = try Data(contentsOf: URL(fileURLWithPath: folderPath)
                        .appendingPathComponent(fileName, isDirectory: false))
          let fileUrl = generateImageURL(fileName)
          print(fileUrl)
          try data.write(to: fileUrl)
          let fileInfo = DownloadFile(name: fileName, size: getImageFileSize(fileUrl: fileUrl), create: createDate)
          print("文件信息:\(fileInfo)")
          images.append(fileInfo)
      } catch {
          print(error)
      }
  }
  
  static func generateImageURL(_ fileName: String) -> URL {
    return URL(fileURLWithPath: NSTemporaryDirectory().appending("wolfman-image.\(fileName)"))
  }
  
  static func getImageFileSize(fileUrl: URL) -> Int {
     guard let attributes = try? FileManager.default.attributesOfItem(atPath: fileUrl.path),
            let size = attributes[FileAttributeKey.size] as? Int else { return 0 }
      return size
  }
    
  static func routes(_ app: Application) throws {
    
    loopAllImagesInWorkingFolder()
    
    app.get("images", "list") { req -> Response in
      let responseData = try! JSONEncoder().encode(images)
      return Response(body: .init(data: responseData))
    }
    
    app.get("images", "status") { req -> Response in
      return Response(body: .init(string: "磁盘状态良好，请放心使用。"))
    }
    
    app.get("images", "download") { req -> Response in
      // 检查文件名
      guard let name = try? req.query.decode(String.self),
            let file = images.first(where: { $0.name == name }),
            let data = try? Data(contentsOf: generateImageURL(file.name)) else {
         let responseData = try! JSONSerialization.data(withJSONObject: ["error": "File not found."], options: .prettyPrinted)
         return Response(body: .init(data: responseData))
      }
      // 支持持续下载，每1秒 发送一次，直到结束
      let chunk = 1000
      var currentOffset = 0
      let response = Response(body: .init(stream: { writer in
      req.eventLoop.scheduleRepeatedTask(initialDelay: .zero, delay: .seconds(1)) { task in
          let endIndex = min(currentOffset + chunk, data.count)
          writer.write(.buffer(.init(data: data[currentOffset..<endIndex])), promise: nil)
          if endIndex == data.count {
            writer.write(.end, promise: nil)
            task.cancel(promise: nil)
          }
          currentOffset += chunk
        }
      }))
      response.headers.add(name: .contentDisposition, value: "filename=\"\(file.name)\"")
      response.headers.add(name: .contentType, value: "application/octet-stream")
      return response
   } /// download end

   app.get("images", "oneTimeDownload") { req -> Response in
      // 检查文件名
      guard let name = try? req.query.decode(String.self),
            let file = images.first(where: { $0.name == name }) else {
          let responseData = try! JSONSerialization.data(withJSONObject: ["error": "File not found."], options: .prettyPrinted)
          return Response(body: .init(data: responseData))
      }
      let fileUrl = generateImageURL(file.name)
      let data = try! Data(contentsOf: fileUrl)
      let response = Response(body: .init(data: data))
      response.status = .ok
      response.headers.add(name: .contentDisposition, value: "filename=\"\(file.name)\"")
     return response
   } /// oneTimeDownload end
   
   app.get("images", "partialdownload") { req -> Response in
       // 检查文件名
       guard let name = try? req.query.decode(String.self),
             let file = images.first(where: { $0.name == name }) else {
           let responseData = try! JSONSerialization.data(withJSONObject: ["error": "File not found."], options: .prettyPrinted)
           return Response(body: .init(data: responseData))
       }
       
       let fileUrl = generateImageURL(file.name)
       let data = try! Data(contentsOf: fileUrl)
       // https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Range
       // 支持部分下载
       if req.headers.range?.unit == .bytes,
          let firstRange = req.headers.range?.ranges.first,
          case HTTPHeaders.Range.Value.within(let start, let end) = firstRange {
              let dataChunk = data[start...end]
              let response = Response(body: .init(data: dataChunk))
              response.status = .partialContent
              response.headers.add(name: .contentLength, value: "\(end - start + 1)")
              response.headers.add(name: .contentRange, value: "bytes \(start)-\(end)/\(getImageFileSize(fileUrl:fileUrl))")
              response.headers.add(name: .contentDisposition, value: "filename=\"\(file.name)\"")
              return response
       } else {
           let responseData = try! JSONSerialization.data(withJSONObject: ["error": "Header range not set."], options: .prettyPrinted)
           return Response(body: .init(data: responseData))
      }
    } /// partialdownload end
  }
}
