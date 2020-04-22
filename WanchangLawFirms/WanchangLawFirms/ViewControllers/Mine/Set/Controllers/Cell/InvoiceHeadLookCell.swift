//
//  InvoiceHeadLookCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/25.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

protocol InvoiceHeadLookCellDelegate: NSObjectProtocol {
    func invoiceHeadLookCellEditClick()
}

class InvoiceHeadLookCell: BaseCell {
    
    weak var delegate: InvoiceHeadLookCellDelegate?
    var model: InvoiceHeadListModel! {
        didSet {
            companyLab.text = model.head_name
            typeLab.text = "发票类型：增值税普通发票"
            accountLab.text = "税务登记账号：" + model.head_sn
        }
    }
    
    private let companyLab: UILabel = UILabel.init(kFontM, kTextBlackColor, NSTextAlignment.left)
    private let typeLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.left)
    private let accountLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.left)
    private lazy var moreBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, kOrangeDarkColor, UIControl.ContentHorizontalAlignment.right, self, #selector(moreClick))
        temp.setTitle("编辑", for: .normal)
//        temp.setImage(UIImage.init(named: "chat_more")?.changeImgBackgroundColor(color: kOrangeDarkColor), for: .normal)
//        temp.addTarget(self, action: #selector(moreClick), for: .touchUpInside)
        return temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(companyLab)
        self.addSubview(typeLab)
        self.addSubview(accountLab)
        self.addSubview(moreBtn)
        
        _ = companyLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, 50)?.topSpaceToView(self, kLeftSpaceS)?.heightIs(30)
        _ = typeLab.sd_layout()?.leftEqualToView(companyLab)?.rightEqualToView(companyLab)?.topSpaceToView(companyLab, 0)?.heightIs(20)
        _ = accountLab.sd_layout()?.leftEqualToView(companyLab)?.rightEqualToView(companyLab)?.topSpaceToView(typeLab, 0)?.heightIs(20)
        _ = moreBtn.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(30)?.heightIs(30)
    }
    
    @objc private func moreClick() {
        self.delegate?.invoiceHeadLookCellEditClick()
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
