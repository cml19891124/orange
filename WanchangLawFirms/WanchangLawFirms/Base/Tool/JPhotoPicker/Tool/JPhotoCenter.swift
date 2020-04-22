//
//  JPhotoCenter.swift
//  OLegal
//
//  Created by lh on 2018/11/24.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import Photos

let JPhoto_Noti_Select_Change = "JPhoto_Noti_Select_Change"

@objc protocol JPhotoCenterDelegate: NSObjectProtocol {
    func jphotoCenterEnd(assets: [PHAsset])
    @objc optional func jPhotoCenterUploadFinish()
}

/// 照片控制中心
class JPhotoCenter: NSObject {
    static let share: JPhotoCenter = JPhotoCenter()
    
    weak var delegate: JPhotoCenterDelegate?
    var selectedAsset: [PHAsset] = [PHAsset]()
    var isOriginal: Bool = false
    
    private var promptV: JPhotoPromptView?
    
    var configure: JPhotoConfigure = JPhotoConfigure.init(mediaType: JPhotoMediaType.image, cutType: JPhotoCutType.onlyCut, showGif: true)
    
    /// 相册配置
    func setupConfigure(configure: JPhotoConfigure) {
        self.configure = configure
        self.isOriginal = false
    }
    
    /// 默认跳转到所有照片列表
    func present(from: UIViewController) {
        self.configure = JPhotoConfigure.init(mediaType: JPhotoMediaType.imageVideo, cutType: JPhotoCutType.onlyCut, showGif: true)
        self.isOriginal = false
        self.selectedAsset.removeAll()
        let nav = BaseNavigationController.init(rootViewController: JAlbumListController())
        from.present(nav, animated: true, completion: nil)
    }
    
    /// 选中相片
    func addAsset(asset: PHAsset) {
        if self.selectedAsset.count >= 9 {
            PromptTool.promptText(L$("p_photo_max_9"), 1)
            return
        }
        asset.selected = true
        if !self.selectedAsset.contains(asset) {
            self.selectedAsset.append(asset)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: JPhoto_Noti_Select_Change), object: nil)
    }
    
    /// 取消选中的照片
    func removeAsset(asset: PHAsset) {
        asset.selected = false
        for i in 0..<self.selectedAsset.count {
            let a: PHAsset = self.selectedAsset[i]
            if a.isEqual(asset) {
                self.selectedAsset.remove(at: i)
                break
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: JPhoto_Noti_Select_Change), object: nil)
    }
    
    /// 点击取消按钮时调用该方法
    func cancel() {
        var i = 0
        for a in self.selectedAsset {
            if a.path == nil {
                self.selectedAsset.remove(at: i)
            } else {
                i += 1
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: JPhoto_Noti_Select_Change), object: nil)
    }

}

extension JPhotoCenter {
    var mediaType: JPhotoMediaType {
        get {
            return configure.mediaType
        }
    }
    
    var cutType: JPhotoCutType {
        get {
            return configure.cutType
        }
    }
}

// MARK: - 完成选择后，mov转mp4格式，heic转jpeg格式，目的是为了适配安卓端和服务端
extension JPhotoCenter {
    func endPicker() {
        self.dealingPrompt()
        JQueueManager.share.globalAsyncQueue {
            self.assetDeal()
        }
    }
    
    private func assetDeal() {
        var i = 0
        var needWait = false
        while i < self.selectedAsset.count {
            if needWait {
                
            } else {
                if i >= self.selectedAsset.count {
                    break
                }
                needWait = true
                
                let asset = self.selectedAsset[i]
                
                let resource = PHAssetResource.assetResources(for: asset).first!
                var full_path: String = JPhotoManager.share.localFullPath(path: asset.id)
                if asset.mediaType == .image {
                    if self.configure.showGif {
                        if asset.is_gif {
                            full_path = JPhotoManager.share.localGifPath(path: asset.id)
                        } else {
                            if asset.is_too_big {
                                full_path = JPhotoManager.share.localCutPath(path: asset.id)
                            }
                        }
                    } else if asset.is_too_big {
                        full_path = JPhotoManager.share.localCutPath(path: asset.id)
                    }
                } else if asset.mediaType == .video {
                    full_path += ".mp4"
                }
                
                var data = try? Data.init(contentsOf: URL.init(fileURLWithPath: full_path), options: Data.ReadingOptions.mappedIfSafe)
                if data == nil {
                    if asset.mediaType == .video {
                        let options = PHVideoRequestOptions()
                        options.version = .current
                        options.deliveryMode = .automatic
                        let manager = PHImageManager.default()
                        manager.requestExportSession(forVideo: asset, options: options, exportPreset: AVAssetExportPresetHighestQuality) { (exportSession, info) in
                            exportSession?.outputURL = URL.init(fileURLWithPath: full_path)
                            exportSession?.shouldOptimizeForNetworkUse = true
                            exportSession?.outputFileType = .mp4
                            exportSession?.exportAsynchronously(completionHandler: {
                                data = try? Data.init(contentsOf: URL.init(fileURLWithPath: full_path), options: Data.ReadingOptions.mappedIfSafe)
                                if data == nil {
                                    PHAssetResourceManager.default().writeData(for: resource, toFile: URL.init(fileURLWithPath: full_path), options: nil, completionHandler: { (error) in
                                        asset.path = full_path
                                        self.cutSave(a: asset)
                                        i += 1
                                        needWait = false
                                    })
                                } else {
                                    asset.path = full_path
                                    self.cutSave(a: asset)
                                    i += 1
                                    needWait = false
                                }
                            })
                        }
                    } else if asset.mediaType == .image {
                        if self.configure.showGif && asset.is_gif {
                            PHAssetResourceManager.default().writeData(for: resource, toFile: URL.init(fileURLWithPath: full_path), options: nil) { (error) in
                                asset.gif_path = full_path
                                i += 1
                                needWait = false
                            }
                        } else {
                            if asset.is_too_big && !asset.is_gif {
                                JPhotoManager.share.fetchImageInAsset(asset: asset, size: CGSize.init(width: kDeviceWidth * 2, height: kDeviceHeight * 2), mode: .fast) { (ass, img, dict) in
                                    if img != nil {
                                        if img!.size.width > 200 && img!.size.height > 200 {
                                            data = img?.jpegData(compressionQuality: 0.8)
                                            try? data?.write(to: URL.init(fileURLWithPath: full_path))
                                            asset.cut_path = full_path
                                            i += 1
                                            needWait = false
                                        }
                                    }
                                }
                            } else {
                                if asset.is_heic {
                                    asset.requestContentEditingInput(with: nil) { (input, info) in
                                        if input?.fullSizeImageURL != nil {
                                            let ciImg = CIImage.init(contentsOf: (input?.fullSizeImageURL)!, options: nil)
                                            let context = CIContext.init()
                                            if ciImg != nil {
                                                if #available(iOS 10.0, *) {
                                                    data = context.jpegRepresentation(of: ciImg!, colorSpace: (ciImg?.colorSpace)!, options: [:])
                                                    if data != nil {
                                                        try? data!.write(to: URL.init(fileURLWithPath: full_path))
                                                        asset.path = full_path
                                                        self.cutSave(a: asset)
                                                        i += 1
                                                        needWait = false
                                                    }
                                                } else {
                                                    // Fallback on earlier versions
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    PHAssetResourceManager.default().writeData(for: resource, toFile: URL.init(fileURLWithPath: full_path), options: nil) { (error) in
                                        asset.path = full_path
                                        self.cutSave(a: asset)
                                        i += 1
                                        needWait = false
                                    }
                                }
                            }
                        }
                    }
                } else {
                    if asset.mediaType == .video {
                        asset.path = full_path
                        self.cutSave(a: asset)
                        i += 1
                        needWait = false
                    } else if asset.mediaType == .image {
                        if self.configure.showGif && asset.is_gif {
                            asset.gif_path = full_path
                        } else {
                            asset.path = full_path
                            self.cutSave(a: asset)
                        }
                        i += 1
                        needWait = false
                    }
                }
            }
        }
        JQueueManager.share.mainAsyncQueue {
            self.removePrompt()
            self.delegate?.jphotoCenterEnd(assets: self.selectedAsset)
        }
    }
    
    private func cutSave(a: PHAsset) {
        if a.mediaType == .image {
            if a.cut_path == nil {
                let c_path = a.path! + "_cut"
                var data = try? Data.init(contentsOf: URL.init(fileURLWithPath: c_path), options: Data.ReadingOptions.mappedIfSafe)
                if data == nil {
                    data = self.compressMidWay(path: a.path!)
                    try? data?.write(to: URL.init(fileURLWithPath: c_path))
                }
                a.cut_path = c_path
            }
        } else if a.mediaType == .video {
            if a.cut_path == nil {
                let c_path = a.path! + "_cut"
                var data = try? Data.init(contentsOf: URL.init(fileURLWithPath: c_path), options: Data.ReadingOptions.mappedIfSafe)
                if data == nil {
                    data = a.img?.jpegData(compressionQuality: 0.95)
                    try? data?.write(to: URL.init(fileURLWithPath: c_path))
                }
                a.cut_path = c_path
            }
        }
    }
    
    private func compressMidWay(path: String) -> Data? {
        let length: Int = 1024 * 1024
        let temp1 = try? Data.init(contentsOf: URL.init(fileURLWithPath: path), options: Data.ReadingOptions.mappedIfSafe)
        guard let data = temp1 else {
            return nil
        }
        let temp2 = UIImage.init(data: data)
        guard let img = temp2 else {
            return nil
        }
        if data.count < length {
            return data
        }
        var compression: CGFloat = 0.5
        var min: CGFloat = 0
        var max: CGFloat = 1
        var result: Data?
        for _ in 0..<6 {
            compression = (max + min) / 2
            result = img.jpegData(compressionQuality: compression)
            if result == nil {
                break
            }
            if result!.count < Int(Float(length) * 0.9) {
                min = compression
            } else if result!.count > Int(Float(length) * 1.1) {
                max = compression
            } else {
                break
            }
        }
        return result
    }
}

extension JPhotoCenter {
    private func dealingPrompt() {
        promptV = JPhotoPromptView.init(bind: "dealing")
    }
    
    private func removePrompt() {
        promptV?.removeFromSuperview()
        promptV = nil
    }
}

extension JPhotoCenter {
    func uploadToOss(objKey: String) {
        promptV = JPhotoPromptView.init(bind: "uploading")
        UIApplication.shared.keyWindow?.addSubview(promptV!)
        JQueueManager.share.globalAsyncQueue {
            self.judgeUpload()
            for m in self.selectedAsset {
                if m.upload_success == true {
                    continue
                }
                m.remote_path = OSSManager.initWithShare().uniqueString(by: objKey, pathExten: "jpeg")
                OSSManager.initWithShare().uploadFilePath(m.cut_path!, objKey: m.remote_path!, progress: { (progre) in
                    
                }, complete: { (remotePath) in
                    if remotePath.haveTextStr() == true {
                        m.upload_success = true
                    } else {
                        m.upload_success = false
                    }
                    self.judgeUpload()
                })
            }
        }
    }
    
    private func judgeUpload() {
        for m in self.selectedAsset {
            if m.upload_success == nil {
                return
            }
        }
        JQueueManager.share.mainAsyncQueue {
            self.promptV?.removeFromSuperview()
            self.promptV = nil
            self.delegate?.jPhotoCenterUploadFinish!()
        }
    }
}
