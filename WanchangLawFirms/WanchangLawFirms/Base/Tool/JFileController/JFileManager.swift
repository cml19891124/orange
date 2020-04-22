//
//  JFileManager.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/15.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 文件管理
class JFileManager: NSObject {
    static let share = JFileManager()
    
    private var dataArr: [JFileModel] = [JFileModel]()
    private var historyArr: [JFileModel] = [JFileModel]()
    private var index: Int = 1
    
    /// 添加下载好的文件
    func addFile(model: JFileModel) {
        RealmManager.share().addFile(model)
    }
    
    /// 获取所有本地文件
    func getAllFiles() -> [JFileModel] {
        let temp = RealmManager.share().getAllFiles(false)
        return temp
    }
    
    /// 删除文件
    func deleteFile(model: JFileModel) {
        RealmManager.share().deleteFile(model)
    }
    
    /// 判断文件是否已下载
    func alreadyExist(remotePath: String) -> String? {
        if self.historyArr.count == 0 {
            self.loadAllFiles()
        }
        let history = RealmManager.share().getOneFile(remotePath)
        if history.remotePath == remotePath {
            return history.localPath
        }
        return nil
    }
    
    private func loadAllFiles() {
        historyArr = RealmManager.share().getAllFiles(true)
    }

}

extension JFileManager {
    func uploadToOrange(model: JSocketModel, success:@escaping(JFileModel?) -> Void) {
        let promptV = JPhotoPromptView.init(bind: "正在发送。。。  0%")
        OSSManager.initWithShare().uploadFileURL(model.j_share_local_full_url!, objKey: model.content, progress: { (progress) in
            promptV.text = String.init(format: "正在发送。。。%.0f", progress * 100) + "%"
        }) { (endPath) in
            promptV.removeFromSuperview()
            if endPath.haveTextStr() == true {
                PromptTool.promptText("上传成功", 1)
                self.loadAllFiles()
                let fileM = JFileModel.init(remotePath: endPath, name: model.attributeModel.msg_file_name, fileSize: model.attributeModel.msg_file_length)
                fileM.localPath = self.getLocalPath(name: model.attributeModel.msg_file_name)
                let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: (model.j_share_local_full_url?.path)!), options: Data.ReadingOptions.mappedIfSafe)
                try? data?.write(to: URL.init(fileURLWithPath: OSSManager.initWithShare().savePath(fileM.localPath)))
                JFileManager.share.addFile(model: fileM)
                success(fileM)
            } else {
                PromptTool.promptText("上传失败", 1)
                success(nil)
            }
        }
    }
}

extension JFileManager {
    func addTask(model: JFileModel) {
        for m in dataArr {
            if m.remotePath == model.remotePath {
                return
            }
        }
        self.dataArr.append(model)
        self.startDownload(model: model)
    }
}

extension JFileManager {
    private func startDownload(model: JFileModel) {
        self.index = 1
        model.localPath = self.getLocalPath(name: model.name)
        OSSManager.initWithShare().downloadFile(model.remotePath, localPath: model.localPath, progress: { (progress) in
            model.progress(progress)
        }) { (endPath) in
            if endPath.haveTextStr() {
                JFileManager.share.addFile(model: model)
                self.historyArr.append(model)
            }
            for i in 0..<self.dataArr.count {
                let m = self.dataArr[i]
                if m.remotePath == model.remotePath {
                    self.dataArr.remove(at: i)
                    break
                }
            }
            model.success(endPath)
        }
    }
    
    private func getLocalPath(name: String) -> String {
        for m in historyArr {
            if m.localPath == name {
                let tail = "." + (name as NSString).pathExtension
                let head = (name as NSString).replacingOccurrences(of: tail, with: "")
                let tag = head.components(separatedBy: CharacterSet.init(charactersIn: " -")).last ?? ""
                let real_head = (head as NSString).replacingOccurrences(of: " -\(tag)", with: "")
                let temp = String.init(format: "%@ -%d%@", real_head, index, tail)
                index += 1
                return self.getLocalPath(name: temp)
            }
        }
        index = 1
        return name
    }
}


extension JFileManager {
    func getFileImgName(remotePath: String) -> String {
        var imgName: String = ""
        let sub = ((remotePath as NSString).pathExtension as NSString).lowercased
        if sub == "jpeg" || sub == "jpg" {
            imgName = "file_img"
        } else if sub == "apk" {
            imgName = "file_apk"
        } else if sub == "xls" || sub == "xlsx" {
            imgName = "file_excel"
        } else if sub == "ipa" {
            imgName = "file_ipa"
        } else if sub == "mp3" {
            imgName = "file_mp3"
        } else if sub == "pdf" {
            imgName = "file_pdf"
        } else if sub == "ppt" || sub == "pptx" {
            imgName = "file_ppt"
        } else if sub == "txt" {
            imgName = "file_text"
        } else if sub == "mp4" || sub == "mov" || sub == "avi" || sub == "qt" || sub == "asf" || sub == "rm" || sub == "mpg" || sub == "dat" || sub == "mpeg" {
            imgName = "file_video"
        } else if sub == "doc" || sub == "docx" {
            imgName = "file_word"
        } else if sub == "xml" {
            imgName = "file_xml"
        } else if sub == "zip" || sub == "rar" {
            imgName = "file_zip"
        } else {
            imgName = "file_unknow"
        }
        return imgName
    }
}
