//
//  CLSQuestionCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/20.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 客服常见问题Cell
class CLSQuestionCell: BaseCell {
    
    var keyword: String = "" {
        didSet {
            lab.textColor = kOrangeDarkColor
            lab.text = "· " + keyword
        }
    }
    
    let lab: UILabel = UILabel.init(UserInfo.share.chatFont, kOrangeDarkColor, NSTextAlignment.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(lab)
        _ = lab.sd_layout()?.leftSpaceToView(self, 0)?.rightSpaceToView(self, 0)?.topSpaceToView(self, 0)?.bottomSpaceToView(self, 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        if selected {
//            self.lab.textColor = kOrangeDarkClickColor
//        } else {
//            self.lab.textColor = kOrangeDarkColor
//        }
//    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            self.lab.textColor = kOrangeDarkClickColor
        } else {
            self.lab.textColor = kOrangeDarkColor
        }
    }
    
    

}
