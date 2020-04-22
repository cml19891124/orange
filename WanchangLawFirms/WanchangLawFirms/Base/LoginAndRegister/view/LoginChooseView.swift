//
//  LoginChooseView.swift
//  OLegal
//
//  Created by lh on 2018/11/19.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 登陆选择
class LoginChooseView: UIView {
    
    lazy var chooseView: JTitleChooseView = {
        () -> JTitleChooseView in
        let temp = JTitleChooseView.init(frame: self.bounds)
        self.addSubview(temp)
        return temp
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        var wordArr: [String] = ["lr_login","lr_register"]
        if UserInfo.share.is_business {
            wordArr = ["lr_login_account","lr_login_email"]
        }
        var dataArr: [JTitleChooseModel] = [JTitleChooseModel]()
        for i in 0..<wordArr.count {
            let m = JTitleChooseModel.init(bind: wordArr[i], normalTextColor: kOrangeLightColor, selectedTextColor: kOrangeDarkColor, lineColor: kOrangeDarkColor, textFont: kFontL, tag: i + 1)
            dataArr.append(m)
        }
        self.chooseView.dataArr = dataArr
    }

}
