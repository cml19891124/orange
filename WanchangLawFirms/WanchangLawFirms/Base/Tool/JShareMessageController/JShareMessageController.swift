//
//  JShareMessageController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/6.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 从其它app打开本app时显示的控制器
class JShareMessageController: BaseController {

    var model: JSocketModel = JSocketModel()
    
    private lazy var saveBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontM, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, self, #selector(saveBtnClick))
        temp.frame = CGRect.init(x: 0, y: kNavHeight + kCellSpaceL, width: kDeviceWidth, height: 60)
        temp.backgroundColor = kCellColor
        temp.setTitle("上传到欧伶猪服务器", for: .normal)
        self.view.addSubview(temp)
        return temp
    }()
    
    private lazy var listView: JTabNotiView = {
        () -> JTabNotiView in
//        let temp = JTabNotiView.init(frame: CGRect.init(x: 0, y: kNavHeight + kCellSpaceL + 60, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - kCellSpaceL - 60), style: .plain, space: 0)
        let temp = JTabNotiView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: 0)
        let tabView = temp.tabView
        tabView.bounces = false
        tabView.delegate = self
        tabView.dataSource = self
        tabView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        tabView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        tabView.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.view.addSubview(temp)
        return temp
    }()
    var dataArr: [MessageModel] = [MessageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("p_select_a_conversation")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: L$("close"), style: .done, target: self, action: #selector(backClick))
//        self.saveBtn.isHidden = false
        self.localDataSource()
    }
    
    private func localDataSource() {
        self.dataArr = MessageManager.share.dealingConversation
        if self.dataArr.count == 0 {
            self.listView.imgName = "no_data_conversation_deal"
        } else {
            self.listView.imgName = nil
        }
        self.listView.tabView.reloadData()
    }
    
    @objc private func saveBtnClick() {
        JShareMessageTool.share.uploadToOrange(model: model) { (flag) in
            if flag {
                self.saveBtn.isUserInteractionEnabled = false
                self.saveBtn.setImage(UIImage.init(named: "check_right_orange"), for: .normal)
                self.saveBtn.setTitle(kBtnSpaceString + "上传到欧伶猪服务器", for: .normal)
                let vc = JFileController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.saveBtn.setImage(UIImage.init(named: "msg_send_fail"), for: .normal)
                self.saveBtn.setTitle(kBtnSpaceString + "上传到欧伶猪服务器", for: .normal)
            }
        }
    }

    @objc private func backClick() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension JShareMessageController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataArr[indexPath.row]
        let titleStr = "发送到\(model.product_title)？"
        JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: titleStr, message: "", sure: L$("sure"), cancel: L$("cancel"), sureHandler: { (action) in
            if HTTPManager.share.net_unavaliable {
                PromptTool.promptText(L$("net_unavailable"), 1)
            } else {
                let m = JSocketModel.init(to: model.id, sn: model.order_sn)
                m.type = self.model.type
                m.attribute = self.model.attribute
                m.content = self.model.content
                m.j_share_local_full_url = self.model.j_share_local_full_url
                JShareMessageTool.share.shareSendFile(model: m, success: { (flag) in
                    self.navigationController?.dismiss(animated: true, completion: nil)
                })
            }
        }, cancelHandler: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kCellSpaceL
    }
}
