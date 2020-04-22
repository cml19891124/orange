//
//  ChatLabCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/10.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 例如：撤回消息提示
class ChatLabCell: UITableViewCell {
    
    var showStr: String? {
        didSet {
            lab.text = showStr
            let w = lab.sizeThatFits(CGSize.init(width: kDeviceWidth - kLeftSpaceL * 2, height: 20)).width + kLeftSpaceL
            lab.frame = CGRect.init(x: (kDeviceWidth - w) / 2, y: 5, width: w, height: 20)
        }
    }
    
    private let lab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.center)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = kBaseColor
        self.selectionStyle = .none
        lab.backgroundColor = UIColor.white
        lab.layer.cornerRadius = kBtnCornerR
        lab.clipsToBounds = true
        self.addSubview(lab)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
