//
//  ChatRightBaseCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/4.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol ChatRightBaseCellDelegate: NSObjectProtocol {
    func chatRightBaseCellReSend(msg: STMessage)
}

/// 聊天页右边基类
class ChatRightBaseCell: ChatBaseCell {
    
    weak var delegate: ChatRightBaseCellDelegate?
    override var msg: STMessage! {
        didSet {
            NotificationCenter.default.removeObserver(self)
            if msg.status != .success {
                NotificationCenter.default.addObserver(self, selector: #selector(msgReturn), name: NSNotification.Name(rawValue: msg.id + "_return"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(msgFailed), name: NSNotification.Name(rawValue: msg.id + "_failed"), object: nil)
            }
            if !msg.isRead {
                NotificationCenter.default.addObserver(self, selector: #selector(msgRead), name: NSNotification.Name(rawValue: msg.sn + "_read"), object: nil)
            }
            
            self.bubbleImgView.frame = CGRect.init(x: kDeviceWidth - kLeftSpaceS - msg.size.width - kAvatarWH - 5, y: 20, width: msg.size.width, height: msg.size.height)
            switch msg.status {
            case .develing:
                self.status_develing()
                break
            case .success:
                self.status_success()
                break
            case .failed:
                self.status_failed()
                break
            }
        }
    }
    
    private lazy var actIndicator: UIActivityIndicatorView = {
        () -> UIActivityIndicatorView in
        let temp = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.gray)
        temp.isHidden = true
        self.addSubview(temp)
        return temp
    }()
    private lazy var failBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton()
        temp.setImage(UIImage.init(named: "msg_send_fail"), for: .normal)
        temp.addTarget(self, action: #selector(reSendClick), for: .touchUpInside)
        self.addSubview(temp)
        return temp
    }()
    private lazy var readLab: UILabel = {
        () -> UILabel in
        let temp = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.right)
        self.addSubview(temp)
        return temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.nameLab.textAlignment = .right
        if UserInfo.share.is_business {
            self.nameLab.text = UserInfo.share.model?.username
        } else {
            self.nameLab.text = UserInfo.share.model?.j_name
        }
        self.avatarImgView.isMe = true
        self.avatarImgView.avatar = UserInfo.share.model?.avatar
        
        self.bubbleImgView.image = UIImage.init(named: "chat_bubble_right")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 23, left: 8, bottom: 8, right: 15), resizingMode: .stretch)
        _ = self.avatarImgView.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, 10)?.widthIs(kAvatarWH)?.heightIs(kAvatarWH)
        _ = self.nameLab.sd_layout()?.rightSpaceToView(avatarImgView, kLeftSpaceS)?.topSpaceToView(self, 0)?.leftSpaceToView(self, 50)?.heightIs(20)
        _ = actIndicator.sd_layout()?.rightSpaceToView(self.bubbleImgView, kLeftSpaceS)?.topSpaceToView(self, kLeftSpaceS + 20)?.widthIs(20)?.heightIs(20)
        _ = failBtn.sd_layout()?.rightSpaceToView(self.bubbleImgView, kLeftSpaceS)?.topSpaceToView(self, kLeftSpaceS + 20)?.widthIs(20)?.heightIs(20)
        _ = readLab.sd_layout()?.rightSpaceToView(self.bubbleImgView, kLeftSpaceS)?.topSpaceToView(self, kLeftSpaceS + 20)?.widthIs(100)?.heightIs(20)
    }
    
    func recordHide() {
        self.readLab.isHidden = true
        self.actIndicator.isHidden = true
        self.actIndicator.stopAnimating()
        self.failBtn.isHidden = true
    }
    
    private func status_develing() {
        self.actIndicator.isHidden = false
        self.actIndicator.startAnimating()
        self.failBtn.isHidden = true
        self.readLab.isHidden = true
    }
    
    private func status_success() {
        self.actIndicator.stopAnimating()
        self.actIndicator.isHidden = true
        self.failBtn.isHidden = true
        self.readLab.isHidden = true
        if msg.j_model.sn.count > 0 {
            self.readLab.isHidden = false
            if msg.isRead {
                self.readLab.text = L$("read")
            } else {
                self.readLab.text = L$("unRead")
            }
        }
    }
    
    private func status_failed() {
        self.actIndicator.stopAnimating()
        self.actIndicator.isHidden = true
        self.readLab.isHidden = true
        self.failBtn.isHidden = false
    }
    
    @objc private func msgReturn() {
        JQueueManager.share.mainAsyncQueue {
            self.status_success()
        }
    }
    
    @objc private func msgRead() {
        if msg.status == .success {
            self.status_success()
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    @objc private func msgFailed() {
        JQueueManager.share.mainAsyncQueue {
            self.status_failed()
        }
    }
    
    @objc private func reSendClick() {
        JAuthorizeManager.init(view: self).alertController(style: .alert, titleStr: L$("re_send"), message: nil, sure: L$("sure"), cancel: L$("cancel"), sureHandler: { (action) in
            self.msg.updateMsgStatus(status: "0")
            if self.msg.bodyType == .text || self.msg.bodyType == .bigEmo {
                ChatManager.share.addChatFileMsgArr(msgArr: [self.msg])
            } else if self.msg.bodyType == .image {
                ChatManager.share.addChatImageMsgArr(msgArr: [self.msg])
            } else if self.msg.bodyType == .file {
                let endPath = JPhotoManager.share.uploadPath(path: self.msg.j_model.j_path)
                let url = URL.init(fileURLWithPath: endPath)
                let data = try? Data.init(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
                if data == nil {
                    ChatManager.share.addChatFileMsgArr(msgArr: [self.msg])
                } else {
                    ChatManager.share.addChatImageMsgArr(msgArr: [self.msg])
                }
            }
            self.status_develing()
            self.delegate?.chatRightBaseCellReSend(msg: self.msg)
        }, cancelHandler: nil)
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
