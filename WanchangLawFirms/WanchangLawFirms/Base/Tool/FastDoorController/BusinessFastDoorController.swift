//
//  BusinessFastDoorController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit
import WebKit

/// 企业版快速入门
class BusinessFastDoorController: BaseController {
    
    var content: String?
    private lazy var webView: WKWebView = {
        () -> WKWebView in
        let temp = WKWebView.init(isOpaque: true)
        temp.frame = CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight)
        self.view.addSubview(temp)
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "操作流程"
        self.view.backgroundColor = UIColor.white
        self.getDataSource()
    }
    
    private func getDataSource() {
        guard let temp = content else {
            return
        }
        self.webView.loadHTMLString(temp, baseURL: nil)
    }
    
}
