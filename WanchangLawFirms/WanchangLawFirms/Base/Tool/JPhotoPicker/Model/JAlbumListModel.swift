//
//  JAlbumListModel.swift
//  OLegal
//
//  Created by lh on 2018/11/24.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import Photos

class JAlbumListModel: NSObject {
    
    var result: PHFetchResult<PHAsset>
    var collection: PHAssetCollection
    
    init(result: PHFetchResult<PHAsset>, collection: PHAssetCollection) {
        self.result = result
        self.collection = collection
        super.init()
    }

}

extension JAlbumListModel {
    var albumName: String {
        get {
            return collection.localizedTitle ?? ""
        }
    }
    
    var count: Int {
        get {
            return result.count
        }
    }
    
    var coverAsset: PHAsset {
        get {
            return result.firstObject!
        }
    }
    
}
