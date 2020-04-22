//
//  MessageTopView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/3.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 会话顶部分类视图
class MessageTopView: UIView {
    
    lazy var topV: JTitleChooseView = {
        () -> JTitleChooseView in
        let temp = JTitleChooseView.init(frame: self.bounds)
        self.addSubview(temp)
        return temp
    }()
    
    private lazy var imgView: UIImageView = {
        () -> UIImageView in
        let temp = UIImageView.init(frame: CGRect.init(x: kDeviceWidth - 25, y: 14, width: 8, height: 8))
        temp.layer.cornerRadius = 4
        temp.clipsToBounds = true
        temp.backgroundColor = kOrangeDarkColor
        self.addSubview(temp)
        return temp
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kCellColor
        self.setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(addNoti), name: NSNotification.Name(rawValue: noti_system_msg_refresh), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeNoti), name: NSNotification.Name(rawValue: noti_system_msg_read), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let bindArr: [String] = ["c_dealing","c_finished","c_system_msg"]
        var temp = [JTitleChooseModel]()
        for i in 0..<bindArr.count {
            let bind = bindArr[i]
            let model = JTitleChooseModel.init(bind: bind, normalTextColor: kTextBlackColor, selectedTextColor: kOrangeDarkColor, lineColor: kOrangeDarkColor, textFont: kFontM, tag: i + 1)
            temp.append(model)
        }
        topV.dataArr = temp
        if UserInfo.getStandard(key: standard_system_msg_noti) != nil {
            self.imgView.isHidden = false
        }
    }
    
    @objc private func addNoti() {
        self.imgView.isHidden = false
        UserInfo.setStandard(key: standard_system_msg_noti, text: "1")
    }
    
    @objc private func removeNoti() {
        self.imgView.isHidden = true
        UserInfo.setStandard(key: standard_system_msg_noti, text: nil)
    }

}
