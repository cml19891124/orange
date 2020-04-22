//
//  MineProfileController.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 个人资料
class MineProfileController: BaseController {
    
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: kLeftSpaceS)
        temp.delegate = self
        temp.dataSource = self
        temp.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        temp.register(MineProfileCell.self, forCellReuseIdentifier: "MineProfileCell")
        temp.register(MineProfileAvatarCell.self, forCellReuseIdentifier: "MineProfileAvatarCell")
        temp.register(MBLabCell.self, forCellReuseIdentifier: "MBLabCell")
        self.view.addSubview(temp)
        return temp
    }()
    
    private let bindArr: [String] = ["m_avatar","m_nickname","m_sex","m_area","m_mobile","m_email", "m_recommender"]
    
    private var selected_img: UIImage?
    
    private lazy var mulPrams: NSMutableDictionary = {
        () -> NSMutableDictionary in
        let temp = NSMutableDictionary()
//        temp["nickname"] = UserInfo.share.model?.nickname ?? ""
//        temp["avatar"] = UserInfo.share.model?.avatar ?? ""
//        temp["sex"] = UserInfo.share.model?.sex ?? ""
//        temp["address"] = UserInfo.share.model?.address ?? ""
//        temp["email"] = UserInfo.share.model?.email ?? ""
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("mine_profile")
        self.personDataRefresh()
        NotificationCenter.default.addObserver(self, selector: #selector(personDataRefresh), name: NSNotification.Name(rawValue: noti_user_model_refresh), object: nil)
    }
    
    @objc private func personDataRefresh() {
        self.tabView.reloadData()
    }
    
}

extension MineProfileController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bindArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bind = bindArr[indexPath.item]
        if indexPath.row == 0 {
            let cell = tabView.dequeueReusableCell(withIdentifier: "MineProfileAvatarCell", for: indexPath) as! MineProfileAvatarCell
            cell.bind = bind
            if selected_img != nil {
                cell.img = selected_img
            } else {
                cell.remotePath = UserInfo.share.model?.avatar
            }
            return cell
        }
        if bind == "m_recommender" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MBLabCell", for: indexPath) as! MBLabCell
            cell.bind = bind
            if let contact = UserInfo.share.model?.recommend_id, contact.count > 0 {
                cell.tailLab.text = contact
                cell.hideArrow = true
            } else {
                cell.tailLab.text = ""
                cell.hideArrow = false
            }
            return cell
        }
        let cell = tabView.dequeueReusableCell(withIdentifier: "MineProfileCell", for: indexPath) as! MineProfileCell
        cell.bind = bind
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tabView.deselectRow(at: indexPath, animated: true)
        let bind = bindArr[indexPath.row]
        if bind == "m_avatar" {
            OLAlertManager.share.profilePickerShow(isAvatar: true)
            OLAlertManager.share.profilePickerView?.delegate = self
//            JAuthorizeManager.init(view: self.view).alertCameraAlbum(titleStr: "请选择头像", allowsEditing: false, addDelegate: self)
        } else if bind == "m_nickname" {
            OLAlertManager.share.tfShow(titleBind: "p_enter_nickname", placeholderBind: "p_enter_nickname", text: UserInfo.share.model?.nickname)
            OLAlertManager.share.tfView?.delegate = self
        } else if bind == "m_sex" {
            OLAlertManager.share.profilePickerShow(isAvatar: false)
            OLAlertManager.share.profilePickerView?.delegate = self
        } else if bind == "m_area" {
            let pickerArea = STPickerArea()
            pickerArea.delegate = self
            pickerArea.contentMode = .bottom
            pickerArea.show()
        } else if bind == "m_mobile" {
            if UserInfo.share.model?.mobile.haveTextStr() == true {
                let vc = MineEditMobileController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = MineBindMobileController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if bind == "m_email" {
            OLAlertManager.share.tfShow(titleBind: "p_enter_email", placeholderBind: "p_enter_email", text: UserInfo.share.model?.email)
            OLAlertManager.share.tfView?.delegate = self
        } else if bind == "m_recommender" {
            if let contact = UserInfo.share.model?.recommend_id, contact.count > 0 {
                return
            }
            OLAlertManager.share.tfShow(titleBind: "p_enter_recommender", placeholderBind: "p_enter_recommender", text: UserInfo.share.model?.email)
            OLAlertManager.share.tfView?.delegate = self
        }
    }
}

extension MineProfileController: OLPickerViewDelegate {
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
        } else if bind == "sex_man" {
            if UserInfo.share.model?.sex == "1" {
                return
            }
            mulPrams["sex"] = "1"
            self.lastUpload()
        } else if bind == "sex_woman" {
            if UserInfo.share.model?.sex == "2" {
                return
            }
            mulPrams["sex"] = "2"
            self.lastUpload()
        }
    }
}

extension MineProfileController: OLAlertTFViewDelegate {
    func olalertTFViewOKClick(titleBind: String, text: String) {
        if text.haveTextStr() == false {
            return
        }
        if titleBind == "p_enter_nickname" {
            if UserInfo.share.model?.nickname == text {
                return
            }
            mulPrams["nickname"] = text
        } else if titleBind == "p_enter_email" {
            if UserInfo.share.model?.email == text {
                return
            }
            if !BaseUtil.emailValid(email: text) {
                PromptTool.promptText(L$("p_enter_valid_email"), 1)
                return
            }
            mulPrams["email"] = text
        } else if titleBind == "p_enter_recommender" {
            if UserInfo.share.model?.recommend_id == titleBind {
                return
            }
            if !text.haveTextStr() {
                return
            }
            mulPrams["recommend_id"] = text
        }
        self.lastUpload()
    }
}

extension MineProfileController: STPickerAreaDelegate {
    func pickerArea(_ pickerArea: STPickerArea, province: String, city: String, area: String) {
        var tempStr = ""
        if province == city {
            tempStr = city + area
        } else {
            tempStr = province + city + area
        }
        if UserInfo.share.model?.address == tempStr {
            return
        }
        mulPrams["address"] = tempStr
        self.lastUpload()
    }
}

extension MineProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            guard let result = picker.resultImage(info: info, isOriginal: true) else {
                return
            }
            self.selected_img = result
            self.tabView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .fade)
            OSSManager.initWithShare().uploadImage(result, isOriginal: false, objKey: "uploads/avatar/", progress: { (progress) in
                
            }) { (remotePath) in
                if remotePath.haveTextStr() == true {
                    self.mulPrams["avatar"] = remotePath
                    self.lastUpload()
                }
            }
        }
    }
}

extension MineProfileController {
    func lastUpload() {
        UserInfo.share.netEditUser(prams: mulPrams) { (flag) in
            if flag {
                PromptTool.promptText("修改资料成功", 1)
            }
            UserInfo.share.netUserInfo()
        }
    }
}
