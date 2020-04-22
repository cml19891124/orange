//
//  ZZBusinessTypeCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 企业定制类型
class ZZBusinessTypeCell: BaseCell {
    
    private lazy var imgBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, nil, nil)
        return temp
    }()
    private let titleLab: UILabel = UILabel.init(kFontM, kTextBlackColor, NSTextAlignment.left)
    let desLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        imgBtn.setImage(UIImage.init(named: "business_explain"), for: .normal)
        titleLab.text = L$("business_explain")
        
        self.addSubview(imgBtn)
        self.addSubview(titleLab)
        self.addSubview(desLab)
        
        _ = imgBtn.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, 15)?.widthIs(40)?.heightIs(40)
        _ = titleLab.sd_layout()?.leftSpaceToView(imgBtn, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.topEqualToView(imgBtn)?.heightIs(20)
        _ = desLab.sd_layout()?.leftEqualToView(titleLab)?.rightEqualToView(titleLab)?.topSpaceToView(titleLab, 0)?.bottomSpaceToView(self, 15)
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
