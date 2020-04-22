//
//  ConsultReminderCell.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 我要咨询温馨提示语
class ConsultReminderCell: BaseCell {
    
    var reminder: String! {
        didSet {
            desLab.text = reminder
        }
    }
    
    var titleStr: String! {
        didSet {
            titleBtn.setTitle(kBtnSpaceString + titleStr, for: .normal)
        }
    }
    
    private lazy var titleBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontM, kTextBlackColor, UIControl.ContentHorizontalAlignment.left, nil, nil)
        temp.setImage(UIImage.reminderImage(), for: .normal)
        return temp
    }()
    private let desLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(titleBtn)
        self.addSubview(desLab)
        _ = titleBtn.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.heightIs(20)
        _ = desLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.topSpaceToView(titleBtn, kLeftSpaceS)?.rightSpaceToView(self,kLeftSpaceS)?.bottomSpaceToView(self, kLeftSpaceS)
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
