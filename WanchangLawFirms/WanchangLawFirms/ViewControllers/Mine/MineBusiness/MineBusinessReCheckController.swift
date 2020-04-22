//
//  MineBusinessReCheckController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/3/11.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MineBusinessReCheckController: BaseController {
    
    private var dataArr: [[String]] = [[String]]()
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .grouped, space: kLeftSpaceS)
        temp.delegate = self
        temp.dataSource = self
        temp.bounces = false
        okView.delegate = self
        okView.btn.setTitle("提交审核", for: .normal)
        temp.tableFooterView = okView
        temp.register(MBLabCell.self, forCellReuseIdentifier: "MBLabCell")
        temp.register(MBImgCell.self, forCellReuseIdentifier: "MBImgCell")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.view.addSubview(temp)
        return temp
    }()
    private let okView: JOKBtnView = JOKBtnView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 120))
    
    private var name: String?
    private var code: String?
    private var legal: String?
    private var id_card: String?
    private var img: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = UserInfo.share.businessModel?.show_title
        self.getDataSource()
    }
    
    private func getDataSource() {
        let bindArr1: [String] = ["m_business_name","m_business_code"]
        let bindArr2: [String] = ["m_business_photo","m_business_legal","m_business_id_card"]
        dataArr.append(bindArr1)
        dataArr.append(bindArr2)
        name = UserInfo.share.businessModel?.name
        code = UserInfo.share.businessModel?.sn
        legal = UserInfo.share.businessModel?.owner_name
        id_card = UserInfo.share.businessModel?.owner_sn
        self.tabView.reloadData()
    }
    
}

extension MineBusinessReCheckController: UITableViewDelegate, UITableViewDataSource {
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
            cell.hideArrow = false
            if img != nil {
                cell.type = 1
            } else {
                cell.type = 0
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MBLabCell", for: indexPath) as! MBLabCell
        cell.bind = bind
        cell.hideArrow = false
        if bind == "m_business_name" {
            if name?.haveTextStr() == true {
                cell.tailLab.text = name
            } else {
                cell.tailLab.text = L$("un_fill")
            }
        } else if bind == "m_business_code" {
            if code?.haveTextStr() == true {
                cell.tailLab.text = code
            } else {
                cell.tailLab.text = L$("un_fill")
            }
        } else if bind == "m_business_legal" {
            if legal?.haveTextStr() == true {
                cell.tailLab.text = legal
            } else {
                cell.tailLab.text = L$("un_fill")
            }
        } else if bind == "m_business_id_card" {
            if id_card?.haveTextStr() == true {
                cell.tailLab.text = id_card
            } else {
                cell.tailLab.text = L$("un_fill")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        if section == 3 {
            return 20
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
}

extension MineBusinessReCheckController: OLPickerViewDelegate {
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

extension MineBusinessReCheckController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

extension MineBusinessReCheckController: OLAlertTFViewDelegate {
    func olalertTFViewOKClick(titleBind: String, text: String) {
        if titleBind == "m_business_name" {
            name = text
        } else if titleBind == "m_business_code" {
            code = text
        } else if titleBind == "m_business_legal" {
            legal = text
        } else if titleBind == "m_business_id_card" {
            id_card = text
        }
        self.tabView.reloadData()
    }
}

extension MineBusinessReCheckController: JOKBtnCellDelegate {
    func jOKBtnCellClick(sender: UIButton) {
        if name?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_m_business_name"), 1)
            return
        }
        if code?.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_m_business_code"), 1)
            return
        }
        if code!.count != 18 {
            PromptTool.promptText("统一社会信用代码为18位", 1)
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
        if id_card!.count != 18 {
            PromptTool.promptText("身份证号码固定为18位", 1)
            return
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
        OSSManager.initWithShare().uploadImage(img!, isOriginal: true, objKey: "uploads/business/", progress: { (progress) in
            
        }) { (endPath) in
            if endPath.haveTextStr() == true {
                let prams: NSDictionary = ["exa_sn":self.code!,"exa_name":self.name!,"exa_owner_name":self.legal!,"exa_owner_sn":self.id_card!,"exa_image":endPath]
                LRManager.share.companyInfoExa(prams: prams, success: { (flag) in
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

