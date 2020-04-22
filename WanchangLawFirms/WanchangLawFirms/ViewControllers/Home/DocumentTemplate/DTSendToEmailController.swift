//
//  DTSendToEmailController.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/12.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 发送到邮箱
class DTSendToEmailController: BaseController {
    
    var model: HomeModel!
    
    private lazy var sendView: DTSendToEmailView = {
        () -> DTSendToEmailView in
        let temp = DTSendToEmailView.init(frame: CGRect.init(x: 0, y: 20 + kNavHeight, width: kDeviceWidth, height: 70))
        self.view.addSubview(temp)
        return temp
    }()
    private let imgView: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFill)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = model.title
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: L$("preview"), style: .done, target: self, action: #selector(previewClick))
        self.setupViews()
    }
    
    private func setupViews() {
        self.sendView.id = model.id
        self.imgView.backgroundColor = kCellColor
        self.imgView.frame = CGRect.init(x: kLeftSpaceL, y: 120 + kNavHeight, width: kDeviceWidth - kLeftSpaceL * 2, height: kDeviceHeight - kNavHeight - 130)
        self.imgView.sd_setImage(with: URL.init(string: model.urlStr), completed: nil)
        self.view.addSubview(imgView)
    }

}
