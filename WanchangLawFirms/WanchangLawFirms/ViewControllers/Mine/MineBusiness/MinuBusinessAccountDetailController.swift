//
//  MinuBusinessAccountDetailController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/17.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 企业账号详情
class MinuBusinessAccountDetailController: BaseController {
    
    var model: UserModel!
    
    private lazy var bindArr: [String] = {
        () -> [String] in
        var temp = ["m_avatar","m_business_username","m_business_password","m_business_contact","m_business_mobile","m_business_email"]
        if UserInfo.share.isMother && UserInfo.share.businessModel?.uid != model.uid {
            temp.append("delete")
        }
        return temp
    }()
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: kLeftSpaceS)
        temp.separatorColor = kLineGrayColor
        temp.delegate = self
        temp.dataSource = self
        temp.register(MBAccountDetailAvatarCell.self, forCellReuseIdentifier: "MBAccountDetailAvatarCell")
        temp.register(MBAccountDetailCell.self, forCellReuseIdentifier: "MBAccountDetailCell")
        temp.register(JOKBtnCell.self, forCellReuseIdentifier: "JOKBtnCell")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.view.addSubview(temp)
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "账号信息"
        self.tabView.reloadData()
    }

}

extension MinuBusinessAccountDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bindArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bind = bindArr[indexPath.row]
        if bind == "delete" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JOKBtnCell", for: indexPath) as! JOKBtnCell
            cell.delegate = self
            cell.btn.setTitle("移除该账号", for: .normal)
            return cell
        } else if bind == "m_avatar" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MBAccountDetailAvatarCell", for: indexPath) as! MBAccountDetailAvatarCell
            cell.bind = bind
            cell.model = model
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MBAccountDetailCell", for: indexPath) as! MBAccountDetailCell
        cell.bind = bind
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! MBAccountBaseCell
        if cell.hideArrow {
            return
        }
        let bind = bindArr[indexPath.row]
        if bind == "m_avatar" {
            OLAlertManager.share.profilePickerShow(isAvatar: true)
            OLAlertManager.share.profilePickerView?.delegate = self
            return
        }
        var text = ""
        if bind == "m_business_contact" {
            text = model.co_name
        } else if bind == "m_business_mobile" {
            text = model.co_mobile
        } else if bind == "m_business_email" {
            text = model.co_email
        }
        var placeholder = bind
        if bind == "m_business_password" {
            placeholder = "p_pass_limit"
        }
        OLAlertManager.share.tfShow(titleBind: bind, placeholderBind: placeholder, text: text)
        OLAlertManager.share.tfView?.delegate = self
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let bind = bindArr[indexPath.row]
        if bind == "delete" {
            return 120
        }
        return kCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
}

extension MinuBusinessAccountDetailController: OLPickerViewDelegate {
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

extension MinuBusinessAccountDetailController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            guard let result = picker.resultImage(info: info, isOriginal: true) else {
                return
            }
            OSSManager.initWithShare().uploadImage(result, isOriginal: false, objKey: "uploads/avatar/", progress: { (progress) in
                
            }) { (remotePath) in
                if remotePath.haveTextStr() == true {
                    let mulPrams: NSMutableDictionary = NSMutableDictionary()
                    mulPrams["user_id"] = self.model.uid
                    mulPrams["avatar"] = remotePath
                    UserInfo.share.companyAccountEdit(prams: mulPrams) { (flag) in
                        if flag {
                            UserInfo.share.companyAccountList(success: { (falg) in
                                
                            })
                            self.model.avatar = remotePath
                            PromptTool.promptText(L$("p_edit_success"), 1)
                            self.tabView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

extension MinuBusinessAccountDetailController: OLAlertTFViewDelegate {
    func olalertTFViewOKClick(titleBind: String, text: String) {
        let mulPrams: NSMutableDictionary = NSMutableDictionary()
        mulPrams["user_id"] = model.uid
        if titleBind == "m_business_username" {
            if model.co_username == text {
                return
            }
            mulPrams["user_id"] = text
        } else if titleBind == "m_business_password" {
            if text.count < 8 || text.count > 20 {
                PromptTool.promptText(L$("p_pass_limit"), 1)
                return
            }
            mulPrams["password"] = text
        } else if titleBind == "m_business_contact" {
            if model.co_name == text {
                return
            }
            mulPrams["name"] = text
        } else if titleBind == "m_business_mobile" {
            if model.co_mobile == text {
                return
            }
            mulPrams["mobile"] = text
        } else if titleBind == "m_business_email" {
            if model.co_email == text {
                return
            }
            mulPrams["email"] = text
        }
        UserInfo.share.companyAccountEdit(prams: mulPrams) { (flag) in
            if flag {
                UserInfo.share.companyAccountList(success: { (flag) in
                    
                })
                if titleBind == "m_business_username" {
                    self.model.co_username = text
                } else if titleBind == "m_business_password" {
                    
                } else if titleBind == "m_business_contact" {
                    self.model.co_name = text
                } else if titleBind == "m_business_mobile" {
                    self.model.co_mobile = text
                } else if titleBind == "m_business_email" {
                    self.model.co_email = text
                }
                PromptTool.promptText(L$("p_edit_success"), 1)
                self.tabView.reloadData()
            }
        }
    }
}

extension MinuBusinessAccountDetailController: JOKBtnCellDelegate {
    func jOKBtnCellClick(sender: UIButton) {
        JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: "确定移除该账号？", message: nil, sure: L$("sure"), cancel: L$("cancel"), sureHandler: { (action) in
            let prams: NSDictionary = ["user_id": self.model.uid]
            UserInfo.share.companyAccountDel(prams: prams) { (flag) in
                if flag {
                    UserInfo.share.companyAccountList(success: { (flag) in
                        
                    })
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }, cancelHandler: nil)
    }
}
