//
//  JPhotoManager.swift
//  OLegal
//
//  Created by lh on 2018/11/24.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import Photos

/// 照片管理器
class JPhotoManager: NSObject {
    static let share: JPhotoManager = JPhotoManager()
    
    var albumArr: [JAlbumListModel] = [JAlbumListModel]()
    
    override init() {
        super.init()
        self.createCacheSavePath()
    }
    
    func clearAll() {
        albumArr.removeAll()
    }
    
    /// 穿件照片本地缓存路径
    func createCacheSavePath() {
        let cacheDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString
        let jphotoDirectory = cacheDirectory.appendingPathComponent("/JPhotoDirectory/")
        let fm = FileManager.default
        if !fm.fileExists(atPath: jphotoDirectory) {
            try! fm.createDirectory(atPath: jphotoDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    /// 获取所有相册
    func getAllAlbums() -> [JAlbumListModel] {
        albumArr.removeAll()
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        self.fetchCollection(result: smartAlbums)
        let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil) as? PHFetchResult<PHAssetCollection>
        if userCollections != nil {
            self.fetchCollection(result: userCollections!)
        }
        return albumArr
    }
    
    /// 获取照片信息
    ///
    /// - Parameters:
    ///   - asset: PHAsset
    ///   - size: 尺寸
    ///   - mode: 模式
    ///   - complete: 返回图片以及图片参数
    func fetchImageInAsset(asset: PHAsset, size: CGSize, mode: PHImageRequestOptionsResizeMode, complete:@escaping (PHAsset, UIImage?, [AnyHashable : Any]?)->Void) {
        let option = PHImageRequestOptions()
        option.resizeMode = mode
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: option) { (img, dict) in
            if size.width <= 200 {
                asset.img = img
            }
            complete(asset, img, dict)
        }
    }
    
    /// 同上，获取gif数据
    func fetchGifDataInAsset(asset: PHAsset, mode: PHImageRequestOptionsResizeMode, complete:@escaping (PHAsset, String, [AnyHashable : Any]?)->Void) {
        let option = PHImageRequestOptions()
        option.resizeMode = mode
        PHImageManager.default().requestImageData(for: asset, options: option) { (data, uti, orientation, dict) in
            let gif_path = JPhotoManager.share.localGifPath(path: asset.id)
            let h_data = try? Data.init(contentsOf: URL.init(fileURLWithPath: gif_path), options: Data.ReadingOptions.mappedIfSafe)
            if h_data == nil {
                try? data?.write(to: URL.init(fileURLWithPath: gif_path))
            }
            asset.gif_path = gif_path
            complete(asset, gif_path, dict)
        }
    }
    
    /// 加载某个相册下的所有PHAsset
    func fetchAssetsInCollection(collection: PHAssetCollection?, asending: Bool) -> [PHAsset] {
        var temp: [PHAsset] = [PHAsset]()
        let result: PHFetchResult<PHAsset> = self.fetchResultInCollection(collection: collection, asending: asending)
        result.enumerateObjects { (asset, idx, stop) in
            switch JPhotoCenter.share.mediaType {
            case .image:
                if asset.mediaType == PHAssetMediaType.image {
                    temp.append(asset)
                }
                break
            case .video:
                if asset.mediaType == PHAssetMediaType.video {
                    temp.append(asset)
                }
                break
            case .imageVideo:
                temp.append(asset)
                break
            }
        }
        return temp
    }

}

extension JPhotoManager {
    private func fetchCollection(result: PHFetchResult<PHAssetCollection>) {
        result.enumerateObjects { (collection, idx, stop) in
            if collection.isKind(of: PHAssetCollection.self) {
                let temp: PHFetchResult<PHAsset> = self.fetchResultInCollection(collection: collection, asending: false)
                if temp.count > 0 {
                    if JPhotoCenter.share.configure.mediaType == JPhotoMediaType.image {
                        if collection.localizedTitle != "视频" {
                            let albumModel = JAlbumListModel.init(result: temp, collection: collection)
                            self.albumArr.append(albumModel)
                        }
                    } else {
                        let albumModel = JAlbumListModel.init(result: temp, collection: collection)
                        self.albumArr.append(albumModel)
                    }
                }
            }
        }
    }
    
    private func fetchResultInCollection(collection: PHAssetCollection?, asending: Bool) -> PHFetchResult<PHAsset> {
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: asending)]
        var result: PHFetchResult<PHAsset>
        if collection != nil {
            result = PHAsset.fetchAssets(in: collection!, options: option)
        } else {
            result = PHAsset.fetchAssets(with: nil)
        }
        return result
    }
}

extension JPhotoManager {
    func lengthStrFrom(length: Int?) -> String {
        guard let temp = length else {
            return "0KB"
        }
        let d = Double(temp)
        let kb = d / 1024
        if kb > 0.1 {
            if kb > 1024 * 1024 {
                let gb = kb / 1024 / 1024
                return String.init(format: "%.2fG", gb)
            } else if kb > 1024 {
                let mb = kb / 1024
                return String.init(format: "%.2fM", mb)
            } else {
                return String.init(format: "%.2fKB", kb)
            }
        }
        return String.init(format: "%.0fB", d)
    }
}

extension JPhotoManager {
    /// 缓存路径目录 - 此处为创建的文件夹
    func cachePath(path: String) -> String {
        let cacheDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString
        let result = cacheDirectory.appendingPathComponent(path)
        return result
    }
    
    /// 缩略图缓存路径
    func localCutPath(path: String) -> String {
        let cacheDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString
        let temp = "/JPhotoDirectory/" + path + "_cut"
        let result = cacheDirectory.appendingPathComponent(temp)
        return result
    }
    
    /// 原图缓存路径（此处为1M大小的路径，因为该App对图片进行压缩处理，不选择原图）
    func localFullPath(path: String) -> String {
        let cacheDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString
        let temp = "/JPhotoDirectory/" + path
        let result = cacheDirectory.appendingPathComponent(temp)
        return result
    }
    
    /// gif路径
    func localGifPath(path: String) -> String {
        let cacheDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString
        let temp = "/JPhotoDirectory/" + path + "_gif"
        let result = cacheDirectory.appendingPathComponent(temp)
        return result
    }
    
    /// 要上传的图片路径
    func uploadPath(path: String) -> String {
        let cacheDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString
        let temp = "/JPhotoDirectory/" + path
        let result = cacheDirectory.appendingPathComponent(temp)
        return result
    }
}
