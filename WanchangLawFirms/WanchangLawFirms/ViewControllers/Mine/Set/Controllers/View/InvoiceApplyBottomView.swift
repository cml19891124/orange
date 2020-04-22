//
//  InvoiceApplyBottomView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/25.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

protocol InvoiceApplyBottomViewDelegate: NSObjectProtocol {
    func invoiceApplyBottomViewOKClick(sender: UIButton)
    func invoiceApplySelectedAllClick(selectedAll: Bool)
}

class InvoiceApplyBottomView: UIView {
    var totalAmount: Float = 0 {
        didSet {
            priceLab.text = String.init(format: "可开发票金额¥%.2f", totalAmount)
        }
    }
    
    var selectedAmount: Float = 0 {
        didSet {
            resultLab.text = String.init(format: "已选¥%.2f", selectedAmount)
        }
    }
    
    var selectedCount: Int = 0 {
        didSet {
            countLab.text = "已选\(selectedCount)笔账单"
        }
    }
    
    var isSelectedAll: Bool = false {
        didSet {
            selBtn.isSelected = isSelectedAll
        }
    }

    weak var delegate: InvoiceApplyBottomViewDelegate?
    private let line: UIView = UIView.init(lineColor: kLineGrayColor)
    private lazy var selBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontM, kTextBlackColor, UIControl.ContentHorizontalAlignment.left, self, #selector(selBtnClick))
        temp.setTitle(kBtnSpaceString + "全选", for: .normal)
        temp.setImage(UIImage.init(named: "pay_circle_normal"), for: .normal)
        temp.setImage(UIImage.init(named: "pay_circle_selected"), for: .selected)
        return temp
    }()
    private let countLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.right)
    private let priceLab: UILabel = UILabel.init(kFontMS, kOrangeDarkColor, NSTextAlignment.left)
    private let resultLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    private lazy var applyBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontM, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(applyBtnClick))
        temp.setTitle("立即开票", for: .normal)
        temp.backgroundColor = kOrangeDarkColor
        temp.layer.cornerRadius = kBtnCornerR
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
        
        self.addSubview(line)
        self.addSubview(selBtn)
        self.addSubview(countLab)
        self.addSubview(priceLab)
        self.addSubview(resultLab)
        self.addSubview(applyBtn)
        
        _ = line.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.heightIs(kLineHeight)
        _ = selBtn.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, kLeftSpaceS)?.widthIs(120)?.heightIs(30)
        _ = countLab.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(selBtn)?.widthIs(120)?.heightIs(20)
        _ = priceLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, 100)?.topSpaceToView(selBtn, kLeftSpaceS)?.heightIs(20)
        _ = resultLab.sd_layout()?.leftEqualToView(priceLab)?.rightEqualToView(priceLab)?.topSpaceToView(priceLab, 0)?.heightIs(20)
        _ = applyBtn.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.topSpaceToView(selBtn, 15)?.widthIs(80)?.heightIs(30)
    }

    @objc private func selBtnClick() {
        selBtn.isSelected = !selBtn.isSelected
        self.delegate?.invoiceApplySelectedAllClick(selectedAll: selBtn.isSelected)
    }
    
    @objc private func applyBtnClick() {
        self.delegate?.invoiceApplyBottomViewOKClick(sender: applyBtn)
    }
}
