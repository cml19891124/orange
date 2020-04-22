//
//  ChatRightBigEmoCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/4.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import WebKit

class ChatRightBigEmoCell: ChatRightBaseCell {
    
    override var msg: STMessage! {
        didSet {
            self.j_protocol?.chatBaseCellBigEmo(imgView: imgView, tempMsg: msg)
        }
    }
    
    private lazy var imgView: FLAnimatedImageView = {
        () -> FLAnimatedImageView in
        let temp = FLAnimatedImageView()
        temp.backgroundColor = UIColor.clear
        temp.contentMode = .scaleAspectFit
        return temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bubbleImgView.image = nil
        bubbleImgView.backgroundColor = UIColor.clear
        bubbleImgView.addSubview(imgView)
        _ = imgView.sd_layout()?.leftSpaceToView(bubbleImgView, 0)?.topSpaceToView(bubbleImgView, 0)?.rightSpaceToView(bubbleImgView, kBubbleSpaceS)?.bottomSpaceToView(bubbleImgView, 0)
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
