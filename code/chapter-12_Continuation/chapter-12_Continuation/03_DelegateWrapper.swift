//
//  03_DelegateWrapper.swift
//  chapter-12_Continuation
//
//  Created by 丰源天下传媒 on 2023/3/14.
//

import Foundation

// 方向：
//         up
// left  wolfman  right
//        down
enum Direction {
    case up
    case down
    case left
    case right
}

//  坐标系：
//  0-------------> x
//  |
//  |     .（x,y）
//  |
//  |
//   y
struct Location {
    let x: Int
    let y: Int
}

protocol WolfmanDelegate: AnyObject {
    func up(_ wolf: Wolfman, next: Location)
    func down(_ wolf: Wolfman, next: Location)
    func left(_ wolf: Wolfman, next: Location)
    func right(_ wolf: Wolfman, next: Location)
}

struct Wolfman {
    var name: String
    
    weak var delegate: WolfmanDelegate?
    
    func foward(nowLocation: Location , direction: Direction) {
        switch direction {
        case .up:
            print("up")
            delegate?.up(self, next: Location(x: nowLocation.x, y: nowLocation.y - 1))
        case .down:
            print("down")
            delegate?.down(self, next: Location(x: nowLocation.x, y: nowLocation.y + 1))
        case .left:
            print("left")
            delegate?.left(self, next: Location(x: nowLocation.x - 1, y: nowLocation.y))
        case .right:
            print("right")
            delegate?.right(self, next: Location(x: nowLocation.x + 1, y: nowLocation.y))
        }
    }
}


final class WolfmanWrapper: WolfmanDelegate {
    typealias WolfmanContinuation = CheckedContinuation<(Wolfman,Location), Never>
    private var wolfmanContinuation: WolfmanContinuation?
    private var wolfman: Wolfman
    
    init(name: String) {
        wolfman = Wolfman(name: name)
        wolfman.delegate = self
    }
    func up(_ wolf: Wolfman, next: Location) {
        wolfmanContinuation?.resume(returning: (wolf, next))
    }
    func down(_ wolf: Wolfman, next: Location) {
        wolfmanContinuation?.resume(returning: (wolf, next))
    }
    func left(_ wolf: Wolfman, next: Location) {
        wolfmanContinuation?.resume(returning: (wolf, next))
    }
    func right(_ wolf: Wolfman, next: Location) {
        wolfmanContinuation?.resume(returning: (wolf, next))
    }
    
    // 再次强调，返回的数据类型和 resume 的类型是一致的。
    func foward(nowLocation: Location , direction: Direction) async -> (Wolfman,Location) {
        return await withCheckedContinuation { (continuation: CheckedContinuation<(Wolfman,Location), Never>)  -> Void in
            wolfmanContinuation = continuation
            wolfman.foward(nowLocation: nowLocation, direction: direction)
        }
    }
}

func test03_DelegateWrapper() {
    Task {
        let nowLocation = Location(x: 10, y: 10)
        
        let wofman = WolfmanWrapper(name: "Wolfman-Super")
        // 向右进一步
        let wolfmanInfo = await wofman.foward(nowLocation: nowLocation, direction: .right)
        print(wolfmanInfo.0.name)
        print("step1: x: \(wolfmanInfo.1.x), y: \(wolfmanInfo.1.y)")
        // 向下进一步
        let wolfmanInfo2 = await wofman.foward(nowLocation: wolfmanInfo.1, direction: .down)
        
        // 从（x: 10, y: 10） 到 （x: 11, y: 11）
        print("step2: x: \(wolfmanInfo2.1.x), y: \(wolfmanInfo2.1.y)")
    }
}
