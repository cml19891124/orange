//
//  JPWPayCell.swift
//  OLegal
//
//  Created by lh on 2018/11/28.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class JPWPayCell: BaseCell {
    
    let titleBtn: UIButton = UIButton.init(kFontM, kTextBlackColor, UIControl.ContentHorizontalAlignment.left, nil, nil)
    let selBtn: UIButton = UIButton.init(kFontM, kTextBlackColor, UIControl.ContentHorizontalAlignment.right, nil, nil)
    private let line: UIView = UIView.init(lineColor: kLineGrayColor)
    
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
        
        self.addSubview(titleBtn)
        self.addSubview(selBtn)
        self.addSubview(line)
        
        _ = titleBtn.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.centerYEqualToView(self)?.rightSpaceToView(self, 80)?.heightIs(40)
        _ = selBtn.sd_layout()?.rightSpaceToView(self, kLeftSpaceL)?.centerYEqualToView(self)?.widthIs(30)?.heightIs(30)
        _ = line.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.bottomEqualToView(self)?.heightIs(kLineHeight)
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
