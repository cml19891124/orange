//
//  MineConsumeCell.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class MineConsumeCell: BaseCell {
    
    var model: MineConsumeModel! {
        didSet {
            typeLab.text = model.title
            timeLab.text = model.created_at.theDateYMDStr()
            priceLab.text = "-¥" + model.amount
            titleBtn.setImage(UIImage.init(named: HomeManager.share.logoImgNameBy(title: model.title)), for: .normal)
        }
    }
    
    private let titleBtn: UIButton = UIButton.init(kFontMS, UIColor.clear, UIControl.ContentHorizontalAlignment.center, nil, nil)
    private let typeLab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
    private let timeLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.left)
    private let priceLab: UILabel = UILabel.init(kFontM, kOrangeLightColor, NSTextAlignment.right)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(titleBtn)
        self.addSubview(typeLab)
        self.addSubview(timeLab)
        self.addSubview(priceLab)
        
        _ = titleBtn.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(40)?.heightIs(40)
        _ = typeLab.sd_layout()?.leftSpaceToView(titleBtn, kLeftSpaceS)?.topEqualToView(titleBtn)?.widthIs(150)?.heightIs(20)
        _ = timeLab.sd_layout()?.leftEqualToView(typeLab)?.rightEqualToView(typeLab)?.topSpaceToView(typeLab, 0)?.heightIs(20)
        _ = priceLab.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(150)?.heightIs(30)
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
