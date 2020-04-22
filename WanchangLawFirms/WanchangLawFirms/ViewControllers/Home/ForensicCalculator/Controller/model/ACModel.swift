//
//  ACModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/15.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 法务计算结果后手动输入的模型
class ACModel: NSObject {
    
    var title1: String
    var title2: String
    
    var text1: String = ""
    var text2: String = ""
    
    var age: Int {
        get {
            guard let temp = Int(text1) else {
                return 0
            }
            return temp
        }
    }
    
    var number: Int {
        get {
            guard let temp = Int(text2) else {
                return 0
            }
            return temp
        }
    }
    
    var calcuteResult: Int64 {
        get {
            if age == 0 || number == 0 {
                return 0
            }
            let per = Float(age) / 22
            let result = per * Float(number)
            return Int64(result)
        }
    }
    
    init(title1: String, title2: String) {
        self.title1 = title1
        self.title2 = title2
        super.init()
    }

}
