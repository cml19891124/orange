//
//  ChatBaseCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/4.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import WebKit

protocol ChatBaseCellProtocol: NSObjectProtocol {
    func chatBaseCellText(contentLab: LLabel)
    func chatBaseCellImg(imgView: UIImageView, tempMsg: STMessage)
    func chatBaseCellBigEmo(imgView: FLAnimatedImageView, tempMsg: STMessage)
    func chatBaseCellFile(fileLogoBtn: UIButton, fileNameLab: UILabel, fileSizeLab: UILabel)
    func chatBaseCellGif(imgView: FLAnimatedImageView, tempMsg: STMessage)
}

/// 聊天Cell基类
class ChatBaseCell: BaseCell {
    
    var msg: STMessage! {
        didSet {
            self.bubbleImgView.msg = msg
        }
    }
    weak var j_protocol: ChatBaseCellProtocol?
    let avatarImgView: JAvatarImgView = JAvatarImgView.init(cornerRadius: kAvatarWH / 2)
    let nameLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.left)
    let bubbleImgView: ChatBubbleImgView = ChatBubbleImgView.init(isUserInteractionEnabled: true)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        bubbleImgView.backgroundColor = UIColor.clear
        self.addSubview(avatarImgView)
        self.addSubview(nameLab)
        self.addSubview(bubbleImgView)
        self.j_protocol = self
        
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

extension ChatBaseCell: ChatBaseCellProtocol {
    /// 文本消息
    func chatBaseCellText(contentLab: LLabel) {
        let body = msg.body as! STTextMessageBody
        contentLab.text = body.text
        if msg.size.width == kBubbleWidthMin {
            contentLab.textAlignment = .center
        } else {
            contentLab.textAlignment = .left
        }
        if msg.j_model.attributeModel.autoReplyArr.count > 0 {
            for i in 0..<msg.j_model.attributeModel.autoReplyArr.count {
                let m = msg.j_model.attributeModel.autoReplyArr[i]
                let tempStr = "· " + m.keyword
                contentLab.addClickText(str: tempStr, original_color: kOrangeDarkColor, click_color: kOrangeDarkClickColor)
            }
        }
    }
    
    /// 图片消息
    func chatBaseCellImg(imgView: UIImageView, tempMsg: STMessage) {
        let body = tempMsg.body as! STImageMessageBody
        if msg.status == .success {
            if tempMsg.j_oss_snap_url.haveTextStr() {
                imgView.sd_setImage(with: URL.init(string: tempMsg.j_oss_snap_url), completed: nil)
            } else {
                let urlStr = OSSManager.initWithShare().allSnapUrlStr(by: body.remotePath)
                if tempMsg.fromMe {
                    let tempImg = UIImage.init(contentsOfFile: JPhotoManager.share.uploadPath(path: body.path))
                    imgView.sd_setImage(with: URL.init(string: urlStr), placeholderImage: tempImg, options: SDWebImageOptions.highPriority) { (img, err, type, url) in
                        if img != nil {
                            tempMsg.updateImgMsgOssUrl(is_snap: true, oss_url: urlStr)
                            let d = img?.jpegData(compressionQuality: 0.9)
                            try? d?.write(to: URL.init(fileURLWithPath: JPhotoManager.share.cachePath(path: tempMsg.j_model.id)))
                            if tempMsg.id != self.msg.id {
                                let cur_body = self.msg.body as! STImageMessageBody
                                imgView.image = UIImage.init(contentsOfFile: JPhotoManager.share.uploadPath(path: cur_body.path))
                            }
                        }
                    }
                } else {
                    imgView.sd_setImage(with: URL.init(string: urlStr)) { (img, err, type, url) in
                        if img != nil {
                            tempMsg.updateImgMsgOssUrl(is_snap: true, oss_url: urlStr)
                            let d = img?.jpegData(compressionQuality: 0.9)
                            try? d?.write(to: URL.init(fileURLWithPath: JPhotoManager.share.cachePath(path: tempMsg.j_model.id)))
                        }
                    }
                }
            }
        } else {
            imgView.image = UIImage.init(contentsOfFile: JPhotoManager.share.uploadPath(path: body.path))
        }
    }
    
    /// gif消息
    func chatBaseCellGif(imgView: FLAnimatedImageView, tempMsg: STMessage) {
        let first_data = try? Data.init(contentsOf: URL.init(fileURLWithPath: JPhotoManager.share.cachePath(path: tempMsg.j_model.id)))
        if first_data == nil {
            imgView.image = UIImage.init(named: "gif_placeholder")
        } else {
            imgView.image = UIImage.init(data: first_data!)
        }
        let body = tempMsg.body as! STImageMessageBody
        weak var weakSelf = self
        if tempMsg.fromMe {
            JQueueManager.share.globalAsyncQueue {
                let endPath = JPhotoManager.share.uploadPath(path: body.path)
                let url = URL.init(fileURLWithPath: endPath)
                let data = try? Data.init(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
                if data != nil {
                    let animatedImage = FLAnimatedImage.init(animatedGIFData: data)
                    if tempMsg.id == weakSelf?.msg.id {
                        let d = animatedImage?.posterImage.jpegData(compressionQuality: 0.9)
                        try? d?.write(to: URL.init(fileURLWithPath: JPhotoManager.share.cachePath(path: tempMsg.j_model.id)))
                        JQueueManager.share.mainAsyncQueue {
                            imgView.animatedImage = animatedImage
                        }
                    }
                } else {
                    OSSManager.initWithShare().downloadImage(body.remotePath, progress: { (pro) in
                        
                    }) { (endPath) in
                        if endPath.haveTextStr() {
                            JQueueManager.share.globalAsyncQueue {
                                let url = URL.init(fileURLWithPath: endPath)
                                let data = try? Data.init(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
                                let animatedImage = FLAnimatedImage.init(animatedGIFData: data)
                                if tempMsg.id == weakSelf?.msg.id {
                                    let d = animatedImage?.posterImage.jpegData(compressionQuality: 0.9)
                                    try? d?.write(to: URL.init(fileURLWithPath: JPhotoManager.share.cachePath(path: tempMsg.j_model.id)))
                                    JQueueManager.share.mainAsyncQueue {
                                        imgView.animatedImage = animatedImage
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            OSSManager.initWithShare().downloadImage(body.remotePath, progress: { (pro) in
                
            }) { (endPath) in
                if endPath.haveTextStr() {
                    JQueueManager.share.globalAsyncQueue {
                        let url = URL.init(fileURLWithPath: endPath)
                        let data = try? Data.init(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
                        let animatedImage = FLAnimatedImage.init(animatedGIFData: data)
                        if tempMsg.id == weakSelf?.msg.id {
                            let d = animatedImage?.posterImage.jpegData(compressionQuality: 0.9)
                            try? d?.write(to: URL.init(fileURLWithPath: JPhotoManager.share.cachePath(path: tempMsg.j_model.id)))
                            JQueueManager.share.mainAsyncQueue {
                                imgView.animatedImage = animatedImage
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    /// 大表情消息
    func chatBaseCellBigEmo(imgView: FLAnimatedImageView, tempMsg: STMessage) {
        let body = tempMsg.body as! STBigEmoMessageBody
        let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: body.text, ofType: "gif")!))
        let animatedImage = FLAnimatedImage.init(animatedGIFData: data)
        imgView.animatedImage = animatedImage
    }
    
    /// 文件消息
    func chatBaseCellFile(fileLogoBtn: UIButton, fileNameLab: UILabel, fileSizeLab: UILabel) {
        let body = msg.body as! STFileMessageBody
        let fileLogoImgName = JFileManager.share.getFileImgName(remotePath: body.remotePath)
        fileLogoBtn.setImage(UIImage.init(named: fileLogoImgName), for: .normal)
        fileNameLab.text = body.name
        fileSizeLab.text = JPhotoManager.share.lengthStrFrom(length: msg.fileLength)
    }
}


