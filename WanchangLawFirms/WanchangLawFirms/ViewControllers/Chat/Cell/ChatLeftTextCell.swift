//
//  ChatLeftTextCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/4.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class ChatLeftTextCell: ChatLeftBaseCell {
    override var msg: STMessage! {
        didSet {
            self.j_protocol?.chatBaseCellText(contentLab: contentLab)
        }
    }
    
//    private let contentLab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
    private let contentLab: LLabel = LLabel.init(font: UserInfo.share.chatFont, textAlignment: NSTextAlignment.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentLab.textColor = kTextBlackColor
        contentLab.enableDetector(original_color: customColor(235, 96, 1), click_color: customColor(235, 96, 1, 0.5))
        bubbleImgView.addSubview(contentLab)
        _ = contentLab.sd_layout()?.leftSpaceToView(bubbleImgView, kBubbleSpaceL)?.topSpaceToView(bubbleImgView, kBubbleSpaceS)?.rightSpaceToView(bubbleImgView, kBubbleSpaceS)?.bottomSpaceToView(bubbleImgView, kBubbleSpaceS)
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
