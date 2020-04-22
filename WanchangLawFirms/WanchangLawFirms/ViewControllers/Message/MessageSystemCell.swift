//
//  MessageSystemCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/17.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 系统消息Cell视图
class MessageSystemCell: BaseCell {
    
    var model: JSocketModel! {
        didSet {
            titleLab.text = model.push_title
            timeLab.text = "\(model.time)".theDateYMDHMSStrFromNumStr()
            contentLab.text = model.content
        }
    }
    
    private let titleLab: UILabel = UILabel.init(kFontM, kTextBlackColor, NSTextAlignment.left)
    private let timeLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.left)
    private let contentLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(titleLab)
        self.addSubview(timeLab)
        self.addSubview(contentLab)
        _ = titleLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.topSpaceToView(self, 0)?.rightSpaceToView(self, 150)?.heightIs(40)
        _ = timeLab.sd_layout()?.leftSpaceToView(titleLab, 0)?.rightSpaceToView(self, kLeftSpaceL)?.topSpaceToView(self, 0)?.heightIs(40)
        _ = contentLab.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.rightSpaceToView(self, kLeftSpaceL)?.topSpaceToView(timeLab, 0)?.bottomSpaceToView(self, kLeftSpaceS)
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
