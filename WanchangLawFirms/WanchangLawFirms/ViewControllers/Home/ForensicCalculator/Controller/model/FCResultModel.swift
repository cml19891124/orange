//
//  FCResultModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/14.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 法务计算结果模型
class FCResultModel: NSObject {
    
    @objc var damages: NSDictionary? {
        didSet {
            let m = FCDamageModel.mj_object(withKeyValues: damages)
            if m != nil {
                damageModel = m!
            }
        }
    }
    @objc var doc: NSDictionary? {
        didSet {
            let m = FCDocModel.mj_object(withKeyValues: doc)
            if m != nil {
                docModel = m!
            }
        }
    }
    @objc var funeral_expenses: NSDictionary? {
        didSet {
            let m = FCFuneralModel.mj_object(withKeyValues: funeral_expenses)
            if m != nil {
                funeralModel = m!
            }
        }
    }
    @objc var others: NSArray? {
        didSet {
            let arr = FCOtherModel.mj_objectArray(withKeyValuesArray: others) as? [FCOtherModel]
            if arr != nil {
                otherModelArr = arr!
            }
        }
    }
    @objc var family: NSArray? {
        didSet {
            let arr = FCOtherModel.mj_objectArray(withKeyValuesArray: family) as? [FCOtherModel]
            if arr != nil {
                familyModelArr = arr!
            }
        }
    }
    @objc var accept_fee: NSDictionary? {
        didSet {
            let m = FCFeeModel.mj_object(withKeyValues: accept_fee)
            if m != nil {
                acceptFeeModel = m!
            }
        }
    }
    @objc var apply_fee: NSDictionary? {
        didSet {
            let m = FCFeeModel.mj_object(withKeyValues: apply_fee)
            if m != nil {
                applyFeeModel = m!
            }
        }
    }
    @objc var keep_fee: NSDictionary? {
        didSet {
            let m = FCFeeModel.mj_object(withKeyValues: keep_fee)
            if m != nil {
                keepFeeModel = m!
            }
        }
    }
    @objc var criminal: NSArray? {
        didSet {
            let arr = FCCriminalModel.mj_objectArray(withKeyValuesArray: criminal) as? [FCCriminalModel]
            if arr != nil {
                criminalModelArr = arr!
            }
        }
    }
    @objc var max: String = ""
    @objc var min: String = ""
    
    var damageModel: FCDamageModel = FCDamageModel()
    var docModel: FCDocModel = FCDocModel()
    var funeralModel: FCFuneralModel = FCFuneralModel()
    var otherModelArr: [FCOtherModel] = [FCOtherModel]()
    var familyModelArr: [FCOtherModel] = [FCOtherModel]()
    
    var acceptFeeModel: FCFeeModel = FCFeeModel()
    var applyFeeModel: FCFeeModel = FCFeeModel()
    var keepFeeModel: FCFeeModel = FCFeeModel()
    
    var lawyerFeeModel: FCFeeModel {
        get {
            let temp = FCFeeModel()
            temp.max = max
            temp.val = min
            temp.title = "律师费"
            return temp
        }
    }
    
    var criminalModelArr: [FCCriminalModel] = [FCCriminalModel]()

}

class FCDamageModel: NSObject {
    @objc var title: String = ""
    @objc var val: String = ""
    
    var j_number: Float {
        get {
            guard let temp = Float(val) else {
                return 0
            }
            return temp
        }
    }
}

class FCDocModel: NSObject {
    @objc var id: String = ""
    @objc var title: String = ""
}

class FCFuneralModel: NSObject {
    @objc var title: String = ""
    @objc var val: String = ""
    
    var can_edit: Bool {
        get {
            if title == "伤残津贴" {
                return true
            }
            return false
        }
    }
    
    var j_val: Float {
        get {
            guard let temp = Float(val) else {
                return 0
            }
            return temp
        }
    }
    var count: Int = 1
    var j_number: Float {
        get {
            return j_val * Float(count)
        }
    }
    var resultShowStr: String {
        get {
            let tempStr = String.init(format: "%.2f", j_number)
            if can_edit {
                if count <= 1 {
                    return String.init(format: "%.2f元/月", j_val)
                }
            }
            return tempStr + "元"
        }
    }
}

class FCOtherModel: NSObject {
    @objc var id: String = ""
    @objc var sub_title: String = ""
    @objc var title: String = ""
    
    @objc var age: String = ""
    @objc var val: String = ""
    
    @objc var data: NSArray? {
        didSet {
            let arr = FCOtherDataModel.mj_objectArray(withKeyValuesArray: data) as? [FCOtherDataModel]
            if arr != nil {
                otherDataArr = arr!
            }
        }
    }
    var otherDataArr: [FCOtherDataModel] = [FCOtherDataModel]()
    
    var j_selected: Bool = false
    
    var count: Int? {
        didSet {
            guard let temp = count else {
                self.j_selected = false
                return
            }
            if temp > 0 {
                self.j_selected = true
            } else {
                self.j_selected = false
            }
        }
    }
    private var j_val: Float {
        get {
            guard let temp = Float(val) else {
                return 0
            }
            return temp
        }
    }
    var enter_month: Bool {
        get {
            if j_val > 0 {
                return true
            }
            return false
        }
    }
    private var j_month_cal_result: Float {
        get {
            guard let temp = count else {
                return 0
            }
            return j_val * Float(temp)
        }
    }
    
    var j_text: String = "" {
        didSet {
            let temp = Int(j_text)
            if temp != nil && temp! > 0 {
                j_selected = true
            } else {
                j_selected = false
            }
        }
    }
    private var j_number: Float {
        get {
            if otherDataArr.count > 0 {
                var result: Int64 = 0
                for m in otherDataArr {
                    result += m.total
                }
                return Float(result)
            }
            guard let temp = Float(j_text) else {
                return 0
            }
            return temp
        }
    }
    
    var select_enable: Bool {
        get {
            if enter_month {
                if count == nil || count! == 0 {
                    return false
                }
                return true
            }
            if j_number > 0 {
                return true
            }
            return false
        }
    }
    
    var resultShowStr: String {
        get {
            var temp = ""
            if enter_month {
                if count == nil || count! == 0 {
                    temp = String.init(format: "%.0f元/月", j_val)
                } else {
                    temp = String.init(format: "%.0f元", j_month_cal_result)
                }
            } else {
                if j_number > 0 {
                    temp = String.init(format: "%.0f元", j_number)
                } else {
                    temp = sub_title
                }
            }
            return temp
        }
    }
    
    var j_result: Float {
        get {
            if enter_month {
                return j_month_cal_result
            }
            return j_number
        }
    }
}

class FCFeeModel: NSObject {
    @objc var max: String = ""
    @objc var title: String = ""
    @objc var val: String = ""
    
    var j_price: String {
        get {
            guard let tempMax = Int(max) else {
                return val
            }
            guard let tempMin = Int(val) else {
                return val
            }
            if tempMax > tempMin {
                return String.init(format: "%d - %d", tempMin, tempMax)
            }
            return val
        }
    }
}

class FCCriminalModel: NSObject {
    @objc var title: String = ""
    @objc var val: String = ""
}

class FCOtherDataModel: NSObject {
    @objc var age: Int = 0
    @objc var total: Int64 = 0
}
