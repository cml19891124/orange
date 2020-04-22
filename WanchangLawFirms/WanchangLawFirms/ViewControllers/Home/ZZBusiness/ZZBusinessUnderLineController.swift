//
//  ZZBusinessUnderLineController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class ZZBusinessUnderLineController: BaseController {
    
    private lazy var bView: UIView = {
        () -> UIView in
        let temp = UIView()
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var lawyerBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontM, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(lawyerClick))
        temp.setTitle("律师约见", for: .normal)
        temp.setBackgroundImage(UIImage.init(named: "btn_orange_bg"), for: .normal)
        self.bView.addSubview(temp)
        return temp
    }()
    private lazy var teachBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontM, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, self, #selector(teachClick))
        temp.setTitle("企业培训", for: .normal)
        temp.setBackgroundImage(UIImage.init(named: "btn_white_bg"), for: .normal)
        self.bView.addSubview(temp)
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("h_business_underline_service")
        _ = bView.sd_layout()?.centerXEqualToView(self.view)?.centerYEqualToView(self.view)?.widthIs(kDeviceWidth)?.heightIs(150)
        _ = lawyerBtn.sd_layout()?.centerXEqualToView(self.bView)?.topEqualToView(self.bView)?.widthIs(250)?.heightIs(38)
        _ = teachBtn.sd_layout()?.centerXEqualToView(self.bView)?.bottomEqualToView(self.bView)?.widthIs(250)?.heightIs(38)
    }
    

    
    @objc private func lawyerClick() {
        let vc = ZZBusinessLawyersController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func teachClick() {
        let vc = ZZBusinessMeetLawyerController()
        vc.isTeachMeet = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
