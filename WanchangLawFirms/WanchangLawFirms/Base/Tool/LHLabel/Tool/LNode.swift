//
//  LNode.swift
//  LHLabel
//
//  Created by lh on 2018/11/21.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class LNode: NSObject {
    
    private var word: String
    private var font: UIFont
    private var index: Int
    var previous: LNode?
    var next: LNode?
    
    init(word: String, font: UIFont, index: Int) {
        self.word = word
        self.font = font
        self.index = index
        super.init()
    }

}

extension LNode {
    var width: CGFloat {
        get {
            let ns = word as NSString
            let w = ns.boundingRect(with: CGSize.init(width: 300, height: 300), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).width
            return w
        }
    }
    
    var showStr: String {
        get {
            return word
        }
    }
    
    var tag: Int {
        get {
            return index
        }
    }
    
    var start: CGFloat {
        get {
            var temp: CGFloat = 0
            var current = self.previous
            while current != nil {
                temp += current!.width
                current = current?.previous
            }
            return temp
        }
    }
    
    var end: CGFloat {
        get {
            return start + width
        }
    }
}
