//
//  MBTitleView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/25.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

protocol MBTitleViewDelegate: NSObjectProtocol {
    func mbTitleViewClick(sender: HImgCenterAlignmentBtn)
}

class MBTitleView: UIView {

    weak var delegate: MBTitleViewDelegate?
    private lazy var titleBtn: HImgCenterAlignmentBtn = {
        () -> HImgCenterAlignmentBtn in
        let temp = HImgCenterAlignmentBtn.init(kFontL, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(btnClick))
        if UserInfo.share.is_business {
            temp.setTitle(L$("mine_business_order"), for: .normal)
        } else {
            temp.setTitle(L$("mine_order"), for: .normal)
        }
        temp.setImage(UIImage.init(named: "triangle_white_down"), for: .normal)
        temp.setImage(UIImage.init(named: "triangle_white_up"), for: .selected)
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
        self.addSubview(titleBtn)
        _ = titleBtn.sd_layout()?.centerXEqualToView(self)?.centerYEqualToView(self)?.widthIs(100)?.heightIs(30)
    }
    
    @objc private func btnClick() {
        titleBtn.isSelected = !titleBtn.isSelected
        self.delegate?.mbTitleViewClick(sender: titleBtn)
    }

}
