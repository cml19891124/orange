//
//  ArticleDetailController.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/12.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import WebKit

/// 文章详情
class ArticleDetailController: BaseController {
    
    var model: HomeModel = HomeModel()
    var logo: UIImage?
    var isCarouse: Bool = false
    
    private var lhnav: LHNavigationController?
    private lazy var webView: WKWebView = {
        () -> WKWebView in
        let temp = WKWebView.init(isOpaque: true)
        temp.frame = CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight)
        temp.navigationDelegate = self
        temp.scrollView.delegate = self
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
    private var contentOffsetY: CGFloat = 0
    private var loadFinish: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.transitionType == .article {
            ArticleManager.share.logoImgView.isHidden = true
            return
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        RealmManager.share().updateArticle(model.id, offsetY: self.contentOffsetY)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.transitionType == .article {
            ArticleManager.share.logoImgView.isHidden = false
        } else {
            progressView.removeFromSuperview()
//            webView.removeObserver(self, forKeyPath: "estimatedProgress")
//            webView.reloadInputViews()
            if ArticleManager.share.showModel != nil {
                ArticleManager.share.logoImgView.isHidden = false
                ArticleManager.share.articleVC = self
                self.lhnav?.ges_delegate = nil
                self.lhnav = nil
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isCarouse {
            self.title = model.title
        } else {
            self.title = L$("case_detail")
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "article_share"), style: .done, target: self, action: #selector(shareClick))
        contentOffsetY = RealmManager.share().getArticleOffsetY(model.id)
        self.pubDataSource()
        ArticleManager.share.logoImgView.isHidden = true
//        if ArticleManager.share.showModel?.id != model.id {
//            self.lhnav = self.navigationController as? LHNavigationController
//            self.lhnav?.ges_delegate = self
//        }
        if let lhnav = self.navigationController as? LHNavigationController {
            self.webView.scrollView.panGestureRecognizer.require(toFail: lhnav.edgeBackGesture)
        }
    }
    
    private func pubDataSource() {
        let urlStr = BASE_URL + "/posts/detail?id=" + model.id
        guard let url = URL.init(string: urlStr) else {
            return
        }
        let request = URLRequest.init(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        webView.load(request)
        
//        let cache = URLCache.shared
//        let current = cache.cachedResponse(for: request)
//        if current?.data != nil {
//            webView.load(current!.data, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: url)
//        } else {
//            webView.load(request)
//            let data = try? Data.init(contentsOf: url)
//            if data != nil {
//                let response = URLResponse.init(url: url, mimeType: "text/html", expectedContentLength: 0, textEncodingName: "UTF-8")
//                let cacheResponse = CachedURLResponse.init(response: response, data: data!)
//                cache.storeCachedResponse(cacheResponse, for: request)
//            }
//        }
        
    }
    
    @objc private func shareClick() {
        OLAlertManager.share.pickerShow(bindArr: ["wechat","wechat_coil","qq","qq_space","weibo"])
        OLAlertManager.share.pickerView?.delegate = self
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }

}

extension ArticleDetailController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0, animated: false)
        self.perform(#selector(delayScroll), with: nil, afterDelay: 0.1)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    @objc private func delayScroll() {
        webView.scrollView.setContentOffset(CGPoint.init(x: 0, y: contentOffsetY), animated: false)
        self.loadFinish = true
    }
}

extension ArticleDetailController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.loadFinish {
            self.contentOffsetY = scrollView.contentOffset.y
        }
    }
}

extension ArticleDetailController: OLPickerViewDelegate {
    func olpickerViewClick(bind: String) {
        let url = BASE_URL + "/posts/detail?id=" + model.id
        JShareManager.share.shareArticle(bind: bind, link: url, title: model.title, subTitle: model.sub_title)
    }
}

extension ArticleDetailController: LHNavigationControllerDelegate {
    func lhNavigationControllerHandGestureBegan(at point: CGPoint) {
        ArticleManager.share.figureBeganAt(point: point)
        ArticleManager.share.model = self.model
    }
    
    func lhNavigationControllerHandGestureMove(at point: CGPoint) {
        ArticleManager.share.figureMoveAt(point: point)
    }
    
    func lhNavigationControllerHandGestureEnd(at point: CGPoint) {
        ArticleManager.share.figureEndAt(point: point)
    }
    
}
