//
//  JlogOffView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/3/5.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class JlogOffView: UIView {

    private let bView: UIView = UIView()
    private let progressView: ProgressView = ProgressView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
    private lazy var timer: Timer = {
        () -> Timer in
        let temp = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        return temp
    }()
    private lazy var tapBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontXXL, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(btnClick))
        temp.backgroundColor = kOrangeDarkColor
        temp.layer.cornerRadius = 45
        return temp
    }()
    private lazy var topView: UIView = {
        () -> UIView in
        let temp = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 50))
        let imgView = UIImageView.init(UIView.ContentMode.scaleAspectFill)
        imgView.frame = temp.bounds
        imgView.image = UIImage.navImage()
        temp.addSubview(imgView)
        return temp
    }()
    private lazy var lineLabLineView: JLineLabLineView = {
        () -> JLineLabLineView in
        let temp = JLineLabLineView.init(textColor: UIColor.white, font: kFontM, lineColor: UIColor.white)
        temp.backgroundColor = UIColor.clear
        temp.bind = "注销账号"
        return temp
    }()
    private let desLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.center)
    private var count: Int = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        self.layer.opacity = 0
        UIApplication.shared.keyWindow?.addSubview(self)
        self.setupViews()
        self.timer.fire()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        bView.backgroundColor = kCellColor
        bView.layer.cornerRadius = 10
        bView.clipsToBounds = true
        progressView.layer.cornerRadius = 50
        progressView.isHidden = false
        
        tapBtn.setTitle("10", for: .normal)
        desLab.text = "10秒内点击10下按钮完成注销"
        self.addSubview(bView)
        bView.addSubview(topView)
        topView.addSubview(lineLabLineView)
        bView.addSubview(progressView)
        bView.addSubview(tapBtn)
        bView.addSubview(desLab)
        
        _ = bView.sd_layout()?.centerXEqualToView(self)?.centerYEqualToView(self)?.widthIs(kDeviceWidth - 50)?.heightIs(250)
        _ = topView.sd_layout()?.topSpaceToView(bView, 0)?.leftSpaceToView(bView, 0)?.rightSpaceToView(bView, 0)?.heightIs(50)
        _ = lineLabLineView.sd_layout()?.leftEqualToView(topView)?.topEqualToView(topView)?.rightEqualToView(topView)?.bottomEqualToView(topView)
        _ = desLab.sd_layout()?.bottomSpaceToView(bView, 0)?.leftEqualToView(bView)?.rightEqualToView(bView)?.heightIs(50)
        
        _ = progressView.sd_layout()?.centerXEqualToView(bView)?.centerYEqualToView(bView)?.widthIs(100)?.heightIs(100)
        _ = tapBtn.sd_layout()?.centerXEqualToView(bView)?.centerYEqualToView(bView)?.widthIs(90)?.heightIs(90)
    }
    
    @objc private func timerAction() {
        self.progressView.progress += 0.001
        if self.progressView.progress >= 1 {
            self.finishHide()
        }
    }
    
    @objc private func btnClick() {
        self.count -= 1
        self.tapBtn.setTitle("\(count)", for: .normal)
        if self.count <= 0 {
            self.finishHide()
            UserInfo.share.userDestroy(success: { (flag) in
                if flag {
                    JRootVCManager.share.rootLogin()
                }
            })
        }
    }
    
    private func finishHide() {
        self.timer.invalidate()
        OLAlertManager.share.logOffHide()
    }

}
