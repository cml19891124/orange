//
//  LHelper.swift
//  LHLabel
//
//  Created by lh on 2018/11/21.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class LHelper: NSObject {
    static let share = LHelper()
    
    private var dataArr: [LHModel] = [LHModel]()
    
    
    func addList(text: String, font: UIFont) -> LList {
        for m in dataArr {
            if m.text == text {
                return m.list!
            }
        }
        return self.dealText(text: text, font: font)
    }
    
    private func dealText(text: String, font: UIFont) -> LList {
        let model = LHModel.init(text: text)
        let list = LList()
        for i in 0..<text.count {
            let start = text.index(text.startIndex, offsetBy: i)
            let end = text.index(text.startIndex, offsetBy: i + 1)
            let per = text[start..<end]
            let current = LNode.init(word: String(per), font: font, index: i)
            list.appendToTail(node: current)
        }
        model.list = list
        self.dataArr.append(model)
        return list
    }

}
