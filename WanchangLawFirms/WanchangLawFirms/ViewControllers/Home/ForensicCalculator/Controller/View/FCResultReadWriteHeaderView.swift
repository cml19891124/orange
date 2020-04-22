//
//  FCResultReadWriteHeaderView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/16.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol FCResultReadWriteHeaderViewDelegate: NSObjectProtocol {
    func fcResultReadWriteHeaderViewSelect()
    func fcResultReadWriteHeaderViewTapClick(model: FCOtherModel)
}

/// 计算结果， 可读可写
class FCResultReadWriteHeaderView: FCResultBaseHeaderView {

    weak var delegate: FCResultReadWriteHeaderViewDelegate?
    var model: FCOtherModel! {
        didSet {
            titleLab.text = model.title
            trailLab.text = model.resultShowStr
            self.selBtn.isUserInteractionEnabled = model.select_enable
            self.selBtn.isSelected = model.j_selected
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.selBtn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        self.line.isHidden = false
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func btnClick(sender: UIButton) {
        model.j_selected = !model.j_selected
        sender.isSelected = model.j_selected
        self.delegate?.fcResultReadWriteHeaderViewSelect()
    }
    
    @objc private func tapClick() {
        self.delegate?.fcResultReadWriteHeaderViewTapClick(model: model)
    }
    
}
