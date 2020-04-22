//
//  ChatFuncCollectionCell.swift
//  OLegal
//
//  Created by lh on 2018/11/28.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 聊天功能cell
class ChatFuncCollectionCell: UICollectionViewCell {
    
    let btn: JBigEmoBtn = JBigEmoBtn.init(kFontS, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, nil, nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kBaseColor
        self.addSubview(btn)
        _ = btn.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
