//
//  MineBusinessAboutUsBottomView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/21.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MineBusinessAboutUsBottomView: UIView {

    private let lab: LLabel = LLabel.init(font: kFontS, textAlignment: NSTextAlignment.center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        lab.textColor = UIColor.white
        let str1 = "《欧伶猪法务软件许可及服务协议》"
        let str2 = "和"
        let str3 = "《欧伶猪隐私保护指引》"
        lab.text = str1 + str2 + str3
        lab.addClickText(str: str1, original_color: UIColor.white, click_color: UIColor.init(white: 1, alpha: 0.5))
        lab.addClickText(str: str3, original_color: UIColor.white, click_color: UIColor.init(white: 1, alpha: 0.5))
        lab.delegate = self
        self.addSubview(lab)
        _ = lab.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.centerYEqualToView(self)?.rightSpaceToView(self, kLeftSpaceL)?.heightIs(40)
    }

}

extension MineBusinessAboutUsBottomView: LLabelDelegate {
    func llabelClick(text: String) {
        var temp = "agreement"
        if UserInfo.share.is_business {
            temp = "co_agreement"
        }
        if text == "《欧伶猪隐私保护指引》" {
            temp = "privacy"
            if UserInfo.share.is_business {
                temp = "co_privacy"
            }
        }
        let urlStr = BASE_URL + api_posts_info + "?symbol=" + temp
        let vc = JURLController.init(urlStr: urlStr, bind: text)
        JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
    }
}
