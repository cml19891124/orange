//
//  ChatRightFileCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/7.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class ChatRightFileCell: ChatRightBaseCell {
    
    override var msg: STMessage! {
        didSet {
            self.j_protocol?.chatBaseCellFile(fileLogoBtn: fileLogoBtn, fileNameLab: fileNameLab, fileSizeLab: fileSizeLab)
        }
    }
    
    private let fileLogoBtn: UIButton = UIButton()
    private let fileNameLab: UILabel = UILabel.init(kFontMS, UIColor.white, NSTextAlignment.left)
    private let fileSizeLab: UILabel = UILabel.init(kFontS, UIColor.white, NSTextAlignment.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        fileLogoBtn.isUserInteractionEnabled = false
        fileNameLab.adjustsFontSizeToFitWidth = false
        fileNameLab.lineBreakMode = .byTruncatingMiddle
        
        bubbleImgView.addSubview(fileLogoBtn)
        bubbleImgView.addSubview(fileNameLab)
        bubbleImgView.addSubview(fileSizeLab)
        
        _ = fileLogoBtn.sd_layout()?.leftSpaceToView(bubbleImgView, kBubbleSpaceS)?.centerYEqualToView(bubbleImgView)?.widthIs(50)?.heightIs(50)
//        _ = fileNameLab.sd_layout()?.leftSpaceToView(fileLogoBtn, kLeftSpaceSS)?.rightSpaceToView(bubbleImgView, kBubbleSpaceL)?.topEqualToView(fileLogoBtn)?.bottomSpaceToView(bubbleImgView, kBubbleSpaceS)
        _ = fileNameLab.sd_layout()?.leftSpaceToView(fileLogoBtn, kLeftSpaceSS)?.rightSpaceToView(bubbleImgView, kBubbleSpaceL)?.topEqualToView(fileLogoBtn)?.heightIs(38)
        _ = fileSizeLab.sd_layout()?.leftEqualToView(fileNameLab)?.rightEqualToView(fileNameLab)?.topSpaceToView(fileNameLab, 0)?.heightIs(12)
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
