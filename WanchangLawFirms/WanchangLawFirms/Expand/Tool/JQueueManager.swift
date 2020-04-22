//
//  JQueueManager.swift
//  Stormtrader
//
//  Created by lh on 2018/8/28.
//  Copyright © 2018年 gaming17. All rights reserved.
//

import UIKit

class JQueueManager: NSObject {
    static let share = JQueueManager()
    
    func mainAsyncQueue(block:@escaping() -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }
    
    func globalAsyncQueue(block:@escaping() -> Void) {
        DispatchQueue.global(qos: .utility).async {
            block()
        }
    }
}
