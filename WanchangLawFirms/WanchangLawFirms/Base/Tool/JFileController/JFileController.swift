//
//  JFileController.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/15.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 文件列表控制器
class JFileController: BaseController {
    
    var block = { (fileArr: [JFileModel]) in
        
    }
    var fileMaxCount: Int = 9
    
    var messageModel: MessageModel = MessageModel()
    
    private lazy var sendBtn: JFileSendBtn = {
        () -> JFileSendBtn in
        let temp = JFileSendBtn.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44), titleStr: L$("send"))
        temp.addTarget(self, action: #selector(sendClick), for: .touchUpInside)
        return temp
    }()
    private lazy var listView: JTabNotiView = {
        () -> JTabNotiView in
        let temp = JTabNotiView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - 50), style: .plain, space: kLeftSpaceS)
        let tabView = temp.tabView
        tabView.bounces = false
        tabView.delegate = self
        tabView.dataSource = self
        tabView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        tabView.register(JFileCell.self, forCellReuseIdentifier: "JFileCell")
        self.view.addSubview(temp)
        return temp
    }()
    private var dataArr: [JFileModel] = [JFileModel]()
    private var selectedArr: [JFileModel] = [JFileModel]()
    private lazy var documentTypes: [String] = {
        () -> [String] in
        let temp = [
            "com.microsoft.powerpoint.ppt",
            "public.item",
            "com.microsoft.word.doc",
            "com.adobe.pdf",
            "com.microsoft.excel.xls",
            "public.image",
            "public.content",
            "public.composite-content",
            "public.archive",
            "public.audio",
            "public.movie",
            "public.text",
            "public.data"
        ]
        return temp
    }()
    private lazy var localBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontM, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(btnClick))
        temp.backgroundColor = kOrangeDarkColor
        temp.frame = CGRect.init(x: 0, y: kDeviceHeight - 50, width: kDeviceWidth, height: 50)
        temp.setTitle("查找本机文件", for: .normal)
        self.view.addSubview(temp)
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("chat_file")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.sendBtn)
        self.sendBtn.isEnabled = false
        self.localBtn.isHidden = false
        self.getDataSource()
    }
    
    private func getDataSource() {
        let tempArr = JFileManager.share.getAllFiles()
        self.dataArr = tempArr.reversed()
        self.refresh()
    }
    
    private func refresh() {
        if self.dataArr.count == 0 {
            self.listView.imgName = "no_data_file"
        }
        self.listView.tabView.reloadData()
    }
    
    private func judgeSendStatus() {
        if selectedArr.count > 0 {
            self.sendBtn.isEnabled = true
            let tempStr = L$("send") + "(\(selectedArr.count))"
            self.sendBtn.setTitle(tempStr, for: .normal)
        } else {
            self.sendBtn.isEnabled = false
        }
    }
    
    @objc private func sendClick() {
        self.block(selectedArr)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func btnClick() {
        let documentPickerVC = JFilePickerController.init(documentTypes: documentTypes, in: UIDocumentPickerMode.open)
        documentPickerVC.modalPresentationStyle = .formSheet
        documentPickerVC.delegate = self
//        self.navigationController?.pushViewController(documentPickerVC, animated: true)
        self.present(documentPickerVC, animated: true, completion: nil)
    }

}

extension JFileController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "JFileCell", for: indexPath) as! JFileCell
        cell.delegate = self
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataArr[indexPath.row]
        let vc = JFilePreviewController()
        vc.path = OSSManager.initWithShare().savePath(model.localPath)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return L$("delete")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row]
        let titleStr = L$("p_sure_delete") + model.name + "?"
        JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: titleStr, message: nil, sure: L$("sure"), cancel: L$("cancel"), sureHandler: { (action) in
            let model = self.dataArr[indexPath.row]
            JFileManager.share.deleteFile(model: model)
            self.dataArr.remove(at: indexPath.row)
            self.refresh()
        }, cancelHandler: nil)
    }
}

extension JFileController: JFileCellDelegate {
    func jFileCellSelectClick(sender: UIButton, model: JFileModel) {
        if model.selected == false {
            if self.selectedArr.count >= fileMaxCount {
                let showStr = "文件最多不超过\(fileMaxCount)个"
                PromptTool.promptText(showStr, 1)
                return
            }
        }
        model.selected = !model.selected
        sender.isSelected = model.selected
        if model.selected {
            self.selectedArr.append(model)
        } else {
            for i in 0..<self.selectedArr.count {
                let m = self.selectedArr[i]
                if m == model {
                    self.selectedArr.remove(at: i)
                    break
                }
            }
        }
        self.judgeSendStatus()
    }
}

extension JFileController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let fileUrlAuth = urls.first?.startAccessingSecurityScopedResource()
        if fileUrlAuth == true {
            let fileCoordinator = NSFileCoordinator()
            fileCoordinator.coordinate(readingItemAt: urls.first!, options: NSFileCoordinator.ReadingOptions.init(rawValue: 0), error: nil) { (url) in
                let fileData = try? Data.init(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
                if fileData != nil {
                    if fileData!.count > 1024 * 1024 * 30 {
                        PromptTool.promptText("大小不能超过30M", 1)
                        urls.first?.stopAccessingSecurityScopedResource()
                    } else {
                        let fileName = url.lastPathComponent
                        let pathExten = (fileName as NSString).pathExtension
                        let prams: NSDictionary = ["msg_file_name":fileName,"msg_file_length":"\(fileData!.count)"]
                        
                        let model = JSocketModel.init(to: "", sn: "")
                        model.type = socket_value_file
                        model.attribute = prams.mj_JSONString()
                        model.content = OSSManager.initWithShare().uniqueString(by: "chat/files/", pathExten: pathExten)
                        model.j_share_local_full_url = url
                        JFileManager.share.uploadToOrange(model: model, success: { (m) in
                            urls.first?.stopAccessingSecurityScopedResource()
                            self.getDataSource()
                            if m != nil {
                                self.selectedArr.append(m!)
                                self.block(self.selectedArr)
                                self.navigationController?.popViewController(animated: true)
                            }
                        })
                        
//                        let prams: NSDictionary = ["msg_file_name":fileName,"msg_file_length":"\(fileData!.count)"]
//                        let model = JSocketModel.init(to: self.messageModel.id, sn: self.messageModel.order_sn)
//                        model.type = socket_value_file
//                        model.attribute = prams.mj_JSONString()
//                        model.content = OSSManager.initWithShare().uniqueString(by: "chat/files/", pathExten: pathExten)
//                        model.j_share_local_full_url = url
//                        JShareMessageTool.share.shareSendFile(model: model, success: { (flag) in
//                            self.navigationController?.popViewController(animated: true)
//                            urls.first?.stopAccessingSecurityScopedResource()
//                        })
                    }
                } else {
                    urls.first?.stopAccessingSecurityScopedResource()
                }
            }
        } else {
            urls.first?.stopAccessingSecurityScopedResource()
            DEBUG("授权失败")
        }
    }
}
