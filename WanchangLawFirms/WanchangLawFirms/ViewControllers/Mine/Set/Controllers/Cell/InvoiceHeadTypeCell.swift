//
//  InvoiceHeadTypeCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/26.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

protocol InvoiceHeadTypeCellDelegate: NSObjectProtocol {
    func invoiceHeadTypeCellClick(isBusiness: Bool)
}

class InvoiceHeadTypeCell: InvoiceHeadBaseCell {
    
    weak var delegate: InvoiceHeadTypeCellDelegate?
    private lazy var personBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontS, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, self, #selector(btnsClick(sender:)))
        temp.setTitleColor(UIColor.white, for: .selected)
        temp.setTitle("个人", for: .normal)
        temp.layer.cornerRadius = kBtnCornerR
        if UserInfo.share.is_business {
            temp.backgroundColor = UIColor.white
            temp.layer.borderWidth = 1
            temp.layer.borderColor = kTextBlackColor.cgColor
        } else {
            temp.backgroundColor = kOrangeDarkColor
            temp.isSelected = true
        }
        return temp
    }()
    private lazy var businessBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontS, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, self, #selector(btnsClick(sender:)))
        temp.setTitleColor(UIColor.white, for: .selected)
        temp.setTitle("企业", for: .normal)
        temp.layer.cornerRadius = kBtnCornerR
        if !UserInfo.share.is_business {
            temp.backgroundColor = UIColor.white
            temp.layer.borderWidth = 1
            temp.layer.borderColor = kTextBlackColor.cgColor
        } else {
            temp.backgroundColor = kOrangeDarkColor
            temp.isSelected = true
        }
        return temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews2()
    }
    
    private func setupViews1() {
        businessBtn.isSelected = true
        businessBtn.backgroundColor = kOrangeDarkColor
        businessBtn.layer.borderWidth = 0
        if UserInfo.share.is_business {
            businessBtn.setTitle("企业", for: .normal)
        } else {
            businessBtn.setTitle("个人", for: .normal)
        }
        self.addSubview(businessBtn)
        _ = businessBtn.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(60)?.heightIs(30)
    }
    
    private func setupViews2() {
        self.addSubview(personBtn)
        self.addSubview(businessBtn)
        _ = businessBtn.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(60)?.heightIs(30)
        _ = personBtn.sd_layout()?.rightSpaceToView(businessBtn, kLeftSpaceL)?.centerYEqualToView(businessBtn)?.widthIs(60)?.heightIs(30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func btnsClick(sender: UIButton) {
        if sender.isSelected {
            return
        }
        var isBusiness = false
        if sender.isEqual(businessBtn) {
            isBusiness = true
            businessBtn.isSelected = true
            businessBtn.backgroundColor = kOrangeDarkColor
            businessBtn.layer.borderWidth = 0
            personBtn.isSelected = false
            personBtn.backgroundColor = UIColor.white
            personBtn.layer.borderWidth = 1
            personBtn.layer.borderColor = kTextBlackColor.cgColor
        } else {
            personBtn.isSelected = true
            personBtn.backgroundColor = kOrangeDarkColor
            personBtn.layer.borderWidth = 0
            businessBtn.isSelected = false
            businessBtn.backgroundColor = UIColor.white
            businessBtn.layer.borderWidth = 1
            businessBtn.layer.borderColor = kTextBlackColor.cgColor
        }
        self.delegate?.invoiceHeadTypeCellClick(isBusiness: isBusiness)
    }
}
