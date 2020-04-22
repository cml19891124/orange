//
//  JPhotoAlbumManager.swift
//  Stormtrader
//
//  Created by lh on 2018/11/6.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import Photos

/// 保存到相册。目前只做了保存照片、gif，若扩展功能（如保存视频），请在此管理器内添加相应代码
class JPhotoAlbumManager: NSObject {
    static let share = JPhotoAlbumManager()
    let album_name = "欧伶猪法律法务咨询"
    
    private func getAlbum(albumName: String) -> PHAssetCollection? {
        let list = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        var asset: PHAssetCollection?
        list.enumerateObjects { (album, index, stop) in
            if albumName == album.localizedTitle {
                asset = album
                stop.initialize(to: true)
            }
        }
        return asset
    }
    
}

extension JPhotoAlbumManager {
    func saveImageToAlbum(image: UIImage) {
        var asset = self.getAlbum(albumName: album_name)
        if asset == nil {
            PHPhotoLibrary.shared().performChanges({
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.album_name)
            }) { (isSuccess, error) in
                if isSuccess {
                    asset = self.getAlbum(albumName: self.album_name)
                    self.saveImageToAsset(image: image, asset: asset!)
                }
            }
        } else {
            self.saveImageToAsset(image: image, asset: asset!)
        }
    }
    
    
    func saveGifToAlbum(path: String) {
        var asset = self.getAlbum(albumName: album_name)
        if asset == nil {
            PHPhotoLibrary.shared().performChanges({
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.album_name)
            }) { (isSuccess, error) in
                if isSuccess {
                    asset = self.getAlbum(albumName: self.album_name)
                    self.saveGifToAsset(path: path, asset: asset!)
                }
            }
        } else {
            self.saveGifToAsset(path: path, asset: asset!)
        }
    }
    
    func takePhotoSaveImageToAlbum(image: UIImage, success:@escaping(Bool) -> Void) {
        var asset = self.getAlbum(albumName: album_name)
        if asset == nil {
            PHPhotoLibrary.shared().performChanges({
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.album_name)
            }) { (isSuccess, error) in
                if isSuccess {
                    asset = self.getAlbum(albumName: self.album_name)
                    self.takePhotoSaveImageToAsset(image: image, asset: asset!, success: success)
                }
            }
        } else {
            self.takePhotoSaveImageToAsset(image: image, asset: asset!, success: success)
        }
    }
}

extension JPhotoAlbumManager {
    private func saveImageToAsset(image: UIImage, asset: PHAssetCollection) {
        PHPhotoLibrary.shared().performChanges({
            let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceholder = result.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: asset)
            if assetPlaceholder != nil {
                albumChangeRequest?.addAssets([assetPlaceholder!] as NSArray)
            }
        }) { (isSuccess, error) in
            JQueueManager.share.mainAsyncQueue {
                if isSuccess {
                    PromptTool.promptText(L$("saved_to_album"), 1)
                } else {
                    PromptTool.promptText(L$("save_failure"), 1)
                }
            }
        }
    }
    
    private func takePhotoSaveImageToAsset(image: UIImage, asset: PHAssetCollection, success:@escaping(Bool) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceholder = result.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: asset)
            if assetPlaceholder != nil {
                albumChangeRequest?.addAssets([assetPlaceholder!] as NSArray)
            }
        }) { (isSuccess, error) in
            JQueueManager.share.mainAsyncQueue {
                success(isSuccess)
            }
        }
    }
    
    private func saveGifToAsset(path: String, asset: PHAssetCollection) {
        PHPhotoLibrary.shared().performChanges({
            let result = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: URL.init(fileURLWithPath: path))
            let assetPlaceholder = result?.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: asset)
            if assetPlaceholder != nil {
                albumChangeRequest?.addAssets([assetPlaceholder!] as NSArray)
            }
        }) { (isSuccess, error) in
            JQueueManager.share.mainAsyncQueue {
                if isSuccess {
                    PromptTool.promptText(L$("saved_to_album"), 1)
                } else {
                    PromptTool.promptText(L$("save_failure"), 1)
                }
            }
        }
    }
}
