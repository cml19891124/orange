//
//  ZZBusinessFileCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/21.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 企业定制附件
class ZZBusinessFileCell: BaseCell {
    
    weak var delegate: JFileCellDelegate?
    var model: JFileModel! {
        didSet {
            logoBtn.setImage(UIImage.init(named: model.imgName), for: .normal)
            fileNameLab.text = model.localPath
            fileSizeLab.text = JPhotoManager.share.lengthStrFrom(length: Int(model.fileSize))
            selBtn.isSelected = model.selected
        }
    }
    
    private let selBtn: UIButton = UIButton()
    private let logoBtn: UIButton = UIButton.init(kFontMS, kTextBlackColor, UIControl.ContentHorizontalAlignment.left, nil, nil)
    private let fileNameLab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
    private let fileSizeLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    private let line: UIView = UIView.init(lineColor: kLineGrayColor)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selBtn.setImage(UIImage.init(named: "cross_gray"), for: .normal)
        selBtn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        fileNameLab.lineBreakMode = .byTruncatingMiddle
        fileNameLab.adjustsFontSizeToFitWidth = false
        self.addSubview(logoBtn)
        self.addSubview(fileNameLab)
        self.addSubview(fileSizeLab)
        self.addSubview(selBtn)
        self.addSubview(line)
        _ = logoBtn.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.centerYEqualToView(self)?.widthIs(50)?.heightIs(50)
        _ = fileNameLab.sd_layout()?.leftSpaceToView(logoBtn, kLeftSpaceS)?.topEqualToView(logoBtn)?.rightSpaceToView(self, 70)?.heightIs(38)
        _ = fileSizeLab.sd_layout()?.leftEqualToView(fileNameLab)?.rightEqualToView(fileNameLab)?.topSpaceToView(fileNameLab, 0)?.heightIs(12)
        _ = selBtn.sd_layout()?.rightSpaceToView(self, 0)?.centerYEqualToView(self)?.widthIs(70)?.heightIs(70)
        _ = line.sd_layout()?.rightSpaceToView(self, 69)?.centerYEqualToView(self)?.widthIs(1)?.heightIs(50)
    }
    
    @objc private func btnClick(sender: UIButton) {
        self.delegate?.jFileCellSelectClick(sender: sender, model: model)
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
