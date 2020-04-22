//
//  JSafariController.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/20.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import SafariServices

/// 访问safari浏览器
class JSafariController: SFSafariViewController {
    
    private lazy var titleLab: UILabel = {
        () -> UILabel in
        let temp = UILabel.init(kFontL, UIColor.white, NSTextAlignment.center)
        temp.backgroundColor = customColor(255, 140, 47)
        temp.numberOfLines = 1
        temp.adjustsFontSizeToFitWidth = false
        self.view.addSubview(temp)
        _ = temp.sd_layout()?.topSpaceToView(self.view, kBarStatusHeight)?.centerXEqualToView(self.view)?.widthIs(200)?.heightIs(44)
        return temp
    }()
    
    convenience init(urlStr: String, title: String) {
        let url = URL.init(string: urlStr)
        if url != nil {
            if #available(iOS 11.0, *) {
                let confi = SFSafariViewController.Configuration()
                confi.barCollapsingEnabled = false
                confi.entersReaderIfAvailable = true
                self.init(url: url!, configuration: confi)
            } else {
                self.init(url: url!)
            }
        } else {
            self.init(url: URL.init(string: "http://www.baidu.com")!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if #available(iOS 10.0, *) {
            self.preferredBarTintColor = kTextBlackColor
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 10.0, *) {
//            self.preferredControlTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 11.0, *) {
            self.dismissButtonStyle = .close
        } else {
            // Fallback on earlier versions
        }
        
    }

}

extension JSafariController: SFSafariViewControllerDelegate {
    
    //按钮点击
    func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity] {
        self.title = title
        return [UIActivity()]
    }
    
    func safariViewController(_ controller: SFSafariViewController, excludedActivityTypesFor URL: URL, title: String?) -> [UIActivity.ActivityType] {
        return [UIActivity.ActivityType.init("")]
    }
    
    //返回
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        
    }
    
    //进入加载完成
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        
    }
    
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        
    }
}

