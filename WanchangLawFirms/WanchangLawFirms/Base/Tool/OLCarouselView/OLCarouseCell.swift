//
//  OLCarouseCell.swift
//  OLegal
//
//  Created by lh on 2018/11/26.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import WebKit

//        cell.urlStr = "http://storm.szcysoft.com/storage/img/71-1542861076034.jpeg"

class OLCarouseCell: UICollectionViewCell {
    
    var model: OLCarouselModel! {
        didSet {
            guard let urlStr = model.full_url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
                return
            }
            guard let url = URL.init(string: urlStr) else {
                return
            }
            imgView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "slider_placeholder_icon"), options: SDWebImageOptions.highPriority, completed: nil)
            
//            let request = URLRequest.init(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
//            let cache = URLCache.shared
//            let current = cache.cachedResponse(for: request)
//            if current?.data != nil {// text/html image/gif
//                webView.load(current!.data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url)
//            } else {
//                webView.load(request)
//                let data = try? Data.init(contentsOf: url)
//                if data != nil {
//                    let response = URLResponse.init(url: url, mimeType: "image/gif", expectedContentLength: 0, textEncodingName: "UTF-8")
//                    let cacheResponse = CachedURLResponse.init(response: response, data: data!)
//                    cache.storeCachedResponse(cacheResponse, for: request)
//                }
//            }
        }
    }
    
    private lazy var imgView: UIImageView = {
        () -> UIImageView in
        let temp = UIImageView.init(UIView.ContentMode.scaleAspectFill)
        temp.frame = self.bounds
        temp.image = UIImage.init(named: "slider_placeholder_icon")
        self.addSubview(temp)
        return temp
    }()
    
    private lazy var webView: WKWebView = {
        () -> WKWebView in
        let temp = WKWebView.init(isOpaque: false)
        temp.frame = self.bounds
        self.addSubview(temp)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
