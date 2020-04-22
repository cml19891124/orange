//
//  FCResultBottomView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/11/29.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 计算结果底部文献
class FCResultBottomView: UIView {
    
    var model: FCDocModel! {
        didSet {
            let str1 = "根据"
            let xieyi = "《" + model.title + "》"
            let str2 = "文件计算，结果仅供参考!"
            lab.text = str1 + xieyi + str2
            lab.addClickText(str: xieyi, original_color: kOrangeDarkColor, click_color: kOrangeDarkClickColor)
        }
    }
    
    let lab: LLabel = LLabel.init(font: kFontMS, textAlignment: NSTextAlignment.center)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(lab)
        _ = lab.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.rightSpaceToView(self, kLeftSpaceL)?.topSpaceToView(self, kLeftSpaceL)?.bottomSpaceToView(self, kLeftSpaceL)
    }

}
