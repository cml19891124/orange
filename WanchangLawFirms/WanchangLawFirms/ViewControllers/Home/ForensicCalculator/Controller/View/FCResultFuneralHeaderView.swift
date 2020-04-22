//
//  FCResultFuneralHeaderView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/16.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol FCResultFuneralHeaderViewDelegate: NSObjectProtocol {
    func fcResultFuneralHeaderViewTapClick(model: FCFuneralModel)
}

/// 计算结果， 津贴
class FCResultFuneralHeaderView: FCResultBaseHeaderView {

    weak var delegate: FCResultFuneralHeaderViewDelegate?
    var model: FCFuneralModel! {
        didSet {
            titleLab.text = model.title
            trailLab.text = model.resultShowStr
            if !model.can_edit {
                self.arrow.isHidden = true
            }
            if model.count == 0 {
                self.selBtn.isSelected = false
            } else {
                self.selBtn.isSelected = true
            }
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.line.isHidden = true
        self.selBtn.isUserInteractionEnabled = false
        self.selBtn.isSelected = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapClick() {
        if model.can_edit {
            self.delegate?.fcResultFuneralHeaderViewTapClick(model: model)
        }
    }

}
