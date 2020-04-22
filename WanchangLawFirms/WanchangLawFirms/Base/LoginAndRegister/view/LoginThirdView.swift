//
//  LoginThirdView.swift
//  OLegal
//
//  Created by lh on 2018/11/19.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 三方登陆视图
class LoginThirdView: UIView {
    
    private lazy var lineV: JLineLabLineView = {
        () -> JLineLabLineView in
        let temp = JLineLabLineView.init(textColor: kOrangeDarkColor, font: kFontM, lineColor: kOrangeDarkColor)
        temp.bind = "lr_third_login_way"
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
        var wordArr: [String] = ["lr_weibo","lr_qq"]
        if WXApi.isWXAppInstalled() {
            wordArr.append("lr_wechat")
        }
        let btnW = self.frame.size.width / CGFloat(wordArr.count)
        for i in 0..<wordArr.count {
            let btn: UIButton = UIButton.init(kFontMS, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, self, #selector(btnsClick(sender:)))
            btn.frame = CGRect.init(x: CGFloat(i) * btnW, y: 40, width: btnW, height: 44)
            btn.setImage(UIImage.init(named: wordArr[i]), for: .normal)
            btn.tag = i + 1
            self.addSubview(btn)
        }
        _ = lineV.sd_layout()?.leftSpaceToView(self, 0)?.rightSpaceToView(self, 0)?.topSpaceToView(self, 0)?.heightIs(20)
    }
    
    @objc private func btnsClick(sender: UIButton) {
        switch sender.tag {
        case 1:
            JShareManager.share.authWeiboLogin()
            break
        case 2:
            JShareManager.share.authQQLogin()
            break
        case 3:
            JShareManager.share.authWechatLogin()
            break
        default:
            break
        }
    }

}
