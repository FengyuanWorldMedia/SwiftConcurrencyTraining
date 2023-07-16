//
//  Async_test.swift
//  chapter-05_async
//
//  Created by 苏州丰源天下传媒 on 2023/2/25.
//

import Foundation

///   async 关键字 解决 传统回调的写法问题
///
func listPhotos(inGallery name: String) async -> [String] {
    let result = ["image1", "image2", "image3"]
    return result
}

func downloadPhoto(named name: String) async -> String {
    // let result = ["image1", "image2"]// ... some asynchronous networking code ...
    return name
}

// -------------------------------------------------------------------
func show(_ photo: String) {
    print("show pic name:\(photo)")
}

func doTest() {
    print("Do test start")
    Task {
        let photoNames = await listPhotos(inGallery: "Summer Vacation")
        let sortedNames = photoNames.sorted()
        let name = sortedNames[0]
        let photo = await downloadPhoto(named: name)
        show(photo)
        print("Do test :: Task")
    }
    print("Do test end")
}

// -------------------------------------------------------------------
func show2(_ photos: [String]) {
    print("show pic name:\(photos)")
}

func doTest2 () {
    Task {
        let photoNames = ["IMG001", "IMG99", "IMG0404"]
        async let firstPhoto = downloadPhoto(named: photoNames[0])
        async let secondPhoto = downloadPhoto(named: photoNames[1])
        async let thirdPhoto = downloadPhoto(named: photoNames[2])
        let photos = await [firstPhoto, secondPhoto, thirdPhoto]
        show2(photos)
    }
}

