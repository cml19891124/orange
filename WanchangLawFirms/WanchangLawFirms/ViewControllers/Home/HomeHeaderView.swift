//
//  HomeHeaderView.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol HomeHeaderViewDelegate: NSObjectProtocol {
    func homeHeaderViewMoreClick()
}

/// 首页最新资讯UItableView头
class HomeHeaderView: UITableViewHeaderFooterView {
    
    weak var delegate: HomeHeaderViewDelegate?
    private let bView: UIView = UIView()
    lazy var titleBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontM, kTextBlackColor, UIControl.ContentHorizontalAlignment.left, nil, nil)
        temp.setImage(UIImage.reminderImage(), for: .normal)
        return temp
    }()
    
    lazy var moreBtn: HImgRightAlignmentBtn = {
        () -> HImgRightAlignmentBtn in
        let temp = HImgRightAlignmentBtn.init(kFontM, kTextBlackColor, UIControl.ContentHorizontalAlignment.right, self, #selector(moreBtnClick))
        return temp
    }()
    private let spaceV: UIView = UIView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = kBaseColor
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        bView.backgroundColor = kCellColor
        spaceV.backgroundColor = kBaseColor
        self.addSubview(spaceV)
        self.addSubview(bView)
        bView.addSubview(titleBtn)
        bView.addSubview(moreBtn)
        
        _ = spaceV.sd_layout()?.leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.heightIs(10)
        _ = bView.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.topSpaceToView(spaceV, 0)?.bottomEqualToView(self)
        _ = titleBtn.sd_layout()?.leftSpaceToView(bView, kLeftSpaceS)?.centerYEqualToView(bView)?.widthIs(100)?.heightIs(30)
        _ = moreBtn.sd_layout()?.rightSpaceToView(bView, kLeftSpaceS)?.centerYEqualToView(bView)?.widthIs(80)?.heightIs(30)
    }
    
    @objc private func moreBtnClick() {
        self.delegate?.homeHeaderViewMoreClick()
    }
    
}
