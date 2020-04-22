//
//  MineBusinessController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/10.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 我的企业
class MineBusinessController: BaseController {
    
    private var dataArr: [[String]] = [[String]]()
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .grouped, space: kLeftSpaceS)
        temp.delegate = self
        temp.dataSource = self
        temp.bounces = false
        temp.register(MBLabCell.self, forCellReuseIdentifier: "MBLabCell")
        temp.register(MBImgCell.self, forCellReuseIdentifier: "MBImgCell")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.view.addSubview(temp)
        return temp
    }()
    private var name: String?
    private var code: String?
    private var legal: String?
    private var id_card: String?
    private var contact: String?
    private var mobile: String?
    private var email: String?
    private var position: String?
    private var business: String?
    private var address: String?
    private var img: UIImage?
    private var recommend_id: String?
    
    private lazy var notiLab: UILabel = {
        () -> UILabel in
        let temp = UILabel.init(kFontMS, UIColor.white, NSTextAlignment.center)
        temp.frame = CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 40)
        temp.backgroundColor = kOrangeLightColor
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = UserInfo.share.businessModel?.show_title
        if UserInfo.share.isMother {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "重新提交审核", style: .done, target: self, action: #selector(reInput))
        }
        self.getDataSource()
        UserInfo.share.companyInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: noti_business_refresh), object: nil)
    }
    
    private func getDataSource() {
        let bindArr1: [String] = ["m_business_name","m_business_code"]
        let bindArr2: [String] = ["m_business_photo","m_business_legal","m_business_id_card"]
        let bindArr3: [String] = ["m_business_contact","m_business_mobile","m_business_email"]
        let bindArr4: [String] = ["m_business_position","m_business_address","m_business_business"]
        let bindArr5: [String] = ["m_business_recommender"]
        dataArr.append(bindArr1)
        dataArr.append(bindArr2)
        dataArr.append(bindArr3)
        dataArr.append(bindArr4)
        dataArr.append(bindArr5)
        name = UserInfo.share.businessModel?.name
        code = UserInfo.share.businessModel?.sn
        legal = UserInfo.share.businessModel?.owner_name
        id_card = UserInfo.share.businessModel?.owner_sn
        contact = UserInfo.share.businessModel?.contact_name
        mobile = UserInfo.share.businessModel?.contact_phone
        email = UserInfo.share.businessModel?.contact_email
        position = UserInfo.share.businessModel?.position
        business = UserInfo.share.businessModel?.business
        address = UserInfo.share.businessModel?.address
        self.tabView.reloadData()
    }
    
    @objc private func reInput() {
        let vc = MineBusinessReCheckController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func refresh() {
        self.tabView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        if UserInfo.share.businessModel?.exa_status == "1" {
            notiLab.text = "正在等待审核"
            self.tabView.tableHeaderView = self.notiLab
        } else if UserInfo.share.businessModel?.exa_status == "3" {
            notiLab.text = "企业资料审核未通过"
            self.tabView.tableHeaderView = self.notiLab
        }
        self.tabView.reloadData()
    }

}

extension MineBusinessController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = dataArr[section]
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arr = dataArr[indexPath.section]
        let bind = arr[indexPath.row]
        if bind == "m_business_photo" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MBImgCell", for: indexPath) as! MBImgCell
            cell.bind = bind
            if img != nil {
                cell.type = 1
            } else if UserInfo.share.businessModel?.image?.haveTextStr() == true {
                cell.type = 1
            } else {
                cell.type = 0
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MBLabCell", for: indexPath) as! MBLabCell
        cell.bind = bind
        if bind == "m_business_name" {
            if name?.haveTextStr() == true {
                cell.tailLab.text = name
            } else {
                cell.tailLab.text = L$("un_fill")
            }
            cell.hideArrow = true
        } else if bind == "m_business_code" {
            if code?.haveTextStr() == true {
                cell.tailLab.text = code
            } else {
                cell.tailLab.text = L$("un_fill")
            }
            cell.hideArrow = true
        } else if bind == "m_business_legal" {
            if legal?.haveTextStr() == true {
                cell.tailLab.text = legal
            } else {
                cell.tailLab.text = L$("un_fill")
            }
            cell.hideArrow = true
        } else if bind == "m_business_id_card" {
            if id_card?.haveTextStr() == true {
                cell.tailLab.text = id_card
            } else {
                cell.tailLab.text = L$("un_fill")
            }
            cell.hideArrow = true
        } else if bind == "m_business_contact" {
            if contact?.haveTextStr() == true {
                cell.tailLab.text = contact
            } else {
                cell.tailLab.text = L$("un_fill")
            }
            if UserInfo.share.isMother {
                cell.hideArrow = false
            } else {
                cell.hideArrow = true
            }
        } else if bind == "m_business_mobile" {
            if mobile?.haveTextStr() == true {
                cell.tailLab.text = mobile
            } else {
                cell.tailLab.text = L$("un_fill")
            }
            if UserInfo.share.isMother {
                cell.hideArrow = false
            } else {
                cell.hideArrow = true
            }
        } else if bind == "m_business_email" {
            if email?.haveTextStr() == true {
                cell.tailLab.text = email
            } else {
                cell.tailLab.text = L$("un_fill")
            }
            if UserInfo.share.isMother {
                cell.hideArrow = false
            } else {
                cell.hideArrow = true
            }
        } else if bind == "m_business_position" {
            if position?.haveTextStr() == true {
                cell.tailLab.text = position
            } else {
                cell.tailLab.text = L$("un_fill")
            }
            if UserInfo.share.isMother {
                cell.hideArrow = false
            } else {
                cell.hideArrow = true
            }
        } else if bind == "m_business_business" {
            if business?.haveTextStr() == true {
                cell.tailLab.text = business
            } else {
                cell.tailLab.text = L$("un_fill")
            }
            if UserInfo.share.isMother {
                cell.hideArrow = false
            } else {
                cell.hideArrow = true
            }
        } else if bind == "m_business_address" {
            if address?.haveTextStr() == true {
                cell.tailLab.text = address
            } else {
                cell.tailLab.text = L$("un_fill")
            }
            if UserInfo.share.isMother {
                cell.hideArrow = false
            } else {
                cell.hideArrow = true
            }
        } else if bind == "m_business_recommender" {
            if let contact = UserInfo.share.model?.recommend_id, contact.count > 0 {
                cell.tailLab.text = contact
                cell.hideArrow = true
            } else {
                cell.tailLab.text = ""
                cell.hideArrow = false
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let arr = dataArr[indexPath.section]
        let bind = arr[indexPath.row]
        if bind == "ok" {
            return 100
        }
        return kCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! MBBaseCell
        if cell.hideArrow {
            return
        }
        let arr = dataArr[indexPath.section]
        let bind = arr[indexPath.row]
        if bind == "ok" {
            return
        }
        if bind == "m_business_photo" {
            OLAlertManager.share.profilePickerShow(isAvatar: true)
            OLAlertManager.share.profilePickerView?.delegate = self
        } else {
            var text: String?
            if bind == "m_business_name" {
                text = name
            } else if bind == "m_business_code" {
                text = code
            } else if bind == "m_business_legal" {
                text = legal
            } else if bind == "m_business_id_card" {
                text = id_card
            } else if bind == "m_business_contact" {
                text = contact
            } else if bind == "m_business_mobile" {
                text = mobile
            } else if bind == "m_business_email" {
                text = email
            } else if bind == "m_business_position" {
                text = position
            } else if bind == "m_business_business" {
                text = business
            } else if bind == "m_business_address" {
                text = address
            } else if bind == "m_business_recommender" {
                text = recommend_id
            }
            let placeholder = "p_enter_" + bind
            OLAlertManager.share.tfShow(titleBind: bind, placeholderBind: placeholder, text: text)
            OLAlertManager.share.tfView?.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kCellSpaceL
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == dataArr.count - 1 {
            return 20
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
}

extension MineBusinessController: OLPickerViewDelegate {
    func olpickerViewClick(bind: String) {
        if bind == "camera" {
            JAuthorizeManager.init(view: self.view).cameraAuthorization {
                let picker = UIImagePickerController.init(sourceType: .camera, mediaType: 1, allowsEditing: false)
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }
        } else if bind == "album" {
            JAuthorizeManager.init(view: self.view).photoLibraryAuthorization {
                let picker = UIImagePickerController.init(sourceType: .photoLibrary, mediaType: 1, allowsEditing: false)
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }
        }
    }
}

extension MineBusinessController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            guard let result = picker.resultImage(info: info, isOriginal: true) else {
                return
            }
            self.img = result
            self.tabView.reloadData()
        }
    }
}

extension MineBusinessController: OLAlertTFViewDelegate {
    func olalertTFViewOKClick(titleBind: String, text: String) {
        if titleBind == "m_business_name" {
            name = text
        } else if titleBind == "m_business_code" {
            code = text
        } else if titleBind == "m_business_legal" {
            legal = text
        } else if titleBind == "m_business_id_card" {
            id_card = text
        } else if titleBind == "m_business_contact" {
            if text != UserInfo.share.businessModel?.contact_name {
                let prams: NSDictionary = ["contact_name": text]
                UserInfo.share.companyInfoUpdate(prams: prams) { (flag) in
                    if flag {
                        PromptTool.promptText(L$("p_edit_success"), 1)
                        self.contact = text
                        self.tabView.reloadData()
                    } else {
                        PromptTool.promptText(L$("p_edit_fail"), 1)
                    }
                }
            }
        } else if titleBind == "m_business_mobile" {
            if text != UserInfo.share.businessModel?.contact_phone {
                let prams: NSDictionary = ["contact_phone": text]
                UserInfo.share.companyInfoUpdate(prams: prams) { (flag) in
                    if flag {
                        PromptTool.promptText(L$("p_edit_success"), 1)
                        self.mobile = text
                        self.tabView.reloadData()
                    } else {
                        PromptTool.promptText(L$("p_edit_fail"), 1)
                    }
                }
            }
        } else if titleBind == "m_business_email" {
            if text != UserInfo.share.businessModel?.contact_email {
                let prams: NSDictionary = ["contact_email": text]
                UserInfo.share.companyInfoUpdate(prams: prams) { (flag) in
                    if flag {
                        PromptTool.promptText(L$("p_edit_success"), 1)
                        self.email = text
                        self.tabView.reloadData()
                    } else {
                        PromptTool.promptText(L$("p_edit_fail"), 1)
                    }
                }
            }
        } else if titleBind == "m_business_position" {
            if text != UserInfo.share.businessModel?.position {
                let prams: NSDictionary = ["position": text]
                UserInfo.share.companyInfoUpdate(prams: prams) { (flag) in
                    if flag {
                        PromptTool.promptText(L$("p_edit_success"), 1)
                        self.position = text
                        self.tabView.reloadData()
                    } else {
                        PromptTool.promptText(L$("p_edit_fail"), 1)
                    }
                }
            }
        } else if titleBind == "m_business_business" {
            if text != UserInfo.share.businessModel?.business {
                let prams: NSDictionary = ["business": text]
                UserInfo.share.companyInfoUpdate(prams: prams) { (flag) in
                    if flag {
                        PromptTool.promptText(L$("p_edit_success"), 1)
                        self.business = text
                        self.tabView.reloadData()
                    } else {
                        PromptTool.promptText(L$("p_edit_fail"), 1)
                    }
                }
            }
        } else if titleBind == "m_business_address" {
            if text != UserInfo.share.businessModel?.address {
                let prams: NSDictionary = ["address": text]
                UserInfo.share.companyInfoUpdate(prams: prams) { (flag) in
                    if flag {
                        PromptTool.promptText(L$("p_edit_success"), 1)
                        self.address = text
                        self.tabView.reloadData()
                    } else {
                        PromptTool.promptText(L$("p_edit_fail"), 1)
                    }
                }
            }
        } else if titleBind == "m_business_recommender" {
            if text != UserInfo.share.businessModel?.recommend_id && text.haveContentNet() {
                let prams: NSDictionary = ["recommend_id": text]
                UserInfo.share.companyInfoUpdate(prams: prams) { (flag) in
                    if flag {
                        PromptTool.promptText(L$("p_edit_success"), 1)
                        self.recommend_id = text
                        self.tabView.reloadData()
                    } else {
                        PromptTool.promptText(L$("p_edit_fail"), 1)
                    }
                }
            }
        }
        
    }
}

extension MineBusinessController: JOKBtnCellDelegate {
    func jOKBtnCellClick(sender: UIButton) {
        if name?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_m_business_name"), 1)
            return
        }
        if code?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_m_business_code"), 1)
            return
        }
        if legal?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_m_business_legal"), 1)
            return
        }
        if id_card?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_m_business_id_card"), 1)
            return
        }
        if contact?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_m_business_contact"), 1)
            return
        }
        if mobile?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_m_business_mobile"), 1)
            return
        }
        if email?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_m_business_email"), 1)
            return
        } else {
            if !BaseUtil.emailValid(email: email) {
                PromptTool.promptText(L$("p_enter_valid_email"), 1)
                return
            }
        }
        if img == nil {
            PromptTool.promptText(L$("p_enter_m_business_photo"), 1)
            return
        }
        JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: L$("p_sure_commit"), message: nil, sure: L$("sure"), cancel: L$("cancel"), sureHandler: { (action) in
            self.lastCommit()
        }, cancelHandler: nil)
    }
    
    private func lastCommit() {
        let v = JPhotoPromptView.init(bind: L$("p_commiting"))
        OSSManager.initWithShare().uploadImage(img!, isOriginal: true, objKey: "/uploads/business", progress: { (progress) in
            
        }) { (endPath) in
            if endPath.haveTextStr() == true {
                let prams: NSDictionary = ["sn":self.code!,"name":self.name!,"contact_name":self.contact!,"contact_phone":self.mobile!,"contact_email":self.email!,"owner_name":self.legal!,"owner_sn":self.id_card!,"image":endPath]
                LRManager.share.companyRegist(prams: prams, success: { (flag) in
                    if (flag) {
                        JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: L$("p_commit_success"), message: nil, sure: L$("sure"), cancel: nil, sureHandler: { (action) in
                            self.navigationController?.popViewController(animated: true)
                        }, cancelHandler: nil)
                    }
                    v.removeFromSuperview()
                })
            } else {
                PromptTool.promptText(L$("upload_fail"), 1)
                v.removeFromSuperview()
            }
        }
    }
}

