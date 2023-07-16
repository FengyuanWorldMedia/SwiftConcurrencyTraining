//
//  TaskOnActorSample.swift
//  chapter-23_GlobalActor
//
//  Created by 丰源天下传媒 on 2023/4/30.
//

import Foundation

func testTaskOnMainActorSample_1 () {
    assert(Thread.isMainThread, "testTaskOnMainActorSample_1 在 @MainActor")
    Task { @MainActor in
        assert(Thread.isMainThread, "testTaskOnMainActorSample_1#Task 在 @MainActor")
    }
}

@MainActor
func testTaskOnMainActorSample_2 () {
    assert(!Thread.isMainThread, "testTaskOnMainActorSample_1 在 @MainActor")
    Task { @MainActor in
        assert(Thread.isMainThread, "testTaskOnMainActorSample_1#Task 在 @MainActor")
    }
}


func testTaskOnWolfManGlobalActorSample_3 () {
    assert(Thread.isMainThread, "testTaskOnWolfManGlobalActorSample_3 在 主线程上")
    Task.detached { @WolfManGlobalActor in
        increaseCount1()
        assert(Thread.isMainThread, "testTaskOnWolfManGlobalActorSample_3#Task 在 主线程上上")
    }
} 
