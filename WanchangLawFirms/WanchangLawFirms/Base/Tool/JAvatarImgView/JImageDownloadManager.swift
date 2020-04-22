//
//  JImageDownloadManager.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/6.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 图片下载管理
class JImageDownloadManager: NSObject {
    static let share = JImageDownloadManager()

    private let imgView = UIImageView()
    private var dataArr: [JAvatarImgModel] = [JAvatarImgModel]()
    
    func addTask(model: JAvatarImgModel) {
        var exist = false
        for m in dataArr {
            if m.remotePath == model.remotePath {
                exist = true
                break
            }
        }
        self.dataArr.append(model)
        if !exist {
            self.startDownload(model: model)
        }
    }
    
    func snapOSSPath(path: String, success:@escaping(String) -> Void) {
        OSSManager.initWithShare().downloadSnapImg(path, progress: { (progress) in
            
        }) { (endPath) in
            JQueueManager.share.mainAsyncQueue {
                success(endPath)
            }
        }
    }
}

extension JImageDownloadManager {
    private func startDownload(model: JAvatarImgModel) {
        let remotePath = model.remotePath
        let ns = (remotePath as NSString)
        if ns.contains("http://") || ns.contains("https://") {
            imgView.sd_setImage(with: URL.init(string: remotePath)) { (img, err, cache, url) in
                self.finish(model: model, endPath: nil, img: img)
            }
        } else {
            self.snapOSSPath(path: remotePath) { (endPath) in
                self.finish(model: model, endPath: endPath, img: nil)
            }
        }
    }
    
    private func finish(model: JAvatarImgModel, endPath: String?, img: UIImage?) {
        var i = 0
        for _ in 0..<self.dataArr.count {
            let m = self.dataArr[i]
            if m.remotePath == model.remotePath {
                m.success(model.remotePath, endPath, img)
                self.dataArr.remove(at: i)
            } else {
                i += 1
            }
        }
    }
}
