//
//  ChatLeftImgCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/4.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class ChatLeftImgCell: ChatLeftBaseCell {
    
    override var msg: STMessage! {
        didSet {
            self.j_protocol?.chatBaseCellImg(imgView: imgView, tempMsg: msg)
        }
    }
    
    private let imgView: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFill)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imgView.backgroundColor = UIColor.clear
        bubbleImgView.addSubview(imgView)
        _ = imgView.sd_layout()?.leftSpaceToView(bubbleImgView, kBubbleSpaceL)?.topSpaceToView(bubbleImgView, kBubbleSpaceS)?.rightSpaceToView(bubbleImgView, kBubbleSpaceS)?.bottomSpaceToView(bubbleImgView, kBubbleSpaceS)
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
