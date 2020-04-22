//
//  JBVCell.swift
//  OLegal
//
//  Created by lh on 2018/11/28.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class JBVCell: BaseCell {
    
    var model: JVipListModel! {
        didSet {
            titleLab.text = model.vip_name
            priceLab.text = "¥" + model.price
            desLab.text = model.vip_info
            timeBtn.setTitle(model.j_time_str, for: .normal)
            _ = timeBtn.sd_layout()?.leftSpaceToView(titleLab, 0)?.centerYEqualToView(titleLab)?.widthIs(timeBtn.bind_width)?.heightIs(timeBtn.bind_height)
        }
    }
    
    let titleLab: UILabel = UILabel.init(kFontM, kTextBlackColor, NSTextAlignment.left)
    let timeBtn: CCWatchDetailBtn = CCWatchDetailBtn.init(bindStr: "")
    let priceLab: UILabel = UILabel.init(kFontM, kOrangeDarkColor, NSTextAlignment.left)
    let desLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.left)
    let selBtn: UIButton = UIButton.init(kFontM, kTextGrayColor, UIControl.ContentHorizontalAlignment.right, nil, nil)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        selBtn.setImage(UIImage.init(named: "pay_circle_normal"), for: .normal)
        selBtn.setImage(UIImage.init(named: "pay_circle_selected"), for: .selected)
        self.addSubview(titleLab)
        self.addSubview(timeBtn)
        self.addSubview(priceLab)
        self.addSubview(desLab)
        self.addSubview(selBtn)
        
        _ = titleLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.topSpaceToView(self, kLeftSpaceL)?.widthIs(80)?.heightIs(30)
        _ = priceLab.sd_layout()?.leftEqualToView(titleLab)?.topSpaceToView(titleLab, 0)?.rightEqualToView(titleLab)?.heightIs(30)
        _ = desLab.sd_layout()?.leftSpaceToView(titleLab, 0)?.topEqualToView(priceLab)?.rightSpaceToView(self, 70)?.bottomSpaceToView(self, kLeftSpaceL)
        _ = selBtn.sd_layout()?.rightSpaceToView(self, kLeftSpaceL)?.centerYEqualToView(titleLab)?.widthIs(30)?.heightIs(30)
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
