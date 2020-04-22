//
//  JPhotoConfigure.swift
//  OLegal
//
//  Created by lh on 2018/11/24.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit


/// 获取相片的数据信息
///
/// - onlyOriginal: 只有原图
/// - onlyCut: 自动压缩到1M
/// - OriginalCut: 可压缩，可选择原图
enum JPhotoCutType {
    case onlyOriginal
    case onlyCut
    case OriginalCut
}

/// 获取相片类型信息
///
/// - image: 只获取图片
/// - video: 只获取视频
/// - imageVideo: 图片、视频同时显示
enum JPhotoMediaType {
    case image
    case video
    case imageVideo
}

/// 相册的一些配置
class JPhotoConfigure: NSObject {
    
    var mediaType: JPhotoMediaType
    var cutType: JPhotoCutType
    var showGif: Bool
    
    init(mediaType: JPhotoMediaType, cutType: JPhotoCutType, showGif: Bool) {
        self.mediaType = mediaType
        self.cutType = cutType
        self.showGif = showGif
        super.init()
    }

}
