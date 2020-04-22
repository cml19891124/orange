//
//  FCDocumentController.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/15.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import WebKit

/// 文档浏览，用UIWebView显示HTML文本，加载HTML存在反应时间且时间无法预知，该类未使用，此处仅为后续开发提供参考
class FCDocumentController: BaseController {

    var bind: String = ""
    var model: FCDocModel = FCDocModel()
    
    private lazy var webView: WKWebView = {
        () -> WKWebView in
        let temp = WKWebView.init(isOpaque: true)
        temp.frame = CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight)
        self.view.addSubview(temp)
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = model.title
        self.getDataSource()
    }
    
    private func getDataSource() {
        var type = ""
        if bind == "h_worker_compensation" {
            type = "work"
        } else if bind == "h_traffic_compensation" {
            type = "traffic"
        } else if bind == "h_lawyer_fee_calculation" {
            type = "lawyer"
        } else if bind == "h_litigation_cost_calculation" {
            type = "sue"
        }
        let prams: NSDictionary = ["id": model.id, "type":type]
        
        HomeManager.share.counterInfo(prams: prams) { (result) in
            if result != nil {
                self.webView.loadHTMLString(result!, baseURL: nil)
            }
        }
    }

}
