//
//  BusinessRegistFooterView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/15.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 企业注册协议和注册按钮
class BusinessRegistFooterView: UITableViewHeaderFooterView {

    weak var delegate: JOKBtnCellDelegate?
    private let xieyiLab: LLabel = LLabel.init(font: kFontMS, textAlignment: NSTextAlignment.center)
    private lazy var okBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontM, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(okClick))
        temp.setTitle(L$("lr_regist_instant"), for: .normal)
        temp.backgroundColor = kOrangeDarkColor
        return temp
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = kCellColor
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let str1 = L$("lr_click_register_means")
        let str2 = L$("lr_agreement")
        xieyiLab.textColor = kTextGrayColor
        xieyiLab.text = str1 + str2
        xieyiLab.addClickText(str: str2, original_color: kOrangeDarkColor, click_color: kOrangeDarkClickColor)
        xieyiLab.delegate = self
        self.addSubview(xieyiLab)
        self.addSubview(okBtn)
        
        _ = xieyiLab.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.heightIs(kCellHeight)
        _ = okBtn.sd_layout()?.leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.heightIs(kCellHeight)
    }
    
    @objc private func okClick() {
        self.delegate?.jOKBtnCellClick(sender: okBtn)
    }
}

extension BusinessRegistFooterView: LLabelDelegate {
    func llabelClick(text: String) {
        let urlStr = BASE_URL + api_posts_info + "?symbol=agree"
        let vc = JSafariController.init(urlStr: urlStr, title: "用户使用协议")
        JAuthorizeManager.init(view: self).responseChainViewController().present(vc, animated: true, completion: nil)
    }
}
