//
//  ChatContentSearchTopView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class ChatContentSearchTopView: UIView {
    
    private lazy var bgImgView: UIImageView = {
        () -> UIImageView in
        let temp = UIImageView.init(frame: self.bounds)
        temp.image = UIImage.navImage()
        return temp
    }()
    lazy var searchBar: ChatContentSearchBar = {
        () -> ChatContentSearchBar in
        let temp = ChatContentSearchBar.init(frame: CGRect.init(x: 0, y: kBarStatusHeight, width: kDeviceWidth, height: 50))
        temp.placeholder = "请输入要搜索的聊天内容"
        return temp
    }()
    
    lazy var cancelBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(cancelClick))
        temp.frame = CGRect.init(x: kDeviceWidth - 50, y: kBarStatusHeight, width: 50, height: 50)
        temp.backgroundColor = UIColor.clear
        temp.setTitle(L$("cancel"), for: .normal)
        return temp
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(bgImgView)
        self.addSubview(searchBar)
        self.addSubview(cancelBtn)
    }
    
    @objc private func cancelClick() {
        searchBar.resignFirstResponder()
        JAuthorizeManager.init(view: self).responseChainViewController().dismiss(animated: true, completion: nil)
    }

}
