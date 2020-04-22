//
//  ZZBusinessFileAddCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/21.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 企业定制附件添加Cell
class ZZBusinessFileAddCell: BaseCell {

    private let btn: UIButton = UIButton.init(kFontMS, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, nil, nil)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(btn)
        let showStr = kBtnSpaceString + "点击添加附件"
        btn.setTitle(showStr, for: .normal)
        btn.setImage(UIImage.init(named: "calculate_add")?.changeImgBackgroundColor(color: kTextBlackColor), for: .normal)
        _ = btn.sd_layout()?.centerXEqualToView(self)?.centerYEqualToView(self)?.widthIs(200)?.heightIs(30)
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
