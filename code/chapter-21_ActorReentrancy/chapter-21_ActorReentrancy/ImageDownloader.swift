//
//  ImageDownloader.swift
//  chapter-21_ActorReentrancy
//
//  Created by 丰源天下传媒 on 2023/4/23.
//

import Foundation
import SwiftUI

actor ImageDownloader {
    
    // URL : Sendable
    // UIImage : Sendable
    var cache: [URL: UIImage] = [:]
    
    func getImage(_ url: URL) async -> UIImage? {
        if let cachedImage = cache[url] {
            return cachedImage
        }
        let data = try? await download(url:url)
        if let data = data {
            let image = UIImage(data: data)
            cache.updateValue(image!, forKey: url)
            return image!
        } else {
            return nil
        }
    }
    
    func download(url: URL) async throws -> Data? {
        let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("服务端错误.")
            return nil
        }
        return data
    }
}
//
// let downloader = ImageDownloader()
// Task.detached { let image1 = await downloader.getImage(url1) }
// Task.detached { let image2 = await downloader.getImage(url2) }
