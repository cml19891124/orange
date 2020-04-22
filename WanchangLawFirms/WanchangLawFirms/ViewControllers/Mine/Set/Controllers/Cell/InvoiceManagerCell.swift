//
//  InvoiceManagerCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class InvoiceManagerCell: BaseCell {
    
    var model: InvoiceListModel! {
        didSet {
            companyLab.text = model.head_name
            priceLab.text = "¥" + model.amount
            timeLab.text = model.created_at.theDateYMDHMSStrFromNumStr()
            if model.status == "0" {
                statusBtn.setTitle("未处理", for: .normal)
            } else if model.status == "1" {
                statusBtn.setTitle("处理中", for: .normal)
            } else if model.status == "2" {
                statusBtn.setTitle("已开票", for: .normal)
            } else if model.status == "3" {
                statusBtn.setTitle("失败", for: .normal)
            }
        }
    }
    
    private let companyLab: UILabel = UILabel.init(kFontM, kTextBlackColor, NSTextAlignment.left)
    private let priceLab: UILabel = UILabel.init(kFontM, kOrangeDarkColor, NSTextAlignment.left)
    private let timeLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.left)
    private let statusBtn: CCWatchDetailBtn = CCWatchDetailBtn.init(bindStr: "m_invoice_opened")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        self.addSubview(companyLab)
        self.addSubview(priceLab)
        self.addSubview(timeLab)
        self.addSubview(statusBtn)
        _ = companyLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, 80)?.heightIs(30)
        _ = priceLab.sd_layout()?.leftEqualToView(companyLab)?.rightEqualToView(companyLab)?.topSpaceToView(companyLab, 0)?.heightIs(20)
        _ = timeLab.sd_layout()?.leftEqualToView(companyLab)?.rightEqualToView(companyLab)?.topSpaceToView(priceLab, 0)?.heightIs(20)
        _ = statusBtn.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(companyLab)?.widthIs(statusBtn.bind_width)?.heightIs(statusBtn.bind_height)
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
