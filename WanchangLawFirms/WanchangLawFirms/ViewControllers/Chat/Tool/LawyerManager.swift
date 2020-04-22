//
//  LawyerManager.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/27.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 律师管理
class LawyerManager: NSObject {
    static let share = LawyerManager()
    
    private var lawyerArr: [LawyerModel] = [LawyerModel]()
    
    override init() {
        super.init()
        self.localData()
    }
    
    /// 得到某个律师信息（本地）
    func getLawyerModel(id: String, success:@escaping(LawyerModel) -> Void) {
        for m in lawyerArr {
            if m.id == id {
                success(m)
                return
            }
        }
        self.chatLawyer(id: id) { (m) in
            if m != nil {
                success(m!)
            } else {
                let m = LawyerModel()
                m.id = id
                success(m)
            }
        }
    }
    
}

extension LawyerManager {
    /// 更新律师信息到本地
    func addLawyersByList(arr: [MessageModel]) {
        var lawyerArr = [LawyerModel]()
        for model in arr {
            let m = LawyerModel()
            m.id = model.id
            m.name = model.name
            m.avatar = model.avatar
            lawyerArr.append(m)
        }
        RealmManager.share().addLawyerArr(lawyerArr)
        self.localData()
    }
    
    func updateLawyers(arr: [LawyerModel]) {
        RealmManager.share().addLawyerArr(arr)
        self.localData()
    }
}

extension LawyerManager {
    /// 本地律师信息
    private func localData() {
        self.lawyerArr = RealmManager.share().getAllLawyer()
    }
}

extension LawyerManager {
    /// 获取单个律师信息
    func chatLawyer(id: String, success:@escaping(LawyerModel?) -> Void) {
        let prams: NSDictionary = ["lawyer_id": id]
        HTTPManager.share.ask(isGet: true, url: api_chat_lawyer, prams: prams, needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let m = LawyerModel.mj_object(withKeyValues: dict[net_key_result])
                if m != nil {
                    RealmManager.share().addLawyerArr([m!])
                    self.lawyerArr.append(m!)
                }
                success(m)
            } else {
                success(nil)
            }
        }) { (err) in
            success(nil)
        }
    }
}
