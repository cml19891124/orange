//
//  GifBrowserController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/4.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit
import WebKit

/// 聊天动图浏览
class GifBrowserController: BaseController {

    var msg: STMessage!
    private lazy var imgView: FLAnimatedImageView = {
        () -> FLAnimatedImageView in
        let temp = FLAnimatedImageView.init(frame: self.view.bounds)
        temp.backgroundColor = UIColor.clear
        temp.contentMode = .scaleAspectFit
        temp.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        temp.addGestureRecognizer(tap)
        let press = UILongPressGestureRecognizer.init(target: self, action: #selector(pressClick(press:)))
        press.minimumPressDuration = 0.5
        temp.addGestureRecognizer(press)
        self.view.addSubview(temp)
        return temp
    }()
    private var endPath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        let body = msg.body as! STImageMessageBody
        self.imgView.isHidden = false
        weak var weakSelf = self
        if msg.fromMe {
            JQueueManager.share.globalAsyncQueue {
                let endPath = JPhotoManager.share.uploadPath(path: body.path)
                let url = URL.init(fileURLWithPath: endPath)
                let data = try? Data.init(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
                if data != nil {
                    let animatedImage = FLAnimatedImage.init(animatedGIFData: data)
                    JQueueManager.share.mainAsyncQueue {
                        weakSelf?.imgView.animatedImage = animatedImage
                    }
                } else {
                    OSSManager.initWithShare().downloadImage(body.remotePath, progress: { (pro) in
                        
                    }) { (endPath) in
                        if endPath.haveTextStr() {
                            JQueueManager.share.globalAsyncQueue {
                                weakSelf?.endPath = endPath
                                let url = URL.init(fileURLWithPath: endPath)
                                let data = try? Data.init(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
                                let animatedImage = FLAnimatedImage.init(animatedGIFData: data)
                                JQueueManager.share.mainAsyncQueue {
                                    weakSelf?.imgView.animatedImage = animatedImage
                                }
                            }
                        } else {
                            let errorView = JPictureErrorView.init(frame: self.view.bounds, bind: "picture_error")
                            self.view.addSubview(errorView)
                        }
                    }
                }
            }
        } else {
            OSSManager.initWithShare().downloadImage(body.remotePath, progress: { (pro) in
                
            }) { (endPath) in
                if endPath.haveTextStr() {
                    JQueueManager.share.globalAsyncQueue {
                        weakSelf?.endPath = endPath
                        let url = URL.init(fileURLWithPath: endPath)
                        let data = try? Data.init(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
                        let animatedImage = FLAnimatedImage.init(animatedGIFData: data)
                        JQueueManager.share.mainAsyncQueue {
                            weakSelf?.imgView.animatedImage = animatedImage
                        }
                    }
                } else {
                    let errorView = JPictureErrorView.init(frame: self.view.bounds, bind: "picture_error")
                    self.view.addSubview(errorView)
                }
            }
        }
        
    }

    @objc private func tapClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func pressClick(press: UILongPressGestureRecognizer) {
        if press.state != .began {
            return
        }
        guard let path = self.endPath else {
            return
        }
        let alertCon = UIAlertController.init(title: "保存Gif", message: nil, preferredStyle: .actionSheet)
        let actionSave = UIAlertAction.init(title: L$("save"), style: .default) { (action) in
            JAuthorizeManager.init(view: self.view).photoLibraryAuthorization {
                JPhotoAlbumManager.share.saveGifToAlbum(path: path)
            }
        }
        let actionCancel = UIAlertAction.init(title: L$("cancel"), style: .cancel, handler: nil)
        alertCon.addAction(actionSave)
        alertCon.addAction(actionCancel)
        self.present(alertCon, animated: true, completion: nil)
    }
}
