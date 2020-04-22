//
//  ChatBubbleImgView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/10.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol ChatBubbleImgViewDelegate: NSObjectProtocol {
    func chatBubbleImgViewWithDrew(msg: STMessage)
}

/// 聊天气泡
class ChatBubbleImgView: UIImageView {
    
    var msg: STMessage! {
        didSet {
            if msg.bodyType == .image || msg.bodyType == .file {
                self.addGestureRecognizer(tap)
            }
            self.addGestureRecognizer(press)
        }
    }
    weak var delegate: ChatBubbleImgViewDelegate?
    
    /// 下载进度显示
    private lazy var progressV: ProgressView = {
        () -> ProgressView in
        let temp = ProgressView.init(frame: CGRect.init(x: 0, y: 0, width: 38, height: 50))
        self.addSubview(temp)
        var space = kBubbleSpaceL
        if msg.fromMe {
            space = kBubbleSpaceS
        }
        _ = temp.sd_layout()?.leftSpaceToView(self, space + 6)?.centerYEqualToView(self)?.widthIs(38)?.heightIs(50)
        return temp
    }()
    private lazy var tap: UITapGestureRecognizer = {
        () -> UITapGestureRecognizer in
        let temp = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        return temp
    }()
    private lazy var press: UILongPressGestureRecognizer = {
        () -> UILongPressGestureRecognizer in
        let temp = UILongPressGestureRecognizer.init(target: self, action: #selector(pressClick(press:)))
        return temp
    }()
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    convenience init(isUserInteractionEnabled: Bool) {
        self.init()
        self.isUserInteractionEnabled = true
    }
    
    @objc private func tapClick() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_chat_hangeup_keyboard), object: nil)
        if msg.bodyType == .image { /// 图片点击
            let body = msg.body as! STImageMessageBody
            if body.is_gif {
                let vc = GifBrowserController()
                vc.currentNavigationBarAlpha = 0
                vc.transitionType = .image
                vc.msg = msg
                JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = ImgBrowserController()
                vc.currentNavigationBarAlpha = 0
                vc.transitionType = .image
                vc.msg = msg
                JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
            }
        } else if msg.bodyType == .file { // 文件点击
            let body = msg.body as! STFileMessageBody
            let extM = self.msg.j_model.attributeModel
            let fileM = JFileModel.init(remotePath: body.remotePath, name: body.name, fileSize: extM.msg_file_length)
            if msg.fromMe {
                let localPath = JPhotoManager.share.uploadPath(path: msg.j_model.j_path)
                let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: localPath), options: Data.ReadingOptions.mappedIfSafe)
                if data != nil {
                    self.jumpPreviewVC(path: localPath)
                    return
                }
            }
            weak var weakSelf = self
            fileM.progress = { (value) in
                if body.remotePath == fileM.remotePath {
                    weakSelf?.progressV.progress = value
                    weakSelf?.progressV.isHidden = false
                }
            }
            fileM.success = { (endPath) in
                weakSelf?.progressV.isHidden = true
                if (endPath.haveTextStr()) {
                    weakSelf?.jumpPreviewVC(path: OSSManager.initWithShare().savePath(fileM.localPath))
                }
            }
            let tempPath = JFileManager.share.alreadyExist(remotePath: fileM.remotePath)
            if tempPath != nil {
                self.jumpPreviewVC(path: OSSManager.initWithShare().savePath(tempPath!))
            } else {
                JFileManager.share.addTask(model: fileM)
            }
        }
    }
    
    /// 文件内容预览
    private func jumpPreviewVC(path: String) {
        let vc = JFilePreviewController()
        vc.path = path
        JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 长按事件
    @objc private func pressClick(press: UILongPressGestureRecognizer) {
        if press.state != .began {
            return
        }
        if msg.status != .success && msg.bodyType != .text {
            return
        }
        let menu = UIMenuController.shared
        if menu.isMenuVisible {
            return
        }
        self.becomeFirstResponder()
        let itemCopy = UIMenuItem.init(title: L$("copy"), action: #selector(mCopy))
        let itemWithdrew = UIMenuItem.init(title: L$("withdrew"), action: #selector(mWithdrew))
        var tempArr: [UIMenuItem] = [UIMenuItem]()
        if msg.bodyType == .text {
            tempArr.append(itemCopy)
            if msg.canWithdrew {
                tempArr.append(itemWithdrew)
            }
        } else if msg.bodyType == .bigEmo {
            if msg.canWithdrew {
                tempArr.append(itemWithdrew)
            }
        } else if msg.bodyType == .image {
            if msg.canWithdrew {
                tempArr.append(itemWithdrew)
            }
        } else if msg.bodyType == .file {
            if msg.canWithdrew {
                tempArr.append(itemWithdrew)
            }
        }
        menu.menuItems = tempArr
        menu.setTargetRect(self.bounds, in: self)
        menu.setMenuVisible(true, animated: true)
    }
    
    /// 文本复制
    @objc private func mCopy() {
        let past = UIPasteboard.general
        past.string = msg.content
    }
    
    /// 消息撤回
    @objc private func mWithdrew() {
        self.delegate?.chatBubbleImgViewWithDrew(msg: msg)
    }

}
