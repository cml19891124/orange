//
//  BaseTransition.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/2.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit


/// 转场动画
///
/// - system: 系统转场动画
/// - image: 图片转场动画
/// - article: 文章转场动画
/// TODO: 后续要添加的转场动画
enum TransitionType {
    case system
    case image
    case article
}

class BaseTransition: NSObject {
    let duration: TimeInterval = 0.25
    var operation: UINavigationController.Operation
    init(operation: UINavigationController.Operation) {
        self.operation = operation
        super.init()
    }
}
