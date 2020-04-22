//
//  ArticleManager.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/2.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class ArticleManager: NSObject {
    static let share = ArticleManager()
    
    var showModel: HomeModel?
    var model: HomeModel?
    
    var articleVC: ArticleDetailController?
    
    lazy var logoImgView: UIImageView = {
        () -> UIImageView in
        let temp = UIImageView.init(frame: CGRect.init(x: kDeviceWidth - 80, y: kNavHeight + 70, width: 70, height: 70))
        temp.backgroundColor = UIColor.clear
        temp.layer.cornerRadius = 35
        temp.clipsToBounds = true
        temp.layer.borderColor = kGrayColor.cgColor
        temp.layer.borderWidth = 8
        temp.isHidden = true
        temp.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(logoMove(gesture:)))
        temp.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(logoTap(tap:)))
        temp.addGestureRecognizer(tap)
        return temp
    }()
    private lazy var hideView: ArticleFloatView = {
        () -> ArticleFloatView in
        let temp = ArticleFloatView.init(frame: CGRect.init(x: kDeviceWidth, y: kDeviceHeight, width: 240, height: 240))
        return temp
    }()
    private var currentIsBig: Bool = false
    private var hideIsShow: Bool = false
    
    func clearAll() {
        self.showModel = nil
        self.articleVC = nil
        self.logoImgView.isHidden = true
        self.logoImgView.origin = CGPoint.init(x: kDeviceWidth - 100, y: kNavHeight + 70)
    }
}

extension ArticleManager {
    func figureBeganAt(point: CGPoint) {
        self.hideView.setFloat()
        UIApplication.shared.keyWindow?.addSubview(hideView)
        UIApplication.shared.keyWindow?.addSubview(logoImgView)
    }
    
    func figureMoveAt(point: CGPoint) {
        if point.x < kDeviceWidth / 4 {
            hideView.origin = CGPoint.init(x: kDeviceWidth, y: kDeviceHeight)
        } else if point.x < kDeviceWidth / 2 {
            let percent = (point.x - kDeviceWidth / 4) / (kDeviceWidth / 4)
            hideView.origin = CGPoint.init(x: kDeviceWidth - 120 * percent, y: kDeviceHeight - 120 * percent)
        } else {
            if (point.y > kDeviceHeight - 80) && (point.x > kDeviceWidth - 80) {
                if !currentIsBig {
                    currentIsBig = true
                    UIView.animate(withDuration: 0.25) {
                        self.hideView.center = CGPoint.init(x: kDeviceWidth, y: kDeviceHeight)
                        self.hideView.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
                    }
                }
            } else {
                if currentIsBig {
                    currentIsBig = false
                    UIView.animate(withDuration: 0.25) {
                        self.hideView.center = CGPoint.init(x: kDeviceWidth, y: kDeviceHeight)
                        self.hideView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                    }
                }
            }
        }
    }
    
    func figureEndAt(point: CGPoint) {
        if (point.x > kDeviceWidth - 80) && (point.y > kDeviceHeight - 80) {
            self.showModel = model
            logoImgView.isHidden = false
            if showModel?.urlStr != nil {
                logoImgView.sd_setImage(with: URL.init(string: showModel!.urlStr), completed: nil)
            }
            self.logoImgView.center = point
            UIView.animate(withDuration: 0.25) {
                self.logoImgView.origin = CGPoint.init(x: kDeviceWidth - 80, y: kNavHeight + 70)
            }
        } else {
            logoImgView.isHidden = true
            self.model = nil
        }
        self.floatEnd()
    }
}

extension ArticleManager {
    @objc private func logoMove(gesture: UIPanGestureRecognizer) {
        let point = gesture.location(in: UIApplication.shared.keyWindow)
        switch gesture.state {
        case .began:
            hideIsShow = false
            self.hideView.cancelFloat()
            break
        case .changed:
            self.logoImgView.center = point
            if !hideIsShow {
                hideIsShow = true
                UIView.animate(withDuration: 0.25) {
                    self.hideView.center = CGPoint.init(x: kDeviceWidth, y: kDeviceHeight)
                }
            }
            if (point.x > kDeviceWidth - 120) && (point.y > kDeviceHeight - 120) {
                if !currentIsBig {
                    currentIsBig = true
                    UIView.animate(withDuration: 0.25) {
                        self.hideView.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
                    }
                }
            } else {
                if currentIsBig {
                    currentIsBig = false
                    UIView.animate(withDuration: 0.25) {
                        self.hideView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                    }
                }
            }
            break
        case .ended:
            if (point.x > kDeviceWidth - 120) && (point.y > kDeviceHeight - 120) {
                self.clearAll()
            } else {
                var x1: CGFloat = 10
                var y1: CGFloat = point.y
                if point.x > kDeviceWidth / 2 {
                    x1 = kDeviceWidth - 80
                }
                if y1 < kNavHeight + 10 {
                    y1 = kNavHeight + 10
                } else if y1 > kDeviceHeight - kTabBarHeight - 80 {
                    y1 = kDeviceHeight - kTabBarHeight - 80
                }
                UIView.animate(withDuration: 0.25) {
                    self.logoImgView.origin = CGPoint.init(x: x1, y: y1)
                }
            }
            self.floatEnd()
            break
        default:
            break
        }
    }
    
    @objc private func logoTap(tap: UITapGestureRecognizer) {
        guard let tabVC = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {
            return
        }
        guard let nav = tabVC.selectedViewController as? BaseNavigationController else {
            return
        }
        if articleVC != nil {
            articleVC?.transitionType = .article
            nav.pushViewController(articleVC!, animated: true)
            return
        }
        guard let temp = showModel else {
            return
        }
        let vc = ArticleDetailController()
        vc.transitionType = .article
        vc.model = temp
        nav.pushViewController(vc, animated: true)
    }
}

extension ArticleManager {
    private func floatEnd() {
        UIView.animate(withDuration: 0.25) {
            self.hideView.origin = CGPoint.init(x: kDeviceWidth, y: kDeviceHeight)
            self.hideView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        }
    }
}
