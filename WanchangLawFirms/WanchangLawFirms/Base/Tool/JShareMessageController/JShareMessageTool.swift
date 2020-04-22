//
//  JShareMessageTool.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/6.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

protocol JShareMessageToolDelegate: NSObjectProtocol {
    func jShareMessageToolSendFinish(msg: STMessage)
}

class JShareMessageTool: NSObject {
    static let share = JShareMessageTool()
    weak var delegate: JShareMessageToolDelegate?
    
    private var promptV: JPhotoPromptView?
    
    func shareSendFile(model: JSocketModel, success:@escaping(Bool) -> Void) {
        promptV = JPhotoPromptView.init(bind: "正在发送。。。  0%")
        OSSManager.initWithShare().uploadFileURL(model.j_share_local_full_url!, objKey: model.content, progress: { (progress) in
            self.promptV?.text = String.init(format: "正在发送。。。%.0f", progress * 100) + "%"
        }) { (endPath) in
            self.promptV?.removeFromSuperview()
            self.promptV = nil
            PromptTool.promptText("发送成功", 1)
            success(endPath.haveTextStr())
            self.sendModel(model: model)
        }
    }
    
    func uploadToOrange(model: JSocketModel, success:@escaping(Bool) -> Void) {
        promptV = JPhotoPromptView.init(bind: "正在发送。。。  0%")
        OSSManager.initWithShare().uploadFileURL(model.j_share_local_full_url!, objKey: model.content, progress: { (progress) in
            self.promptV?.text = String.init(format: "正在发送。。。%.0f", progress * 100) + "%"
        }) { (endPath) in
            self.promptV?.removeFromSuperview()
            self.promptV = nil
            PromptTool.promptText("上传成功", 1)
            let fileM = JFileModel.init(remotePath: endPath, name: model.attributeModel.msg_file_name, fileSize: model.attributeModel.msg_file_length)
            fileM.localPath = model.attributeModel.msg_file_name
            let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: (model.j_share_local_full_url?.path)!), options: Data.ReadingOptions.mappedIfSafe)
            try? data?.write(to: URL.init(fileURLWithPath: OSSManager.initWithShare().savePath(fileM.localPath)))
            JFileManager.share.addFile(model: fileM)
            success(endPath.haveTextStr())
        }
    }
}

extension JShareMessageTool {
    private func sendModel(model: JSocketModel) {
        let msg = STMessage.init(model: model)
        self.delegate?.jShareMessageToolSendFinish(msg: msg)
        ChatManager.share.addChatMsg(msg: msg)
    }
}
