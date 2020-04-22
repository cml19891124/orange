//
//  ForensicCalculatorModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/14.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 计算模型
class ForensicCalculatorModel: NSObject {

    /// 地区
    var areaModel: JCalculateModel?
    /// 伤残等级
    var levelModel: JCalculateModel?
    /// 户口
    var hokouModel: JCalculateModel?
    /// 类型
    var typeModel: JCalculateModel?
    /// 是否涉及资产
    var propertyModel: JCalculateModel?
    
    var text: String?
    
    var bind: String
    
    init(bind: String) {
        self.bind = bind
        super.init()
    }
    
    func clearAll() {
        areaModel = nil
        levelModel = nil
        hokouModel = nil
        typeModel = nil
        propertyModel = nil
        text = nil
    }
    
}
