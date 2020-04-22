//
//  MineOrderBtnsView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/17.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class MineOrderBtnsView: UIView {
    
    var status: String = ""
    var model: MessageModel! {
        didSet {
            self.leftBtn.setTitle("¥" + model.amount, for: .normal)
            if status == "1" {
                self.rightBtn.setTitle(L$("to_communicate"), for: .normal)
                let w: CGFloat = 160
                let h: CGFloat = 30
                bView.frame = CGRect.init(x: kDeviceWidth - kLeftSpaceS - w, y: 0, width: w, height: h)
                _ = leftBtn.sd_layout()?.leftSpaceToView(bView, 0)?.centerYEqualToView(bView)?.widthIs(w/2)?.heightIs(h)
                _ = rightBtn.sd_layout()?.rightSpaceToView(bView, 0)?.centerYEqualToView(bView)?.widthIs(w/2)?.heightIs(h)
            } else {
                let w: CGFloat = 80
                let h: CGFloat = 30
                bView.frame = CGRect.init(x: kDeviceWidth - kLeftSpaceS - w, y: 0, width: w, height: h)
                _ = leftBtn.sd_layout()?.leftSpaceToView(bView, 0)?.topSpaceToView(bView, 0)?.rightSpaceToView(bView, 0)?.bottomSpaceToView(bView, 0)
            }
        }
    }

    private lazy var bView: UIView = {
        () -> UIView in
        let temp = UIView()
        temp.layer.cornerRadius = 15
        temp.layer.borderWidth = 1
        temp.layer.borderColor = kOrangeDarkColor.cgColor
        temp.clipsToBounds = true
        return temp
    }()
    private lazy var leftBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontS, kOrangeDarkColor, UIControl.ContentHorizontalAlignment.center, nil, nil)
        bView.addSubview(temp)
        return temp
    }()
    private lazy var rightBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontS, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(btnsClick(sender:)))
        temp.backgroundColor = kOrangeDarkColor
        bView.addSubview(temp)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(bView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func btnsClick(sender: UIButton) {
        let vc = ChatController()
        vc.model = model
        JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
    }

}
