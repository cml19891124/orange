//
//  ChatLeftGifCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/3.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit
import WebKit

class ChatLeftGifCell: ChatLeftBaseCell {

    override var msg: STMessage! {
        didSet {
            self.j_protocol?.chatBaseCellGif(imgView: imgView, tempMsg: msg)
            
            NotificationCenter.default.addObserver(self, selector: #selector(stopAnimate), name: NSNotification.Name(rawValue: noti_chat_tabview_begin_scroll), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(startAnimate), name: NSNotification.Name(rawValue: noti_chat_tabview_end_scroll), object: nil)
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
        _ = imgView.sd_layout()?.leftSpaceToView(bubbleImgView, 0)?.topSpaceToView(bubbleImgView, 0)?.rightSpaceToView(bubbleImgView, 0)?.bottomSpaceToView(bubbleImgView, 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func startAnimate() {
        self.imgView.startAnimating()
    }
    
    @objc private func stopAnimate() {
        self.imgView.stopAnimating()
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
