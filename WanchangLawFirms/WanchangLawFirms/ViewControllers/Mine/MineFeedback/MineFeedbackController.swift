//
//  MineFeedbackController.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import Photos

/// 意见反馈
class MineFeedbackController: BaseController {
    
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: 0)
        temp.separatorStyle = .none
        temp.delegate = self
        temp.dataSource = self
        temp.register(MineFeedbackTitleCell.self, forCellReuseIdentifier: "MineFeedbackTitleCell")
        temp.register(MineFeedbackTypeCell.self, forCellReuseIdentifier: "MineFeedbackTypeCell")
        temp.register(ConsultTextImgCell.self, forCellReuseIdentifier: "ConsultTextImgCell")
        temp.register(MineFeedbackTFCell.self, forCellReuseIdentifier: "MineFeedbackTFCell")
        temp.register(JOKBtnCell.self, forCellReuseIdentifier: "JOKBtnCell")
        self.view.addSubview(temp)
        return temp
    }()
    private let bindArr: [String] = ["m_type_label","type","m_question_desc","textImg","m_contact_way","tf","submit"]
    private var content: String = ""
    private var type: String = "1"
    private var mobile: String = ""
    private var tempSender: UIButton?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("mine_feedback")
        self.tabView.reloadData()
    }
    

}

extension MineFeedbackController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bindArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bind = bindArr[indexPath.row]
        if bind == "type" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineFeedbackTypeCell", for: indexPath) as! MineFeedbackTypeCell
            cell.delegate = self
            return cell
        } else if bind == "textImg" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConsultTextImgCell", for: indexPath) as! ConsultTextImgCell
            cell.photoView.delegate = self
            cell.tv.delegate = self
            cell.tv.placeholder = L$("p_enter_your_feedback_warm")
            cell.doneView.bind = ""
            return cell
        } else if bind == "tf" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineFeedbackTFCell", for: indexPath) as! MineFeedbackTFCell
            cell.tf.delegate = self
            cell.tf.placeholder = L$("p_suggest_your_mobile")
            return cell
        } else if bind == "submit" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JOKBtnCell", for: indexPath) as! JOKBtnCell
            cell.delegate = self
            cell.btn.setTitle(L$(bind), for: .normal)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MineFeedbackTitleCell", for: indexPath) as! MineFeedbackTitleCell
        cell.lab.text = L$(bind)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let bind = bindArr[indexPath.row]
        if bind == "type" {
            return 70
        } else if bind == "textImg" {
            let row = (JPhotoCenter.share.selectedAsset.count + 3) / 3
            var h = (kDeviceWidth - 40) / 3 * CGFloat(row) + CGFloat(row - 1) * 10 + 20
            if h > kDeviceWidth {
                h = kDeviceWidth
            }
            return 210 + h
        } else if bind == "tf" {
            return 50
        } else if bind == "submit" {
            return 100
        }
        return 40
    }
}

extension MineFeedbackController: MineFeedbackTypeCellDelegate {
    func mineFeedbackTypeCellClick(type: String) {
        self.type = type
    }
}

extension MineFeedbackController: JPhotoCenterDelegate {
    func jphotoCenterEnd(assets: [PHAsset]) {
        self.tabView.reloadData()
    }
    
    func jPhotoCenterUploadFinish() {
        for m in JPhotoCenter.share.selectedAsset {
            if m.upload_success != true {
                PromptTool.promptText(L$("upload_fail"), 1)
                self.tempSender?.isUserInteractionEnabled = true
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

extension MineFeedbackController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "" {
            return true
        }
        if textView.text.count + text.count > 500 {
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        content = textView.text
    }
}

extension MineFeedbackController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        if string == "" {
            return true
        }
        if textField.text != nil && textField.text!.count > 25 {
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        mobile = textField.text ?? ""
        self.tabView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let cell = textField.superview as? UITableViewCell
        if cell != nil {
            let tempY = cell!.frame.origin.y
            self.tabView.setContentOffset(CGPoint.init(x: 0, y: tempY - 200), animated: true)
        }
    }
    
}

extension MineFeedbackController: JOKBtnCellDelegate {
    func jOKBtnCellClick(sender: UIButton) {
        self.view.endEditing(true)
        if content.haveTextStr() != true {
            PromptTool.promptText(L$("p_enter_your_feedback"), 1)
            return
        }
        if HTTPManager.share.net_unavaliable {
            PromptTool.promptText(L$("net_unavailable"), 1)
            return
        }
        sender.isUserInteractionEnabled = false
        tempSender = sender
        if JPhotoCenter.share.selectedAsset.count > 0 {
            JPhotoCenter.share.uploadToOss(objKey: "uploads/feedback/")
        } else {
            self.commit(images: "")
        }
    }
    
    private func commit(images: String) {
        let prams: NSDictionary = ["type":type,"content":content,"images":images,"mobile":mobile]
        HomeManager.share.userFeedback(prams: prams) { (flag) in
            if flag {
                JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: "提交成功", message: nil, sure: L$("sure"), cancel: nil, sureHandler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }, cancelHandler: nil)
            } else {
                self.tempSender?.isUserInteractionEnabled = true
            }
        }
    }
}
