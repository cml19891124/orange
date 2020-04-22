//
//  MineOrderTopView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/6.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class MineOrderTopView: UIView {
    
    lazy var topV: JTitleChooseView = {
        () -> JTitleChooseView in
        let temp = JTitleChooseView.init(frame: self.bounds)
        self.addSubview(temp)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kCellColor
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let bindArr: [String] = ["c_dealing","c_finished"]
        var temp = [JTitleChooseModel]()
        for i in 0..<bindArr.count {
            let bind = bindArr[i]
            let model = JTitleChooseModel.init(bind: bind, normalTextColor: kTextBlackColor, selectedTextColor: kOrangeDarkColor, lineColor: kOrangeDarkColor, textFont: kFontM, tag: i + 1)
            temp.append(model)
        }
        topV.dataArr = temp
    }

}
