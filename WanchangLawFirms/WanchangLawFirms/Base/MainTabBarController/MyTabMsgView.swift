//
//  MyTabMsgView.swift
//  OLegal
//
//  Created by lh on 2018/11/27.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class MyTabMsgView: UIView {
    
    var msgCount: Int = 0 {
        didSet {
            if msgCount == 0 {
                countLab.isHidden = true
                return
            }
            countLab.isHidden = false
            if msgCount > 100 {
                countLab.text = "99+"
            } else if msgCount > 0 {
                countLab.text = "\(msgCount)"
            }
            var w = countLab.sizeThatFits(CGSize.init(width: 50, height: 16)).width + kLeftSpaceSS
            if w < 20 {
                w = 20
            }
            switch JIconManager.share.icon_type {
            case .spring:
                countLab.frame = CGRect.init(x: 47, y: 78 - 22, width: w, height: 16)
                break
            case .legal:
                countLab.frame = CGRect.init(x: 47, y: 67 - 25, width: w, height: 16)
                break
            case .midAutumn:
                countLab.frame = CGRect.init(x: 47, y: 78 - 22, width: w, height: 16)
                break
            case .nation:
                countLab.frame = CGRect.init(x: 47, y: 78 - 22, width: w, height: 16)
                break
            default:
                countLab.frame = CGRect.init(x: 47, y: 67 - 25, width: w, height: 16)
                break
            }
        }
    }
    
    private let imgView: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFit)
    private let titleLab: UILabel = UILabel.init(UIFont.systemFont(ofSize: 12), UIColor.white, NSTextAlignment.center)
    private let countLab: UILabel = UILabel.init(kFontS, kOrangeDarkColor, NSTextAlignment.center)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        countLab.backgroundColor = UIColor.white
        countLab.layer.cornerRadius = 8
        countLab.isHidden = true
        imgView.image = UIImage.init(named: JIconManager.share.getIcon(bind: "tab_message"))
        self.addSubview(imgView)
        imgView.addSubview(countLab)
        
        switch JIconManager.share.icon_type {
        case .spring:
            countLab.layer.borderColor = kSpringColor.cgColor
            countLab.textColor = kSpringColor
            countLab.layer.borderWidth = 2
            _ = imgView.sd_layout()?.centerXEqualToView(self)?.bottomSpaceToView(self, 8)?.widthIs(67)?.heightIs(78)
            break
        case .legal:
            countLab.layer.borderColor = kOrangeDarkColor.cgColor
            countLab.textColor = kOrangeDarkColor
            countLab.layer.borderWidth = 1
            _ = imgView.sd_layout()?.centerXEqualToView(self)?.bottomSpaceToView(self, 5)?.widthIs(67)?.heightIs(67)
            break
        case .boat:
            countLab.layer.borderColor = kOrangeDarkColor.cgColor
            countLab.textColor = kOrangeDarkColor
            countLab.layer.borderWidth = 1
            imgView.addSubview(titleLab)
            _ = imgView.sd_layout()?.centerXEqualToView(self)?.bottomSpaceToView(self, 5)?.widthIs(67)?.heightIs(67)
            break
        case .midAutumn:
            countLab.layer.borderColor = kSpringColor.cgColor
            countLab.textColor = kSpringColor
            countLab.layer.borderWidth = 2
            _ = imgView.sd_layout()?.centerXEqualToView(self)?.bottomSpaceToView(self, 8)?.widthIs(67)?.heightIs(78)
            break
        case .nation:
            countLab.layer.borderColor = kSpringColor.cgColor
            countLab.textColor = kSpringColor
            countLab.layer.borderWidth = 2
            _ = imgView.sd_layout()?.centerXEqualToView(self)?.bottomSpaceToView(self, 8)?.widthIs(67)?.heightIs(78)
            break
        default:
            countLab.layer.borderColor = kOrangeDarkColor.cgColor
            countLab.textColor = kOrangeDarkColor
            countLab.layer.borderWidth = 1
            titleLab.text = L$("message")
            imgView.addSubview(titleLab)
            _ = imgView.sd_layout()?.centerXEqualToView(self)?.bottomSpaceToView(self, 5)?.widthIs(67)?.heightIs(67)
            _ = titleLab.sd_layout()?.centerXEqualToView(imgView)?.bottomSpaceToView(imgView, 10)?.widthIs(50)?.heightIs(20)
            break
        }
    }

}
