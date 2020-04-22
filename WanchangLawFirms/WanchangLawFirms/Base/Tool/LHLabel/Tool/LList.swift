//
//  LList.swift
//  LHLabel
//
//  Created by lh on 2018/11/21.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class LList: NSObject {
    
    var head: LNode?
    var tail: LNode?
    
    func appendToTail(node: LNode) {
        if tail == nil {
            tail = node
            head = tail
        } else {
            node.previous = tail
            tail!.next = node
            tail = tail?.next
        }
    }

}
