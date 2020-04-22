//
//  HomeHeadView.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol HomeCollectionDelegate: NSObjectProtocol {
    func homeCollectionClick(bind: String)
}

/// 首页的头部视图Head， 暂不使用轮播视图，单张图片显示即可
class HomeHeadView: UIView {
    
    var end_height: CGFloat = 0
    
    private var h1: CGFloat = kBarStatusHeight + 200
//    private var h1: CGFloat = 0
    private var h2: CGFloat = 150
    private var h3: CGFloat = 120
    private var space: CGFloat = 10
    private var topOffset: CGFloat = {
        () -> CGFloat in
//        if JIconManager.share.icon_type == .spring {
//            return 15
//        }
        return 20
    }()
    
    /// 轮播视图
    private lazy var bgView: HHBgView = {
        () -> HHBgView in
        let temp = HHBgView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: h1))
        end_height = h1 + h2 + h3 + space - topOffset
        return temp
    }()
    
    /// 单张图片
//    private lazy var bgView: JImgViewSelfAdapt = {
//        () -> JImgViewSelfAdapt in
//        let temp = JImgViewSelfAdapt.init(imgName: JIconManager.share.getIcon(bind: "home_top_img"), wid: kDeviceWidth)
//        temp.contentMode = .scaleAspectFill
//        h1 = temp.end_height
//        temp.frame = CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: h1)
//        end_height = h1 + h2 + h3 + space - topOffset
//        return temp
//    }()
    
    lazy var customView: HHCustomView = {
        () -> HHCustomView in
        let temp = HHCustomView.init(frame: CGRect.init(x: kLeftSpaceS, y: h1 - topOffset, width: kDeviceWidth - kLeftSpaceS * 2, height: h2))
        temp.layer.cornerRadius = kBtnCornerR
        temp.clipsToBounds = true
        return temp
    }()
    lazy var funcView: HHFuncView = {
        () -> HHFuncView in
        let temp = HHFuncView.init(frame: CGRect.init(x: kLeftSpaceS, y: h1 + h2 + space - topOffset, width: kDeviceWidth - kLeftSpaceS * 2, height: h3))
        temp.layer.cornerRadius = kBtnCornerR
        temp.clipsToBounds = true
        return temp
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kBaseColor
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(bgView)
        self.addSubview(customView)
        self.addSubview(funcView)
    }

}
