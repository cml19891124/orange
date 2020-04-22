//
//  ClassicCaseTopView.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class ClassicCaseTopView: UIView {
    
    lazy var chooseView: JTitleChooseView = {
        () -> JTitleChooseView in
        let temp = JTitleChooseView.init(frame: self.bounds)
        self.addSubview(temp)
        return temp
    }()
    
    var modelArr: [HCategoryModel]! {
        didSet {
            var jMArr: [JTitleChooseModel] = [JTitleChooseModel]()
            for i in 0..<modelArr.count {
                let cM = modelArr[i]
                let jM = JTitleChooseModel.init(bind: cM.title, normalTextColor: kTextBlackColor, selectedTextColor: kTextBlackColor, lineColor: kOrangeLightColor, textFont: kFontM, tag: i + 1)
                jMArr.append(jM)
            }
            self.chooseView.dataArr = jMArr
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kCellColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
