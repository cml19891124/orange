//
//  OrangeBankPreviewView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/27.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class OrangeBankPreviewView: UIView {
    
    
    private let bView = UIView()
    private lazy var topV: UIView = {
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
        temp.bind = "线下转账信息"
        return temp
    }()
    let bankView: OBPView = OBPView.init(frame: CGRect.init(x: 0, y: 50, width: kDeviceWidth, height: 400))
    private lazy var backBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton()
        temp.setImage(UIImage.init(named: "corss_border_white"), for: .normal)
        temp.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        self.layer.opacity = 0
        UIApplication.shared.keyWindow?.addSubview(self)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        bView.clipsToBounds = true
        bView.backgroundColor = kCellColor
        bView.layer.cornerRadius = 10
        bView.clipsToBounds = true
        
        
        self.addSubview(bView)
        bView.addSubview(topV)
        topV.addSubview(lineLabLineView)
        bView.addSubview(bankView)
        self.addSubview(backBtn)
        
        _ = bView.sd_layout()?.centerXEqualToView(self)?.centerYEqualToView(self)?.widthIs(kDeviceWidth - 50)?.heightIs(kDeviceWidth)
        _ = topV.sd_layout()?.leftEqualToView(bView)?.rightEqualToView(bView)?.topEqualToView(bView)?.heightIs(50)
        _ = lineLabLineView.sd_layout()?.leftSpaceToView(topV, kLeftSpaceL)?.topEqualToView(topV)?.rightSpaceToView(topV, kLeftSpaceL)?.bottomEqualToView(topV)
        _ = bankView.sd_layout()?.leftEqualToView(bView)?.topSpaceToView(topV, 0)?.rightEqualToView(bView)?.bottomEqualToView(bView)
        _ = backBtn.sd_layout()?.centerXEqualToView(self)?.topSpaceToView(bView, kLeftSpaceS)?.widthIs(40)?.heightIs(40)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        OLAlertManager.share.orangeBankHide()
//    }
    
    @objc private func backBtnClick() {
        OLAlertManager.share.orangeBankHide()
    }

}
