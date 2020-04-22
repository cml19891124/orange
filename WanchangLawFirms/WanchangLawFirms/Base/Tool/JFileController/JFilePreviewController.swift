//
//  JFilePreviewController.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/15.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import QuickLook

/// 文件预览
class JFilePreviewController: QLPreviewController {
    
    var path: String!
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
    }
}

extension JFilePreviewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return NSURL.init(fileURLWithPath: path)
    }
    
}
