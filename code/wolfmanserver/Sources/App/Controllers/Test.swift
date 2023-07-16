//
//  Test.swift
//  
//
//  Created by 苏州丰源天下传媒 on 2023/02/19.
//

import Foundation
import Vapor

struct Test {
    
    static func routes(_ app: Application) throws {
        
        app.get { req async in
            "It works!"
        }
        
        app.get("hello") { req async -> String in
            "Hello, world!"
        }
    }
}
