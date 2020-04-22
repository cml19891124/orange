//
//  ChatController.swift
//  OLegal
//
//  Created by lh on 2018/11/28.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import Photos

/// 聊天页
class ChatController: BaseController {
    
    var model: MessageModel = MessageModel()
    var status: String = "1"
    
    private var questionClicked: Bool = false
    private var keyword: String = ""
    
    private lazy var topH: CGFloat = {
        () -> CGFloat in
        if model.desc.haveContentNet() != true {
            return 0
        }
        var t1: CGFloat = 10
        if status == "1" {
            t1 = 70
        }
        var h = model.desc.height(width: kDeviceWidth - kLeftSpaceS - kLeftSpaceSS - kAvatarWH - 10 - t1, font: kFontMS) + kLeftSpaceS * 2 + 30
        let tabH = kDeviceHeight - kNavHeight - kXBottomHeight - 50
        let goldH = tabH - goldBigHeight(kDeviceHeight - kBarStatusHeight - kXBottomHeight)
        if h > goldH {
            h = goldH
        }
        return h
    }()
    private lazy var topV: ChatQuestionView = {
        () -> ChatQuestionView in
        let temp = ChatQuestionView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: topH))
        model.order_status = status
        temp.model = model
        if topH != 0 {
            self.view.addSubview(temp)
        }
        temp.delegate = self
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(detailTap))
        temp.addGestureRecognizer(tap)
        return temp
    }()
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: topH + kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - kXBottomHeight - 50 - topH), style: .grouped, space: 0)
        temp.backgroundColor = kBaseColor
        temp.separatorStyle = .none
        temp.delegate = self
        temp.dataSource = self
        temp.mj_header = j_header
        temp.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        temp.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        temp.register(ChatLeftTextCell.self, forCellReuseIdentifier: "ChatLeftTextCell")
        temp.register(ChatRightTextCell.self, forCellReuseIdentifier: "ChatRightTextCell")
        temp.register(ChatLeftImgCell.self, forCellReuseIdentifier: "ChatLeftImgCell")
        temp.register(ChatRightImgCell.self, forCellReuseIdentifier: "ChatRightImgCell")
        temp.register(ChatLeftGifCell.self, forCellReuseIdentifier: "ChatLeftGifCell")
        temp.register(ChatRightGifCell.self, forCellReuseIdentifier: "ChatRightGifCell")
        temp.register(ChatLeftBigEmoCell.self, forCellReuseIdentifier: "ChatLeftBigEmoCell")
        temp.register(ChatRightBigEmoCell.self, forCellReuseIdentifier: "ChatRightBigEmoCell")
        temp.register(ChatLeftFileCell.self, forCellReuseIdentifier: "ChatLeftFileCell")
        temp.register(ChatRightFileCell.self, forCellReuseIdentifier: "ChatRightFileCell")
        temp.register(ChatLeftServiceQuestionCell.self, forCellReuseIdentifier: "ChatLeftServiceQuestionCell")
        temp.register(ChatTimeHeaderView.self, forHeaderFooterViewReuseIdentifier: "ChatTimeHeaderView")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        temp.register(ChatLabCell.self, forCellReuseIdentifier: "ChatLabCell")
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var bottomV: ChatBottomView = {
        () -> ChatBottomView in
        let temp = ChatBottomView.init(frame: CGRect.init(x: 0, y: kDeviceHeight - kXBottomHeight - 50, width: kDeviceWidth, height: kXBottomHeight + 50))
        temp.delegate = self
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var j_header: JRefreshHeader = {
        () -> JRefreshHeader in
        let temp = JRefreshHeader.init(refreshingTarget: self, refreshingAction: #selector(loadMessage))
        return temp!
    }()
    private lazy var tabTap: UITapGestureRecognizer = {
        () -> UITapGestureRecognizer in
        let temp = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        return temp
    }()
    private var searchMsgId: String = ""
    private var dataArr: [STMessage] = [STMessage]()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model.updateConversationInputText(text: self.bottomV.tv.text)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bottomV.isHidden = false
        JSocketHelper.share.delegate = self
        ChatManager.share.delegate = self
        JShareMessageTool.share.delegate = self
        self.getDataSource()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "chat_more"), style: .done, target: self, action: #selector(moreClick))
        if model.order_sn.count > 0 {
            
        } else {
            UserInfo.chatOnlineServiceNoti(text: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(dealOrderTransform), name: NSNotification.Name(rawValue: noti_order_transform), object: nil)
    }
    
    private func getDataSource() {
        if UserInfo.share.chat_sn != nil {
            guard let sn = UserInfo.share.chat_sn else {
                self.navigationController?.popViewController(animated: true)
                return
            }
            let prams: NSDictionary = ["order_sn":sn]
            HomeManager.share.orderView(prams: prams) { (m) in
                UserInfo.share.chat_sn = nil
                guard let temp = m else {
                    self.navigationController?.popViewController(animated: true)
                    return
                }
//                UserInfo.share.conversationLoadedAdd(sn: temp.order_sn)
                self.model = temp
                self.dealDataSource()
            }
        } else {
            self.dealDataSource()
        }
    }
    
    @objc private func dealOrderTransform() {
        let prams: NSDictionary = ["order_sn":self.model.order_sn]
        HomeManager.share.orderView(prams: prams) { (m) in
            if m != nil {
                self.model.avatar = m!.avatar
                self.model.name = m!.name
                self.model.id = m!.id
                self.topV.model = self.model
            }
        }
    }
    
    private func dealDataSource() {
        if self.model.product_title.haveContentNet() == true {
            self.title = self.model.product_title
        } else {
            self.title = L$("h_online_service")
        }
        self.topV.isHidden = false
        self.judgeStatus()
        self.loadMessage()
        if status == "1" && model.input_text.count > 0 {
            self.bottomV.input_text = model.input_text
        }
    }
    
    @objc private func tapClick() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_chat_hangeup_keyboard), object: nil)
    }
    
    @objc private func detailTap() {
        let vc = MessageDetailController()
        vc.model = model
        vc.isFromChat = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func judgeStatus() {
        if status == "1" {
            
        } else {
            self.bottomV.isUserInteractionEnabled = false
            let lab = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.center)
            lab.backgroundColor = kCellColor
            lab.frame = CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 50)
            lab.text = "咨询已结束"
            self.bottomV.addSubview(lab)
        }
    }
    
    @objc private func moreClick() {
        weak var weakSelf = self
        let alertCon = UIAlertController.init(title: nil, message: "更多", preferredStyle: .actionSheet)
        let searchAction = UIAlertAction.init(title: "搜索聊天记录", style: .default, handler: { (action) in
            let vc = ChatContentSearchController()
            vc.model = self.model
            vc.clickBlock = { (msg) in
                weakSelf?.loadMessageAfter(id: msg.id)
            }
            self.present(vc, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction.init(title: L$("cancel"), style: .cancel, handler: nil)
        alertCon.addAction(searchAction)
        alertCon.addAction(cancelAction)
        self.present(alertCon, animated: true, completion: nil)
    }
    
    @objc private func endConversation() {
        JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: "结束后将不能再聊天，确认结束咨询？", message: nil, sure: L$("sure"), cancel: L$("cancel"), sureHandler: { (action) in
            self.lastEnd()
        }, cancelHandler: nil)
    }
    
    private func lastEnd() {
        let prams: NSDictionary = ["order_sn":model.order_sn]
        HomeManager.share.orderFinish(prams: prams) { (flag) in
            if flag {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_user_order_change), object: nil)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    private func loadMessageAfter(id: String) {
        model.loadMsgAfter(id: id) { (arr) in
            self.j_header.state = .idle
            self.dataArr.removeAll()
            for msg in arr {
                self.dataArr.insert(msg, at: 0)
            }
            self.tabView.reloadData()
            self.tabView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            let m = self.dataArr[0]
            self.searchMsgId = m.id
        }
    }

}

extension ChatController: ChatQuestionViewDelegate {
    func chatQuestionViewEndClick() {
        self.endConversation()
    }
}

extension ChatController {
    @objc private func loadMessage() {
        model.loadMsgFrom(id: searchMsgId) { (arr) in
            self.tabView.mj_header.endRefreshing()
            if arr.count < 20 {
                self.j_header.jRefreshNoMoreData()
            }
            for msg in arr {
                self.dataArr.insert(msg, at: 0)
            }
            self.tabView.reloadData()
            if arr.count == 0 {
                return
            }
            if self.searchMsgId == "" {
                self.scrollToBottom(animated: false)
            } else {
                self.tabView.scrollToRow(at: IndexPath.init(row: 0, section: arr.count), at: UITableView.ScrollPosition.top, animated: false)
            }
            let m = self.dataArr[0]
            self.searchMsgId = m.id
            let last = self.dataArr.last!
            if !last.fromMe && !last.isReadAck {
                self.model.updateReadAck()
            }
        }
    }
}

extension ChatController: JSocketHelperDelegate {
    func jsocketHelperDidReceiveMsg(msg: STMessage) {
        if msg.sn == model.order_sn {
//            let cell = self.tabView.cellForRow(at: IndexPath.init(row: 0, section: self.dataArr.count - 1))
            self.dataArr.append(msg)
//            if cell == nil {
//                self.tabView.reloadData()
//            } else {
//                self.sendRefresh()
//            }
            self.sendRefresh()
            self.model.updateReadAck()
        }
    }
}

extension ChatController: ChatManagerDelegate {
    func chatManagerReceiveRead(sn: String) {
        if sn == model.order_sn {
            var i = self.dataArr.count - 1
            while i >= 0 {
                let msg = self.dataArr[i]
                if msg.fromMe {
                    if msg.isRead {
                        break
                    }
                    msg.isRead = true
                }
                i -= 1
            }
        }
    }
    
    func chatManagerReceiveWithdrew(model: JSocketModel) {
        if model.sn == self.model.order_sn {
            var i = self.dataArr.count - 1
            while i >= 0 {
                let msg = self.dataArr[i]
                if !msg.fromMe {
                    if msg.id == model.content {
                        msg.isWithdrew = true
                        break
                    }
                }
                i -= 1
            }
            self.tabView.reloadData()
        }
    }
}

/// 底部工具栏方法
extension ChatController: ChatBottomViewDelegate {
    func chatBottomViewHeightChange(bH: CGFloat, scrollToBottom: Bool) {
        if bH > 180 + kXBottomHeight {
            self.tabView.addGestureRecognizer(tabTap)
            UIView.animate(withDuration: 0.25, animations: {
                self.tabView.frame = CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - bH)
                if scrollToBottom {
                    self.scrollToBottom(animated: false)
                }
            }) { (finish) in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_chat_tabview_end_scroll), object: nil)
            }
        } else {
            self.tabView.removeGestureRecognizer(tabTap)
            UIView.animate(withDuration: 0.25, animations: {
                self.tabView.frame = CGRect.init(x: 0, y: self.topH + kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - bH - self.topH)
                if scrollToBottom {
                    self.scrollToBottom(animated: false)
                }
            }) { (finish) in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_chat_tabview_end_scroll), object: nil)
            }
        }
    }
    
    func chatBottomViewSendText(text: String) {
        self.sendText(text: text)
    }
    
    func chatBottomViewClick(bind: String) {
        if bind == "chat_camera" {
            let picker = UIImagePickerController.init(sourceType: UIImagePickerController.SourceType.camera, mediaType: 1, allowsEditing: false)
            picker.delegate = self
            JAuthorizeManager.init(view: self.view).cameraAuthorization {
                self.present(picker, animated: true, completion: nil)
            }
        } else if bind == "chat_album" {
            JAuthorizeManager.init(view: self.view).photoLibraryAuthorization {
                JPhotoCenter.share.delegate = self
                JPhotoCenter.share.present(from: self)
            }
        } else if bind == "chat_file" {
            let vc = JFileController()
            vc.messageModel = self.model
            weak var weakSelf = self
            vc.block = { (arr) in
                weakSelf?.sendFile(arr: arr)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.sendBigEmo(text: bind)
        }
    }
}

//发送文本、大表情消息
extension ChatController {
    private func sendText(text: String) {
        let m = JSocketModel.init(to: model.id, sn: model.order_sn)
        m.content = text
        m.type = socket_value_text
        self.sendMsg(m: m)
    }
    
    private func sendBigEmo(text: String) {
        let m = JSocketModel.init(to: model.id, sn: model.order_sn)
        m.content = text
        m.type = socket_value_emo
        self.sendMsg(m: m)
    }
    
    private func sendMsg(m: JSocketModel) {
        let msg = STMessage.init(model: m)
        self.dataArr.append(msg)
        self.sendRefresh()
        ChatManager.share.addChatMsg(msg: msg)
    }
}

//发送图片消息
extension ChatController: JPhotoCenterDelegate {
    func jphotoCenterEnd(assets: [PHAsset]) {
        var msgArr: [STMessage] = [STMessage]()
        for a in assets {
            let m = JSocketModel.init(to: model.id, sn: model.order_sn)
            var pathExten = ""
            var objKey = "chat/images/"
            switch a.mediaType {
            case .video:
                m.j_path = a.path!.components(separatedBy: CharacterSet.init(charactersIn: "/")).last!
                m.type = socket_value_file
                objKey = "chat/files/"
                pathExten = "mp4"
                let prams: NSDictionary = ["msg_file_name": a.name, "msg_file_length":"\(a.fileSize)"]
                m.attribute = prams.mj_JSONString()
                break
            case .image:
                if JPhotoCenter.share.configure.showGif && a.is_gif {
                    m.j_path = a.gif_path!.components(separatedBy: CharacterSet.init(charactersIn: "/")).last!
                    pathExten = "gif"
                } else {
                    m.j_path = a.cut_path!.components(separatedBy: CharacterSet.init(charactersIn: "/")).last!
                    pathExten = "jpeg"
                }
                m.type = socket_value_img
                break
            default:
                break
            }
            m.content = OSSManager.initWithShare().uniqueString(by: objKey, pathExten: pathExten)
            let msg = STMessage.init(model: m)
            msgArr.append(msg)
            self.dataArr.append(msg)
        }
        self.sendRefresh()
        ChatManager.share.addChatImageMsgArr(msgArr: msgArr)
    }
}

extension ChatController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            guard let result = picker.resultImage(info: info, isOriginal: true) else {
                return
            }
            let imgData = result.jpegData(compressionQuality: 0.3)
            let path = BaseUtil.uniqueMsgID()
            try? imgData?.write(to: URL.init(fileURLWithPath: JPhotoManager.share.uploadPath(path: path)))
            let m = JSocketModel.init(to: self.model.id, sn: self.model.order_sn)
            m.j_path = path
            m.type = socket_value_img
            m.content = OSSManager.initWithShare().uniqueString(by: "chat/images/", pathExten: "jpeg")
            let msg = STMessage.init(model: m)
            self.dataArr.append(msg)
            self.sendRefresh()
            ChatManager.share.addChatImageMsgArr(msgArr: [msg])
        }
    }
}

//发送文件消息
extension ChatController {
    private func sendFile(arr: [JFileModel]) {
        var msgArr: [STMessage] = [STMessage]()
        for fileM in arr {
            let m = JSocketModel.init(to: model.id, sn: model.order_sn)
            m.content = fileM.remotePath
            m.type = socket_value_file
            let dict: NSDictionary = ["msg_file_name": fileM.localPath,"msg_file_length":fileM.fileSize]
            m.attribute = dict.mj_JSONString()
            let msg = STMessage.init(model: m)
            msgArr.append(msg)
            self.dataArr.append(msg)
        }
        self.sendRefresh()
        ChatManager.share.addChatFileMsgArr(msgArr: msgArr)
    }
}

extension ChatController: JShareMessageToolDelegate {
    func jShareMessageToolSendFinish(msg: STMessage) {
        if msg.sn == self.model.order_sn {
            self.dataArr.append(msg)
            self.sendRefresh()
        }
    }
}

//消息撤回
extension ChatController {
    private func sendWithDrew(id: String) {
        let m = JSocketModel.init(to: model.id, sn: model.order_sn)
        m.content = id
        m.type = socket_value_withdrew
        ChatManager.share.withdrewMsg(model: m) { (flag) in
            if flag {
                for msg in self.dataArr {
                    if msg.id == m.content {
                        msg.updateMsgWithdrew()
                        self.tabView.reloadData()
                        break
                    }
                }
            }
        }
    }
    
}

//消息重新发送刷新
extension ChatController: ChatRightBaseCellDelegate {
    func chatRightBaseCellReSend(msg: STMessage) {
        for i in 0..<self.dataArr.count {
            let m = self.dataArr[i]
            if m.id == msg.id {
                self.dataArr.remove(at: i)
                break
            }
        }
        self.dataArr.append(msg)
        self.sendRefresh()
    }
}

//发送消息后刷新
extension ChatController {
    func sendRefresh() {
        self.tabView.reloadData()
        self.scrollToBottom(animated: true)
    }
    
    func scrollToBottom(animated: Bool) {
        if self.dataArr.count > 0 {
            self.tabView.scrollToRow(at: IndexPath.init(row: 0, section: self.dataArr.count - 1), at: UITableView.ScrollPosition.bottom, animated: animated)
        }
    }
}

/// 撤回消息
extension ChatController: ChatBubbleImgViewDelegate {
    func chatBubbleImgViewWithDrew(msg: STMessage) {
        self.sendWithDrew(id: msg.id)
    }
}

/// 点击常见问题列表发送文本消息
extension ChatController: ChatLeftServiceQuestionCellDelegate {
    func chatLeftServiceQuestionCellClick(keyword: String) {
        if questionClicked {
            return
        }
        questionClicked = true
        self.keyword = keyword
        self.perform(#selector(delaySend), with: nil, afterDelay: 0.1)
    }
    
    @objc private func delaySend() {
        self.sendText(text: keyword)
        questionClicked = false
    }
}

extension ChatController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = dataArr[indexPath.section]
        if msg.isWithdrew {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLabCell", for: indexPath) as! ChatLabCell
            if msg.fromMe {
                cell.showStr = "你撤回了一条消息"
            } else {
                cell.showStr = "对方撤回了一条消息"
            }
            return cell
        }
        switch msg.bodyType {
        case .text:
            if msg.j_model.type == 7 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLabCell", for: indexPath) as! ChatLabCell
                cell.showStr = msg.j_model.content
                return cell
            }
            if msg.fromMe {
                let cell = tabView.dequeueReusableCell(withIdentifier: "ChatRightTextCell", for: indexPath) as! ChatRightTextCell
                cell.bubbleImgView.delegate = self
                cell.delegate = self
                cell.msg = msg
                return cell
            }
            if msg.j_model.attributeModel.autoReplyArr.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLeftServiceQuestionCell", for: indexPath) as! ChatLeftServiceQuestionCell
                cell.delegate = self
                cell.msg = msg
                return cell
            }
            let cell = tabView.dequeueReusableCell(withIdentifier: "ChatLeftTextCell", for: indexPath) as! ChatLeftTextCell
            cell.msg = msg
            return cell
        case .bigEmo:
            if msg.fromMe {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRightBigEmoCell", for: indexPath) as! ChatRightBigEmoCell
                cell.bubbleImgView.delegate = self
                cell.delegate = self
                cell.msg = msg
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLeftBigEmoCell", for: indexPath) as! ChatLeftBigEmoCell
            cell.msg = msg
            return cell
        case .image:
            let body = msg.body as! STImageMessageBody
            if msg.fromMe {
                if body.is_gif {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRightGifCell", for: indexPath) as! ChatRightGifCell
                    cell.bubbleImgView.delegate = self
                    cell.delegate = self
                    cell.msg = msg
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRightImgCell", for: indexPath) as! ChatRightImgCell
                cell.bubbleImgView.delegate = self
                cell.delegate = self
                cell.msg = msg
                return cell
            }
            if body.is_gif {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLeftGifCell", for: indexPath) as! ChatLeftGifCell
                cell.bubbleImgView.delegate = self
                cell.msg = msg
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLeftImgCell", for: indexPath) as! ChatLeftImgCell
            cell.bubbleImgView.delegate = self
            cell.msg = msg
            return cell
        case .file:
            if msg.fromMe {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRightFileCell", for: indexPath) as! ChatRightFileCell
                cell.bubbleImgView.delegate = self
                cell.delegate = self
                cell.msg = msg
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLeftFileCell", for: indexPath) as! ChatLeftFileCell
            cell.msg = msg
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let msg = dataArr[indexPath.section]
        if msg.isWithdrew || msg.j_model.type == 7 {
            return 30
        }
        return msg.size.height + 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let msg = dataArr[section]
        let v = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ChatTimeHeaderView") as! ChatTimeHeaderView
        if section == 0 {
            v.timeStr = msg.timeStr
        } else {
            let upMsg = dataArr[section - 1]
            if msg.showTime(referenceMsg: upMsg) == true {
                v.timeStr = msg.timeStr
            } else {
                v.timeStr = ""
            }
        }
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let msg = dataArr[section]
        if section == 0 {
            msg.j_show_time = true
            return 30
        } else {
            let upMsg = dataArr[section - 1]
            if msg.showTime(referenceMsg: upMsg) == true {
                return 30
            }
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_chat_tabview_begin_scroll), object: nil)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_chat_tabview_end_scroll), object: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_chat_tabview_end_scroll), object: nil)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_chat_tabview_end_scroll), object: nil)
    }
}

