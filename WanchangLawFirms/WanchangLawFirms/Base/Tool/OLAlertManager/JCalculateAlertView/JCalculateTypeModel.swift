//
//  JCalculateTypeModel.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/13.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class JCalculateTypeModel: NSObject {
    
    @objc var casee: NSArray? {
        didSet {
            let arr = JCalculateModel.mj_objectArray(withKeyValuesArray: casee) as? [JCalculateModel]
            if arr != nil {
                caseArr = arr!
            }
        }
    }
    @objc var level: NSArray?{
        didSet {
            let arr = JCalculateModel.mj_objectArray(withKeyValuesArray: level) as? [JCalculateModel]
            if arr != nil {
                levelArr = arr!
            }
        }
    }
    @objc var province: NSArray?{
        didSet {
            let arr = JCalculateModel.mj_objectArray(withKeyValuesArray: province) as? [JCalculateModel]
            if arr != nil {
                provinceArr = arr!.sorted(by: { (m1, m2) -> Bool in
                    return m1.sort < m2.sort
                })
            }
        }
    }
    @objc var resident: NSArray?{
        didSet {
            let arr = JCalculateModel.mj_objectArray(withKeyValuesArray: resident) as? [JCalculateModel]
            if arr != nil {
                residentArr = arr!
            }
        }
    }
    @objc var type: NSArray?{
        didSet {
            let arr = JCalculateModel.mj_objectArray(withKeyValuesArray: type) as? [JCalculateModel]
            if arr != nil {
                typeArr = arr!
            }
        }
    }
    
    var caseArr: [JCalculateModel] = [JCalculateModel]()
    var levelArr: [JCalculateModel] = [JCalculateModel]()
    var provinceArr: [JCalculateModel] = [JCalculateModel]()
    var residentArr: [JCalculateModel] = [JCalculateModel]()
    var typeArr: [JCalculateModel] = [JCalculateModel]()
    
    lazy var isOrNotArr: [JCalculateModel] = {
        () -> [JCalculateModel] in
        var tempArr = [JCalculateModel]()
        let m1 = JCalculateModel()
        m1.code = "1"
        m1.val = "是"
        let m2 = JCalculateModel()
        m2.code = "0"
        m2.val = "否"
        tempArr.append(m1)
        tempArr.append(m2)
        return tempArr
    }()
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["casee":"case"]
    }

}
