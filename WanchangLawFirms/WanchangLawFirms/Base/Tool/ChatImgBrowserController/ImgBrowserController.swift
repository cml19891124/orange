//
//  ImgBrowserController.swift
//  Stormtrader
//
//  Created by lh on 2018/9/27.
//  Copyright © 2018年 gaming17. All rights reserved.
//

import UIKit

/// 聊天图片浏览
class ImgBrowserController: BaseController {
    
    var msg: STMessage!
    
    private var lastW: CGFloat = kDeviceWidth
    private var lastH: CGFloat = kDeviceHeight
    private var lastOffsetX: CGFloat = 0
    private var lastOffsetY: CGFloat = 0
    private var maxScale: CGFloat = 10
    
    private lazy var scrollView: UIScrollView = {
        () -> UIScrollView in
        let temp = UIScrollView.init(frame: self.view.bounds, contentSize: CGSize.init(width: 0, height: 0))
        temp.backgroundColor = UIColor.black
        temp.bounces = true
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var imgView: UIImageView = {
        () -> UIImageView in
        let temp = UIImageView.init(UIView.ContentMode.scaleAspectFit)
        temp.backgroundColor = UIColor.clear
        temp.isUserInteractionEnabled = true
        temp.frame = scrollView.bounds
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        temp.addGestureRecognizer(tap)
        let press = UILongPressGestureRecognizer.init(target: self, action: #selector(pressClick(press:)))
        press.minimumPressDuration = 0.5
        temp.addGestureRecognizer(press)
        let pin = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchClick(pin:)))
        temp.addGestureRecognizer(pin)
        self.scrollView.addSubview(temp)
        return temp
    }()
    
    private lazy var actIndicator: UIActivityIndicatorView = {
        () -> UIActivityIndicatorView in
        let temp = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.whiteLarge)
        temp.frame = CGRect.init(x: kDeviceWidth / 2 - 20, y: kDeviceHeight / 2 - 20, width: 40, height: 40)
        self.scrollView.addSubview(temp)
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    private func setupViews() {
        self.imgView.isHidden = false
        let body = msg.body as! STImageMessageBody
        weak var weakSelf = self
        switch msg.status {
        case .success:
            let urlStr = msg.j_oss_snap_url
            imgView.sd_setImage(with: URL.init(string: urlStr), completed: nil)
            self.actIndicator.startAnimating()
            OSSManager.initWithShare().downloadImage(body.remotePath, progress: { (pro) in
                
            }) { (endPath) in
                self.actIndicator.stopAnimating()
                if endPath.haveTextStr() {
                    let img = UIImage.init(contentsOfFile: endPath)
                    if img != nil {
                        weakSelf?.imgView.image = img
                    }
                } else {
                    let errorView = JPictureErrorView.init(frame: self.view.bounds, bind: "picture_error")
                    self.view.addSubview(errorView)
                }
            }
            break
        default:
            imgView.image = UIImage.init(contentsOfFile: JPhotoManager.share.uploadPath(path: body.path))
            break
        }
    }
    
    @objc private func tapClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func pressClick(press: UILongPressGestureRecognizer) {
        if press.state != .began {
            return
        }
        guard let img = self.imgView.image else {
            return
        }
        let alertCon = UIAlertController.init(title: L$("save_photo"), message: nil, preferredStyle: .actionSheet)
        let actionSave = UIAlertAction.init(title: L$("save"), style: .default) { (action) in
            JAuthorizeManager.init(view: self.view).photoLibraryAuthorization {
                JPhotoAlbumManager.share.saveImageToAlbum(image: img)
            }
        }
        let actionCancel = UIAlertAction.init(title: L$("cancel"), style: .cancel, handler: nil)
        alertCon.addAction(actionSave)
        alertCon.addAction(actionCancel)
        self.present(alertCon, animated: true, completion: nil)
        JQueueManager.share.globalAsyncQueue {
            let code = LCQRCodeUtil.readQRCode(from: img)
            if code?.haveTextStr() == true {
                JQueueManager.share.mainAsyncQueue {
                    let actionCode = UIAlertAction.init(title: L$("recognize_qr_code"), style: .default, handler: { (action) in
                        let url = URL.init(string: code!)
                        if url != nil {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                            } else {
                                UIApplication.shared.openURL(url!)
                            }
                        }
                    })
                    alertCon.addAction(actionCode)
                }
            }
        }
    }
    
    @objc private func pinchClick(pin: UIPinchGestureRecognizer) {
        switch pin.state {
        case .began:
            lastOffsetX = self.scrollView.contentOffset.x
            lastOffsetY = self.scrollView.contentOffset.y
            break
        case .changed:
            var scale = pin.scale
            var w = lastW * scale
            var h = lastH * scale
            if w < kDeviceWidth {
                w = kDeviceWidth
                scale = 1
            } else if w > kDeviceWidth * maxScale {
                w = kDeviceWidth * maxScale
                scale = maxScale
            }
            if h < kDeviceHeight {
                h = kDeviceHeight
                scale = 1
            } else if h > kDeviceHeight * maxScale {
                h = kDeviceHeight * maxScale
                scale = maxScale
            }
            
            self.imgView.frame = CGRect.init(x: 0, y: 0, width: w, height: h)
            self.scrollView.contentSize = CGSize.init(width: w, height: h)
            self.scrollView.scrollRectToVisible(CGRect.init(x: (scale - 1) * kDeviceWidth / 2 + lastOffsetX * scale, y: (scale - 1) * kDeviceHeight / 2 + lastOffsetY * scale, width: kDeviceWidth, height: kDeviceHeight), animated: false)
            break
        case .ended:
            lastW = self.imgView.frame.size.width
            lastH = self.imgView.frame.size.height
            break
        default:
            break
        }
    }

}
