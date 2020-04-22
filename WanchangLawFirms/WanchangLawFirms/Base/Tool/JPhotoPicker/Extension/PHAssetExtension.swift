//
//  PHAssetExtension.swift
//  OLegal
//
//  Created by lh on 2018/11/24.
//  Copyright © 2018 gaming17. All rights reserved.
//

import Foundation
import Photos

private var asset_selected: Bool = false
private var asset_path: String = ""
private var asset_cut_path: String = ""
private var asset_gif_path: String = ""
private var asset_img: UIImage?
private var asset_remote_path: String = ""
private var asset_upload_success: Bool = false
private var asset_is_gif: Bool = false

extension PHAsset {
    
    var selected: Bool? {
        get {
            return objc_getAssociatedObject(self, &asset_selected) as? Bool
        }
        set {
            objc_setAssociatedObject(self, &asset_selected, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var path: String? {
        get {
            return objc_getAssociatedObject(self, &asset_path) as? String
        }
        set {
            objc_setAssociatedObject(self, &asset_path, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var cut_path: String? {
        get {
            return objc_getAssociatedObject(self, &asset_cut_path) as? String
        }
        set {
            objc_setAssociatedObject(self, &asset_cut_path, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var gif_path: String? {
        get {
            return objc_getAssociatedObject(self, &asset_gif_path) as? String
        }
        set {
            objc_setAssociatedObject(self, &asset_gif_path, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var img: UIImage? {
        get {
            return objc_getAssociatedObject(self, &asset_img) as? UIImage
        }
        set {
            objc_setAssociatedObject(self, &asset_img, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var remote_path: String? {
        get {
            return objc_getAssociatedObject(self, &asset_remote_path) as? String
        }
        set {
            objc_setAssociatedObject(self, &asset_remote_path, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    var upload_success: Bool? {
        get {
            return objc_getAssociatedObject(self, &asset_upload_success) as? Bool
        }
        set {
            objc_setAssociatedObject(self, &asset_upload_success, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
}

extension PHAsset {
    private var j_is_gif: Bool? {
        get {
            return objc_getAssociatedObject(self, &asset_is_gif) as? Bool
        }
        set {
            objc_setAssociatedObject(self, &asset_is_gif, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

extension PHAsset {
    var id: String {
        get {
            let resource = PHAssetResource.assetResources(for: self).first!
            var identifier = (resource.assetLocalIdentifier as NSString).replacingOccurrences(of: "/", with: "_")
            if self.mediaType == .image {
                if JPhotoCenter.share.configure.showGif && self.is_gif {
                    
                } else {
                    identifier += "_\(JPhotoCenter.share.isOriginal)"
                }
            }
            return identifier
        }
    }
    
    var name: String {
        get {
            let resource = PHAssetResource.assetResources(for: self).first!
            return resource.originalFilename
        }
    }
    
    var is_gif: Bool {
        get {
            if self.j_is_gif == nil {
                let pathExten = ((name as NSString).pathExtension as NSString).lowercased
                if pathExten == "gif" {
                    self.j_is_gif = true
                } else {
                    self.j_is_gif = false
                }
            }
            return self.j_is_gif!
        }
    }
    
    var is_heic: Bool {
        get {
            let fileName = ((name as NSString).pathExtension as NSString).lowercased
            if fileName == "heic" || fileName == "heif" {
                return true
            }
            return false
        }
    }
    
    var fileSize: Int {
        get {
            let resource = PHAssetResource.assetResources(for: self).first!
            guard let length = resource.value(forKey: "fileSize") as? Int else {
                return 0
            }
            return length
        }
    }
    
    var is_too_big: Bool {
        get {
            if fileSize >= 1024 * 1024 * 5 {
                return true
            }
            return false
        }
    }
    
    var too_big_forbidden: Bool {
        get {
            if fileSize > 1024 * 1024 * 30 {
                PromptTool.promptText("大小不能超过30M", 1)
                return true
            }
            return false
        }
    }
    
    var uploadPath: String {
        get {
            var temp = ""
            if self.mediaType == .video {
                temp = path ?? ""
            } else if mediaType == .image {
                if JPhotoCenter.share.configure.showGif && self.is_gif {
                    temp = gif_path ?? ""
                } else {
                    temp = cut_path ?? ""
                }
            }
            return temp
        }
    }
}
