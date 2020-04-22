//
//  InvoiceApplyCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

protocol InvoiceApplyCellDelegate: NSObjectProtocol {
    func invoiceApplyCellSelected()
}

class InvoiceApplyCell: BaseCell {
    
    var model: InvoiceListModel! {
        didSet {
            titleLab.text = model.title
            snLab.text = "订单号：" + model.order_sn
            timeLab.text = "交易日期：" + model.created_at.theDateYMDHMSStrFromNumStr()
            priceLab.text = "¥" + model.amount
            selBtn.isSelected = model.isSelected
        }
    }
    weak var delegate: InvoiceApplyCellDelegate?
    
    private lazy var selBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton()
        temp.setImage(UIImage.init(named: "pay_circle_normal"), for: .normal)
        temp.setImage(UIImage.init(named: "pay_circle_selected"), for: .selected)
        temp.imageEdgeInsets = UIEdgeInsets.init(top: 2, left: 2, bottom: 2, right: 2)
        temp.addTarget(self, action: #selector(selBtnClick), for: .touchUpInside)
        return temp
    }()
    private let titleLab: UILabel = UILabel.init(kFontM, kTextBlackColor, NSTextAlignment.left)
    private let snLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.left)
    private let timeLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.left)
    private let priceLab: UILabel = UILabel.init(kFontL, kOrangeDarkColor, NSTextAlignment.right)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        self.addSubview(selBtn)
        self.addSubview(titleLab)
        self.addSubview(snLab)
        self.addSubview(timeLab)
        self.addSubview(priceLab)
        
        _ = titleLab.sd_layout()?.topSpaceToView(self, kLeftSpaceS)?.leftSpaceToView(self, 50)?.rightSpaceToView(self, 100)?.heightIs(30)
        _ = selBtn.sd_layout()?.centerYEqualToView(titleLab)?.leftSpaceToView(self, 18)?.widthIs(23)?.heightIs(23)
        _ = priceLab.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(titleLab)?.widthIs(120)?.heightIs(30)
        _ = snLab.sd_layout()?.leftEqualToView(titleLab)?.rightSpaceToView(self, kLeftSpaceS)?.topSpaceToView(titleLab, 0)?.heightIs(20)
        _ = timeLab.sd_layout()?.leftEqualToView(snLab)?.rightEqualToView(snLab)?.topSpaceToView(snLab, 0)?.heightIs(20)
    }
    
    @objc private func selBtnClick() {
        selBtn.isSelected = !selBtn.isSelected
        model.isSelected = selBtn.isSelected
        self.delegate?.invoiceApplyCellSelected()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
