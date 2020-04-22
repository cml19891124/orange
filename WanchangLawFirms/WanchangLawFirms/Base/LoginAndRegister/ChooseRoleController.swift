//
//  ChooseRoleController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/14.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 选择个人版还是企业版界面
class ChooseRoleController: BaseController {

    private lazy var bgImgView: UIImageView = {
        () -> UIImageView in
        let temp = UIImageView()
        temp.contentMode = .scaleAspectFill
        temp.image = UIImage.init(named: "choose_bg")
        return temp
    }()
    private let bView = UIView.init(frame: CGRect.init(x: 0, y: kDeviceHeight - 70, width: kDeviceWidth, height: 40))
    private lazy var personBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontM, kRedColor, UIControl.ContentHorizontalAlignment.center, self, #selector(btnsClick(sender:)))
        temp.setTitle(L$("version_person"), for: .normal)
        temp.backgroundColor = UIColor.white
        temp.layer.cornerRadius = 20
        temp.layer.borderColor = kRedColor.cgColor
        temp.layer.borderWidth = 1
        temp.clipsToBounds = true
        return temp
    }()
    private lazy var businessBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontM, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(btnsClick(sender:)))
        temp.setTitle(L$("version_business"), for: .normal)
        temp.backgroundColor = kRedColor
        temp.layer.cornerRadius = 20
        temp.clipsToBounds = true
        return temp
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    private func setupViews() {
        self.view.addSubview(bgImgView)
        self.view.addSubview(bView)
        bView.addSubview(personBtn)
        bView.addSubview(businessBtn)
        _ = bgImgView.sd_layout()?.leftEqualToView(self.view)?.topEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
        _ = personBtn.sd_layout()?.leftSpaceToView(bView, kLeftSpaceL)?.topEqualToView(bView)?.bottomEqualToView(bView)?.widthIs((kDeviceWidth - kLeftSpaceL * 3) / 2)
        _ = businessBtn.sd_layout()?.rightSpaceToView(bView, kLeftSpaceL)?.topEqualToView(bView)?.bottomEqualToView(bView)?.widthIs((kDeviceWidth - kLeftSpaceL * 3) / 2)
    }
    
    @objc private func btnsClick(sender: UIButton) {
        if (sender.isEqual(personBtn)) {
            UserInfo.share.is_business = false
        } else {
            UserInfo.share.is_business = true
        }
        let vc = LoginController()
        vc.currentNavigationBarAlpha = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
