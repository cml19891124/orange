//
//  JSpringFlashView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/9.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 春节闪屏广告
class JSpringFlashView: UIView {

    
    private lazy var timer: Timer = {
        () -> Timer in
        let temp = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        return temp
    }()
    private lazy var imgView: UIImageView = {
        () -> UIImageView in
        let temp = UIImageView.init(frame: UIScreen.main.bounds)
        if JIconManager.share.icon_type == .legal {
            temp.image = UIImage.init(named: "flash_page_legal")
        } else if JIconManager.share.icon_type == .boat {
            temp.image = UIImage.init(named: "flash_page_boat")
        } else if JIconManager.share.icon_type == .midAutumn {
            temp.image = UIImage.init(named: "flash_page_mid")
        } else if JIconManager.share.icon_type == .nation {
            temp.image = UIImage.init(named: "flash_page_nation")
        } else {
            temp.image = UIImage.init(named: "flash_page_spring")
        }
        return temp
    }()
    private lazy var btn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, UIColor.white, UIControl.ContentHorizontalAlignment.right, self, #selector(close))
        temp.frame = CGRect.init(x: kDeviceWidth - 100, y: kBarStatusHeight, width: 90, height: 44)
        temp.setTitle("5秒后关闭", for: .normal)
        return temp
    }()
    private var second: Int = 5
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(imgView)
        self.addSubview(btn)
        self.timer.fire()
    }
    
    @objc private func timerAction() {
        if second <= 1 {
            timer.invalidate()
            self.close()
        } else {
            second -= 1
            let tempStr = String.init(format: "%d秒后关闭", second)
            self.btn.setTitle(tempStr, for: .normal)
        }
    }
    
    @objc private func close() {
        timer.invalidate()
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (finish) in
            self.removeFromSuperview()
            if JIconManager.share.springRest {
                self.springAlert()
            }
        }
    }
    
    private func springAlert() {
        let alertCon = UIAlertController.init(title: "春节放假通知", message: "放假时间：2019年2月2日-2019年2月8日\n值此新春佳节，欧伶猪法务咨询向广大新老客户朋友们致以深深的祝福和衷心的感谢。在此期间如有业务需求，请点击“在线客服”留言，恢复工作后第一时间为您提供服务。\n不便之处，敬请谅解。", preferredStyle: .alert)
        let sureAction = UIAlertAction.init(title: L$("sure"), style: .default, handler: { (action) in
            
        })
        alertCon.addAction(sureAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertCon, animated: true, completion: nil)
    }

}
