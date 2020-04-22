//
//  JURLController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/2.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit
import WebKit

/// 访问URL链接 - 内置访问
class JURLController: BaseController {
    
    private lazy var webView: WKWebView = {
        () -> WKWebView in
        let temp = WKWebView.init(isOpaque: true)
        temp.frame = CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight)
        temp.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var progressView: UIProgressView = {
        () -> UIProgressView in
        let temp = UIProgressView.init(frame: CGRect.init(x: 0, y: 42, width: kDeviceWidth, height: 2))
        temp.trackTintColor = UIColor.clear
        temp.progressTintColor = kOrangeLightColor
        self.navigationController?.navigationBar.addSubview(temp)
        return temp
    }()
    
    private var urlStr: String = ""
    private var bind: String = ""
    convenience init(urlStr: String, bind: String) {
        self.init()
        self.urlStr = urlStr
        self.bind = bind
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$(bind)
        guard let url = URL.init(string: urlStr) else {
            return
        }
        let request = URLRequest.init(url: url)
        self.webView.load(request)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    deinit {
        progressView.removeFromSuperview()
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.reloadInputViews()
    }

}
