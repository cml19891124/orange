//
//  HHFOnlineServiceCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/3/9.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class HHFOnlineServiceCell: UICollectionViewCell {
    var bind: String! {
        didSet {
            logoBtn.setTitle(L$(bind), for: .normal)
            let imgName = JIconManager.share.getIcon(bind: bind)
            logoBtn.setImage(UIImage.init(named: imgName), for: .normal)
        }
    }
    
    private let logoBtn: JVerticalBtn = JVerticalBtn.init(kFontMS, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, nil, nil)
    private let redLab: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kCellColor
        redLab.layer.cornerRadius = 4
        redLab.clipsToBounds = true
        redLab.backgroundColor = kOrangeDarkColor
        
        logoBtn.frame = self.bounds
        self.addSubview(logoBtn)
        self.addSubview(redLab)
        
        _ = redLab.sd_layout()?.rightSpaceToView(self, self.frame.size.width / 2 - 25)?.topSpaceToView(self, 22)?.widthIs(8)?.heightIs(8)
        
        if UserInfo.defaultChatOnlineServiceNoti() == nil {
            self.redLab.isHidden = true
        } else {
            self.redLab.isHidden = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(showRed), name: NSNotification.Name(rawValue: noti_online_service_new), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideRed), name: NSNotification.Name(rawValue: noti_online_service_clear), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func showRed() {
        self.redLab.isHidden = false
    }
    
    @objc private func hideRed() {
        self.redLab.isHidden = true
    }
}
