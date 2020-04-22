//
//  MeConsultController.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import Photos

/// 我要咨询
class MeConsultController: BaseController {
    
    var bind: String = "h_me_consult"
    
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .grouped, space: 0)
        temp.bounces = false
        temp.separatorStyle = .none
        temp.delegate = self
        temp.dataSource = self
        temp.register(ConsultFlowCell.self, forCellReuseIdentifier: "ConsultFlowCell")
        temp.register(ConsultTypeCell.self, forCellReuseIdentifier: "ConsultTypeCell")
        temp.register(ConsultTextImgCell.self, forCellReuseIdentifier: "ConsultTextImgCell")
        temp.register(ZZBusinessFileCell.self, forCellReuseIdentifier: "ZZBusinessFileCell")
        temp.register(ZZBusinessFileAddCell.self, forCellReuseIdentifier: "ZZBusinessFileAddCell")
        temp.register(ConsultReminderCell.self, forCellReuseIdentifier: "ConsultReminderCell")
        temp.register(JOKBtnCell.self, forCellReuseIdentifier: "JOKBtnCell")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        temp.register(JHeaderFooterLabView.self, forHeaderFooterViewReuseIdentifier: "JHeaderFooterLabView")
        temp.register(JHeaderFooterLabView.self, forHeaderFooterViewReuseIdentifier: "JHeaderFooterLabView")
        self.view.addSubview(temp)
        return temp
    }()
    
    private let wordArr: [[String]] = [["flow","type"],["textImg"],["file"],["reminder"],["h_pay_explain","ok"]]
    private var model: ProductModel?
    private var content: String = ""
    private var fileModelArr: [JFileModel] = [JFileModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JPayApiManager.share.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$(bind)
        content = UserInfo.getStandard(key: bind) ?? ""
        self.tabView.reloadData()
        self.getDataSource()
        
//        if UserInfo.share.quality_count <= 0 {
//            self.questionIsEmpty()
//        }
        
        self.perform(#selector(delay), with: nil, afterDelay: 0)
    }
    
    private func getDataSource() {
        HomeManager.share.serviceDetailWithBind(bind: bind) { (model) in
            self.model = model
            self.tabView.reloadData()
        }
    }
    
    @objc private func delay() {
        fileModelArr = JFMManager.share.get(id: bind)
        JPhotoCenter.share.selectedAsset = JPHAssetManager.share.get(id: bind)
        JPhotoCenter.share.endPicker()
        self.tabView.reloadData()
    }
    
    private func paySuccess() {
        UserInfo.setStandard(key: bind, text: nil)
        JFMManager.share.clear(id: bind)
        JPHAssetManager.share.clear(id: bind)
        self.navigationController?.popToRootViewController(animated: false)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_user_order_change), object: nil)
        UserInfo.share.chat_sn = UserInfo.share.order_sn
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_jump_to_chat), object: nil)
        UserInfo.share.netUserInfo()
        UserInfo.share.order_sn = nil
    }

}

extension MeConsultController: JPayApiManagerDelegate {
    func jPayApiManagerPayResult(success: Bool) {
        if success {
            self.paySuccess()
        }
    }
}

extension MeConsultController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return wordArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return fileModelArr.count + 1
        }
        let arr = wordArr[section]
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            if indexPath.row == fileModelArr.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ZZBusinessFileAddCell", for: indexPath) as! ZZBusinessFileAddCell
                return cell
            }
            let model = fileModelArr[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ZZBusinessFileCell", for: indexPath) as! ZZBusinessFileCell
            cell.delegate = self
            cell.model = model
            return cell
        }
        let arr = wordArr[indexPath.section]
        let tempStr = arr[indexPath.row]
        if tempStr == "flow" {
            let cell = tabView.dequeueReusableCell(withIdentifier: "ConsultFlowCell", for: indexPath) as! ConsultFlowCell
            cell.bind = "h_watch_flow"
            cell.type_bind = bind
            cell.content = model?.content
            return cell
        } else if tempStr == "type" {
            let cell = tabView.dequeueReusableCell(withIdentifier: "ConsultTypeCell", for: indexPath) as! ConsultTypeCell
            cell.bind = bind
            return cell
        } else if tempStr == "textImg" {
            let cell = tabView.dequeueReusableCell(withIdentifier: "ConsultTextImgCell", for: indexPath) as! ConsultTextImgCell
            cell.photoView.delegate = self
            cell.photoView.camera_delegate = self
            cell.tv.delegate = self
            cell.tv.text = content
            return cell
        } else if tempStr == "reminder" {
            let cell = tabView.dequeueReusableCell(withIdentifier: "ConsultReminderCell", for: indexPath) as! ConsultReminderCell
            cell.titleStr = L$("h_warm_reminder")
            cell.reminder = RemindersManager.share.reminders(bind: bind)
            return cell
        } else if tempStr == "h_pay_explain" {
            let cell = tabView.dequeueReusableCell(withIdentifier: "ConsultReminderCell", for: indexPath) as! ConsultReminderCell
            cell.titleStr = L$("h_pay_explain")
            cell.reminder = self.model?.information
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "JOKBtnCell", for: indexPath) as! JOKBtnCell
        cell.btn.setTitle(L$("submit"), for: .normal)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 70
        }
        let arr = wordArr[indexPath.section]
        let tempStr = arr[indexPath.row]
        if tempStr == "flow" {
            return 70
        } else if tempStr == "type" {
            return 90
        } else if tempStr == "textImg" {
            let row = (JPhotoCenter.share.selectedAsset.count + 3) / 3
            var h = (kDeviceWidth - 40) / 3 * CGFloat(row) + CGFloat(row - 1) * 10 + 20
            if h > kDeviceWidth {
                h = kDeviceWidth
            }
            return 210 + h
        } else if tempStr == "reminder" {
            let h = RemindersManager.share.remiderHeight(bind: bind, font: kFontMS, width: kDeviceWidth - kLeftSpaceS * 2)
            return h + kLeftSpaceS * 3 + 20
        } else if tempStr == "h_pay_explain" {
            let h = model?.information.height(width: kDeviceWidth - kLeftSpaceS * 2, font: kFontMS) ?? 0
            return h + kLeftSpaceS * 3 + 20
        }
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
        if indexPath.section == 2 {
            if indexPath.row == fileModelArr.count {
                let vc = JFileController()
                weak var weakSelf = self
                vc.block = { (arr) in
                    for m in arr {
                        if weakSelf != nil {
                            if weakSelf!.fileModelArr.count >= 9 {
                                PromptTool.promptText("附件最多不超过9个", 1)
                                break
                            }
                        }
                        weakSelf?.fileModelArr.append(m)
                    }
                    if weakSelf != nil {
                        JFMManager.share.save(id: weakSelf!.bind, assets: weakSelf!.fileModelArr)
                    }
                    weakSelf?.tabView.reloadSections(IndexSet.init(integer: IndexSet.Element.init(2)), with: UITableView.RowAnimation.fade)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let model = fileModelArr[indexPath.row]
                let vc = JFilePreviewController()
                vc.path = OSSManager.initWithShare().savePath(model.localPath)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 || section == 3 {
            let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "JHeaderFooterLabView") as! JHeaderFooterLabView
            if section == 2 {
                vv.lab.text = L$("p_add_img_if_need")
            } else {
                vv.lab.text = L$("p_add_file_if_need")
            }
            return vv
        }
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 || section == 3 {
            return 40
        }
        return kCellSpaceL
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

extension MeConsultController: JPhotoCenterDelegate {
    func jphotoCenterEnd(assets: [PHAsset]) {
        JPHAssetManager.share.save(id: bind, assets: assets)
        self.tabView.reloadData()
    }
    
    func jPhotoCenterUploadFinish() {
        for m in JPhotoCenter.share.selectedAsset {
            if m.upload_success != true {
                PromptTool.promptText(L$("upload_fail"), 1)
                return
            }
        }
        var images: String = ""
        for i in 0..<JPhotoCenter.share.selectedAsset.count {
            let m = JPhotoCenter.share.selectedAsset[i]
            images += m.remote_path!
            if i < JPhotoCenter.share.selectedAsset.count - 1 {
                images += ","
            }
        }
        self.commit(images: images)
    }
}

extension MeConsultController: JPhotoResultShowViewDelegate {
    func jphotoResultShowViewCameraAlbumClick(isCamera: Bool) {
        if isCamera {
            JAuthorizeManager.init(view: self.view).cameraAuthorization {
                let picker = UIImagePickerController.init(sourceType: .camera, mediaType: 1, allowsEditing: false)
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }
        } else {
            JAuthorizeManager.init(view: self.view).photoLibraryAuthorization {
                let nav = BaseNavigationController.init(rootViewController: JAlbumListController())
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
}

extension MeConsultController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            guard let result = picker.resultImage(info: info, isOriginal: true) else {
                return
            }
            let promptV = JPhotoPromptView.init(bind: "正在保存")
            JPhotoAlbumManager.share.takePhotoSaveImageToAlbum(image: result, success: { (flag) in
                promptV.removeFromSuperview()
                if flag {
                    guard let asset = JPhotoManager.share.fetchAssetsInCollection(collection: nil, asending: false).last else {
                        return
                    }
                    JPhotoManager.share.fetchImageInAsset(asset: asset, size: CGSize.init(width: 200, height: 200), mode: .fast, complete: { (ass, img, dict) in
                        if img != nil && img!.size.width >= 200 || img!.size.height >= 200 {
                            JPhotoCenter.share.addAsset(asset: asset)
                            JPhotoCenter.share.endPicker()
                        }
                    })
                } else {
                    PromptTool.promptText("保存失败", 1)
                }
            })
        }
    }
}

extension MeConsultController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "" {
            return true
        }
        if textView.text.count > 500 {
            PromptTool.promptText(L$("limit_requirement_max"), 1)
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let temp = textView.superview else {
            return
        }
        self.tabView.setContentOffset(CGPoint.init(x: 0, y: temp.frame.origin.y - kCellSpaceL), animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        content = textView.text
        UserInfo.setStandard(key: bind, text: content)
    }
}

extension MeConsultController: JFileCellDelegate {
    func jFileCellSelectClick(sender: UIButton, model: JFileModel) {
        for i in 0..<fileModelArr.count {
            let m = fileModelArr[i]
            if m.localPath == model.localPath {
                fileModelArr.remove(at: i)
                break
            }
        }
        JFMManager.share.save(id: bind, assets: fileModelArr)
        self.tabView.reloadSections(IndexSet.init(integer: IndexSet.Element.init(2)), with: UITableView.RowAnimation.fade)
    }
}

extension MeConsultController: JOKBtnCellDelegate {
    func jOKBtnCellClick(sender: UIButton) {
        if content.haveTextStr() != true {
            PromptTool.promptText(L$("limit_requirement_min"), 1)
            return
        }
        if content.count > 500 {
            PromptTool.promptText(L$("limit_requirement_max"), 1)
            return
        }
        if UserInfo.share.quality_count <= 0 {
            self.questionIsEmpty()
        } else {
            self.commitAlert()
        }
    }
}

extension MeConsultController {
    private func commitAlert() {
        if HTTPManager.share.net_unavaliable {
            PromptTool.promptText(L$("net_unavailable"), 1)
            return
        }
        JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: L$("p_sure_commit"), message: nil, sure: L$("sure"), cancel: L$("cancel"), sureHandler: { (action) in
            if JPhotoCenter.share.selectedAsset.count > 0 {
                JPhotoCenter.share.uploadToOss(objKey: "uploads/consult/")
            } else {
                self.commit(images: "")
            }
        }, cancelHandler: nil)
    }
    
    private func questionIsEmpty() {
        var vip_bind: String = ""
        var titleStr: String = "问题数量为0，请先购买问题。"
        if UserInfo.share.is_vip {
            if UserInfo.share.vip_from_index < 2 {
                vip_bind = "upgrade_vip"
                titleStr = "问题数量为0，请先购买问题或升级会员获得问题数量。"
            }
        } else {
            vip_bind = "open_vip"
            titleStr = "问题数量为0，请先购买问题或开通会员获得问题数量。"
        }
        
        let alertCon = UIAlertController.init(title: titleStr, message: nil, preferredStyle: .alert)
        let vipAction = UIAlertAction.init(title: L$(vip_bind), style: .default, handler: { (action) in
            let vc = MineVIPController()
            vc.isBuy = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        let questionAction = UIAlertAction.init(title: L$("buy_question"), style: .default, handler: { (action) in
            let vc = MineQuestionController()
            vc.isBuy = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        let cancelAction = UIAlertAction.init(title: L$("cancel"), style: .cancel, handler: nil)
        if vip_bind.count > 0 {
            alertCon.addAction(vipAction)
        }
        alertCon.addAction(questionAction)
        alertCon.addAction(cancelAction)
        self.present(alertCon, animated: true, completion: nil)
    }
}

extension MeConsultController {
    private func commit(images: String) {
        if model?.id == nil {
            HomeManager.share.serviceDetailWithBind(bind: bind) { (m) in
                if m?.id != nil {
                    self.model = m
                    self.lastStep(images: images, pid: m!.id)
                }
            }
        } else {
            self.lastStep(images: images, pid: model!.id)
        }
        
    }
    
    private func lastStep(images: String, pid: String) {
        let tempArr = NSMutableArray()
        for m in fileModelArr {
            let d: NSDictionary = ["file_path": m.remotePath,"file_name":m.localPath,"file_size":m.fileSize]
            tempArr.add(d)
        }
        let fileDict: NSDictionary = ["files": tempArr]
        let filesStr = fileDict.mj_JSONString() ?? ""
        
        let order_type: String = "1"
        let prams: NSDictionary = ["problem":content,"images":images,"pid":pid,"pay_type":"3","order_type":order_type,"attribute":filesStr]
        HomeManager.share.orderCreate(prams: prams) { (flag, sn) in
            if flag {
                UserInfo.share.order_sn = sn
                UserInfo.share.order_type = "2"
                self.paySuccess()
            } else {
                if sn?.haveTextStr() == true {
                    JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: "请先完善个人资料", message: "完善个人信息后，方可开通会员或进行问题咨询等其它业务", sure: "去完善", cancel: L$("cancel"), sureHandler: { (action) in
                        let vc = MineProfileController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }, cancelHandler: nil)
                }
            }
        }
    }
}
