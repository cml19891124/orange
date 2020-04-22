//
//  ZZBusinessDetailController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit
import Photos

/// 企业 - 业务详情
class ZZBusinessDetailController: BaseController {
    
    var id: String = ""
    
    private lazy var j_header: JRefreshHeader = {
        () -> JRefreshHeader in
        let temp = JRefreshHeader.init(refreshingTarget: self, refreshingAction: #selector(getDataSource))
        return temp!
    }()
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: 0)
        temp.separatorStyle = .none
        temp.delegate = self
        temp.dataSource = self
        temp.mj_header = j_header
        temp.register(ConsultFlowCell.self, forCellReuseIdentifier: "ConsultFlowCell")
        temp.register(ZZBusinessTypeCell.self, forCellReuseIdentifier: "ZZBusinessTypeCell")
        temp.register(ConsultTextCell.self, forCellReuseIdentifier: "ConsultTextCell")
        temp.register(ConsultTextImgCell.self, forCellReuseIdentifier: "ConsultTextImgCell")
        temp.register(ZZBusinessFileCell.self, forCellReuseIdentifier: "ZZBusinessFileCell")
        temp.register(ZZBusinessFileAddCell.self, forCellReuseIdentifier: "ZZBusinessFileAddCell")
        temp.register(ConsultReminderCell.self, forCellReuseIdentifier: "ConsultReminderCell")
        temp.register(JOKBtnCell.self, forCellReuseIdentifier: "JOKBtnCell")
        temp.register(MDOrangeBankCell.self, forCellReuseIdentifier: "MDOrangeBankCell")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        temp.register(JHeaderFooterLabView.self, forHeaderFooterViewReuseIdentifier: "JHeaderFooterLabView")
        self.view.addSubview(temp)
        return temp
    }()
    
    private let wordArr: [[String]] = [["flow","type"],["textImg"],["file"],["reminder"],["h_pay_explain","ok"]]
    
    private var key_content: String {
        get {
            return model.id + "_standard_content"
        }
    }
    private var content: String = ""
    private var explain: String {
        get {
            var str1: String = ""
            var str2: String = ""
            if model.symbol == "company_consult" {
                str1 = "钻石会员：3888元/年（咨询不限次数）\n星耀会员：6888元/年（咨询不限次数+文书定制36次+文书审查36次）\n荣耀会员：12888元/年（咨询/文书定制/文书审查不限次数及其它优质服务）\n"
                if UserInfo.share.businessModel?.vip != "0" {
                    str2 = "剩余次数：不限次数"
                }
                var priceStr: String = "普通用户价格：\(model.price)元/次"
                if str2.count > 0 {
                    priceStr += "\n"
                }
                str1 += priceStr
            } else if model.symbol == "company_make" || model.symbol == "company_check" {
                str1 = "荣耀会员：12888元/年（文书定制免费+文书审查免费）\n星耀会员：6888元/年（文书定制36次/年+文书审查36次/年）\n"
                if UserInfo.share.businessModel?.vip == "2" {
                    if model.symbol == "company_make" {
                        str2 = "剩余次数：\(UserInfo.share.make_count)次"
                    } else if model.symbol == "company_check" {
                        str2 = "剩余次数：\(UserInfo.share.check_count)次"
                    }
                } else if UserInfo.share.businessModel?.vip == "3" {
                    str2 = "剩余次数：不限次数"
                }
                var priceStr: String = "钻石会员及普通用户价格：\(model.price)元/次"
                if str2.count > 0 {
                    priceStr += "\n"
                }
                str1 += priceStr
            } else if model.id == "12" {
                str1 = "荣耀会员：12888元/年（享有9折优惠）\n"
                if UserInfo.share.businessModel?.vip == "3" {
                    str2 = "当前享受折扣：9折"
                }
                var priceStr: String = "钻石会员及普通用户价格：\(model.price)元/次"
                if str2.count > 0 {
                    priceStr += "\n"
                }
                str1 += priceStr
            } else if model.id == "11" {
                let priceStr: String = "价格：\(model.price)元/次"
                str1 += priceStr
            }
            return str1 + str2
        }
    }
    private var finish: Bool = false
    private var model: ProductModel!
    private var fileModelArr: [JFileModel] = [JFileModel]()
    private var detailModel: MessageModel? {
        didSet {
            if detailModel == nil {
                self.tabView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
                self.tabView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
                self.tabView.reloadData()
            } else {
                
            }
        }
    }
    
    private var okBtn: UIButton?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JPayApiManager.share.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabView.mj_header.beginRefreshing()
    }
    
    @objc private func getDataSource() {
        HomeManager.share.serviceDetail(id: id) { (m) in
            self.tabView.mj_header.endRefreshing()
            if m != nil {
                self.model = m!
                self.title = self.model.title
                self.content = UserInfo.getStandard(key: self.key_content) ?? ""
                self.finish = true
                self.tabView.reloadData()
                self.tabView.bounces = false
                self.perform(#selector(self.delay), with: nil, afterDelay: 0)
            }
        }
    }
    
    private func detailDataSource(sn: String) {
        let prams: NSDictionary = ["order_sn":sn]
        HomeManager.share.orderView(prams: prams) { (m) in
            if m != nil {
                self.detailModel = m
                let headV = MessageDetailHeadView.init(model: m!)
                headV.delegate = self
                self.tabView.tableHeaderView = headV
                let footV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 120))
                let cv = JCalculateResetView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth - kLeftSpaceL * 2, height: 40))
                cv.getDataSource(bind1: "cancel_order", bind2: "confirm_pay")
                cv.delegate = self
                footV.addSubview(cv)
                _ = cv.sd_layout()?.centerYEqualToView(footV)?.centerXEqualToView(footV)?.widthIs(kDeviceWidth - kLeftSpaceL * 2)?.heightIs(40)
                self.tabView.tableFooterView = footV
                self.tabView.reloadData()
//                let footV = JOKBtnView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 120))
//                footV.btn.setTitle(L$("cancel_order"), for: .normal)
//                footV.delegate = self
//                self.tabView.tableFooterView = footV
//                self.tabView.reloadData()
            }
        }
    }
    
    @objc private func delay() {
        fileModelArr = JFMManager.share.get(id: id)
        JPhotoCenter.share.selectedAsset = JPHAssetManager.share.get(id: id)
        JPhotoCenter.share.endPicker()
        self.tabView.reloadData()
    }
    
    /// 支付成功后直接跳转到聊天页面
    private func paySuccess() {
        UserInfo.setStandard(key: key_content, text: nil)
        JPHAssetManager.share.clear(id: id)
        JFMManager.share.clear(id: id)
        self.navigationController?.popToRootViewController(animated: false)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_user_order_change), object: nil)
        UserInfo.share.chat_sn = UserInfo.share.order_sn
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_jump_to_chat), object: nil)
        UserInfo.share.netUserInfo()
        UserInfo.share.order_sn = nil
    }
    
}

extension ZZBusinessDetailController: MessageDetailHeadViewDelegate {
    func messageDetailHeadViewClick(arr: [JImgModel], selectModel: JImgModel) {
        let vc = JQuestionImgsController.init(dataArr: arr, currentModel: selectModel)
        vc.currentNavigationBarAlpha = 0
        vc.transitionType = .image
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ZZBusinessDetailController: JPayApiManagerDelegate {
    func jPayApiManagerPayResult(success: Bool) {
        if success {
            self.paySuccess()
        }
    }
}

extension ZZBusinessDetailController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if detailModel != nil {
            return 1
        }
        if !finish {
            return 0
        }
        return wordArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if detailModel != nil {
            return 1
        }
        if section == 2 {
            return fileModelArr.count + 1
        }
        let arr = wordArr[section]
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if detailModel != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MDOrangeBankCell", for: indexPath) as! MDOrangeBankCell
            cell.bankView.pay_code = self.detailModel?.pay_code ?? ""
            cell.bankView.pay_tips = self.detailModel?.pay_tips ?? ""
            return cell
        }
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
            cell.content = model?.content
            return cell
        } else if tempStr == "type" {
            let cell = tabView.dequeueReusableCell(withIdentifier: "ZZBusinessTypeCell", for: indexPath) as! ZZBusinessTypeCell
            cell.desLab.text = model.sub_title
            return cell
        } else if tempStr == "textImg" {
            let cell = tabView.dequeueReusableCell(withIdentifier: "ConsultTextImgCell", for: indexPath) as! ConsultTextImgCell
            cell.photoView.delegate = self
            cell.photoView.camera_delegate = self
            cell.tv.delegate = self
            cell.tv.placeholder = L$("p_enter_your_business_requirement")
            cell.tv.text = content
            return cell
        } else if tempStr == "reminder" {
            let cell = tabView.dequeueReusableCell(withIdentifier: "ConsultReminderCell", for: indexPath) as! ConsultReminderCell
            cell.titleStr = L$("h_warm_reminder")
            cell.reminder = model.desc
            return cell
        } else if tempStr == "h_pay_explain" {
            let cell = tabView.dequeueReusableCell(withIdentifier: "ConsultReminderCell", for: indexPath) as! ConsultReminderCell
            cell.titleStr = L$("h_pay_explain")
            cell.reminder = model.information
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "JOKBtnCell", for: indexPath) as! JOKBtnCell
        cell.delegate = self
        if UserInfo.share.businessModel?.vip != "0" {
            if model.symbol == "company_make" {
                let str1 = L$("submit")
                let str2 = UserInfo.share.make_count_show_str
                let totalStr = str1 + str2
                cell.btn.setTitle(totalStr, for: .normal)
                return cell
            } else if model.symbol == "company_check" {
                let str1 = L$("submit")
                let str2 = UserInfo.share.check_count_show_str
                let totalStr = str1 + str2
                cell.btn.setTitle(totalStr, for: .normal)
                return cell
            } else if model.id == "12" {
                let str1 = L$("submit")
                let str2 = UserInfo.share.book_lawyer_show_str
                let totalStr = str1 + str2
                cell.btn.setTitle(totalStr, for: .normal)
                return cell
            } else if model.symbol == "company_other" {
                let str1 = L$("submit")
                let str2 = UserInfo.share.book_other_show_str
                let totalStr = str1 + str2
                cell.btn.setTitle(totalStr, for: .normal)
            } else if model.symbol == "company_consult" {
                let str1 = L$("submit")
                let str2 = "(不限次数)"
                let totalStr = str1 + str2
                cell.btn.setTitle(totalStr, for: .normal)
            }
            return cell
        }
        cell.btn.setTitle(L$("submit"), for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if detailModel != nil {
            return 400
        }
        if indexPath.section == 2 {
            return 70
        }
        let arr = wordArr[indexPath.section]
        let tempStr = arr[indexPath.row]
        if tempStr == "flow" {
            return 70
        } else if tempStr == "type" {
            var h = model.sub_title.height(width: kDeviceWidth - kLeftSpaceS * 3 - 40, font: kFontMS)
            if h < 20 {
                h = 20
            }
            return h + 50
        } else if tempStr == "textImg" {
            let row = (JPhotoCenter.share.selectedAsset.count + 3) / 3
            var h = (kDeviceWidth - 40) / 3 * CGFloat(row) + CGFloat(row - 1) * 10 + 20
            if h > kDeviceWidth {
                h = kDeviceWidth
            }
            return 210 + h
        } else if tempStr == "reminder" {
            let h = model.desc.height(width: kDeviceWidth - kLeftSpaceS * 2, font: kFontMS)
            return h + kLeftSpaceS * 3 + 20
        } else if tempStr == "h_pay_explain" {
            let h = model.information.height(width: kDeviceWidth - kLeftSpaceS * 2, font: kFontMS)
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
                        JFMManager.share.save(id: weakSelf!.id, assets: weakSelf!.fileModelArr)
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

extension ZZBusinessDetailController: JPhotoCenterDelegate {
    func jphotoCenterEnd(assets: [PHAsset]) {
        JPHAssetManager.share.save(id: id, assets: assets)
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

extension ZZBusinessDetailController: JPhotoResultShowViewDelegate {
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

extension ZZBusinessDetailController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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

extension ZZBusinessDetailController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "" {
            return true
        }
        if textView.text.count > 800 {
            PromptTool.promptText(L$("limit_requirement_business_max"), 1)
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
        UserInfo.setStandard(key: key_content, text: content)
    }
}

extension ZZBusinessDetailController: JFileCellDelegate {
    func jFileCellSelectClick(sender: UIButton, model: JFileModel) {
        for i in 0..<fileModelArr.count {
            let m = fileModelArr[i]
            if m.localPath == model.localPath {
                fileModelArr.remove(at: i)
                break
            }
        }
        JFMManager.share.save(id: id, assets: fileModelArr)
        self.tabView.reloadSections(IndexSet.init(integer: IndexSet.Element.init(2)), with: UITableView.RowAnimation.fade)
    }
}

extension ZZBusinessDetailController: JOKBtnCellDelegate {
    func jOKBtnCellClick(sender: UIButton) {
        if JRootVCManager.share.touristJudgeAlert() {
            return
        }
        if sender.titleLabel?.text == L$("cancel_order") {
            guard let sn = self.detailModel?.order_sn else {
                return
            }
            JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: "确定取消订单", message: nil, sure: L$("sure"), cancel: L$("cancel"), sureHandler: { (action) in
                let prams: NSDictionary = ["order_sn":sn]
                HomeManager.share.orderConfirmCancel(isCancel: true, prams: prams, success: { (flag) in
                    if flag {
                        self.detailModel = nil
                        UserInfo.setStandard(key: self.key_content, text: self.content)
                    }
                })
            }, cancelHandler: nil)
            return
        }
        if content.haveTextStr() != true {
            PromptTool.promptText(L$("limit_requirement_min"), 1)
            return
        }
        if content.count > 800 {
            PromptTool.promptText(L$("limit_requirement_business_max"), 1)
            return
        }
        self.okBtn = sender
        self.commitAlert()
    }
}

extension ZZBusinessDetailController: JCalculateResetViewDelegate {
    func jcalculateResetViewBtnsClick(sender: UIButton, bind: String) {
        guard let sn = self.detailModel?.order_sn else {
            return
        }
        var titleStr = "确定已支付订单？"
        var isCancel = false
        if bind == "cancel_order" {
            titleStr = "确定取消订单？"
            isCancel = true
        }
        JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: titleStr, message: nil, sure: L$("sure"), cancel: L$("cancel"), sureHandler: { (action) in
            let prams: NSDictionary = ["order_sn":sn]
            HomeManager.share.orderConfirmCancel(isCancel: isCancel, prams: prams, success: { (flag) in
                if flag {
                    if isCancel {
                        self.detailModel = nil
                        UserInfo.setStandard(key: self.key_content, text: self.content)
                    } else {
                        PromptTool.promptText("已支付，等待确认", 1)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
        }, cancelHandler: nil)
    }
}

extension ZZBusinessDetailController: JBusinessCustomPayPriceViewDelegate {
    func jBusinessCustomPayPriceViewVipClick() {
        let vc = MineBusinessVIPController()
        vc.isBuy = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func jBusinessCustomPayPriceViewBuyClick(m: JPayModel) {
        self.businessOrder(images: m.images, pid: m.id)
    }
}

extension ZZBusinessDetailController {
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
}

extension ZZBusinessDetailController {
    private func commit(images: String) {
        self.lastStep(images: images, pid: model!.id)
    }
    
    private func lastStep(images: String, pid: String) {
        if model.symbol == "company_consult" {
            if UserInfo.share.is_vip {
                self.freePay(images: images, pid: pid)
                return
            }
        } else if model.symbol == "company_make" || model.symbol == "company_check" {
            if model.symbol == "company_make" && UserInfo.share.make_count > 0 {
                self.freePay(images: images, pid: pid)
                return
            }
            if model.symbol == "company_check" && UserInfo.share.check_count > 0 {
                self.freePay(images: images, pid: pid)
                return
            }
        } else if model.symbol == "company_other" && UserInfo.share.other_count > 0 {
            self.freePay(images: images, pid: pid)
            return
        }
        if !UserInfo.share.isMother {
            JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: "子账号暂不支持支付", message: nil, sure: L$("sure"), cancel: nil, sureHandler: nil, cancelHandler: nil)
            return
        }
        model?.j_content = content
        model?.j_images = images
        self.alertPrice(m: model!)
    }
    
    private func alertPrice(m: ProductModel) {
        OLAlertManager.share.priceBusinessShow(model: m)
        OLAlertManager.share.priceBusinessView?.delegate = self
    }
    
    private func freePay(images: String, pid: String) {
        let tempArr = NSMutableArray()
        for m in fileModelArr {
            let d: NSDictionary = ["file_path": m.remotePath,"file_name":m.localPath,"file_size":m.fileSize]
            tempArr.add(d)
        }
        self.okBtn?.isUserInteractionEnabled = false
        let fileDict: NSDictionary = ["files": tempArr]
        let filesStr = fileDict.mj_JSONString() ?? ""
        let prams: NSDictionary = ["problem":content,"images":images,"attribute":filesStr,"pid":pid,"pay_type":"3","order_type":"2"]
        HomeManager.share.orderCreate(prams: prams) { (flag, sn) in
            if flag {
                UserInfo.share.order_sn = sn
                if self.model.id == "14" {
                    UserInfo.share.order_type = "1"
                } else {
                    UserInfo.share.order_type = "2"
                }
                self.paySuccess()
            }
            self.okBtn?.isUserInteractionEnabled = true
        }
    }
    
    private func businessOrder(images: String, pid: String) {
        let tempArr = NSMutableArray()
        for m in fileModelArr {
            let d: NSDictionary = ["file_path": m.remotePath,"file_name":m.localPath,"file_size":m.fileSize]
            tempArr.add(d)
        }
        let fileDict: NSDictionary = ["files": tempArr]
        let filesStr = fileDict.mj_JSONString() ?? ""
        let prams: NSDictionary = ["problem":content,"images":images,"attribute":filesStr,"pid":pid,"pay_type":"4","order_type":"2"]
        HomeManager.share.orderCreate(prams: prams) { (flag, sn) in
            if flag {
                if sn != nil {
                    self.detailDataSource(sn: sn!)
                    UserInfo.setStandard(key: self.key_content, text: nil)
                    JPHAssetManager.share.clear(id: self.id)
                    JFMManager.share.clear(id: self.id)
                    
//                    let m = MessageModel()
//                    m.order_sn = sn!
//                    let vc = MessageDetailController()
//                    vc.model = m
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    UserInfo.setStandard(key: self.key_content, text: nil)
                }
            }
        }
    }
}
