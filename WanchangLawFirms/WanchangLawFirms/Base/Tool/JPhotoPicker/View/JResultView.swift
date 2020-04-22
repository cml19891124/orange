//
//  JResultView.swift
//  OLegal
//
//  Created by lh on 2018/11/24.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import Photos

class JResultView: UIView {
    
    private lazy var oriBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init()
        temp.contentHorizontalAlignment = .left
        temp.setTitleColor(UIColor.white, for: .normal)
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        temp.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        self.addSubview(temp)
        return temp
    }()
    private lazy var doneBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton()
        temp.contentHorizontalAlignment = .right
        temp.setTitleColor(UIColor.white, for: .normal)
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        temp.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        self.addSubview(temp)
        return temp
    }()
    private let bView: UIView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.judgeResult()
        NotificationCenter.default.addObserver(self, selector: #selector(judgeResult), name: NSNotification.Name(rawValue: JPhoto_Noti_Select_Change), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        oriBtn.isSelected = JPhotoCenter.share.isOriginal
        self.addSubview(bView)
        bView.addSubview(oriBtn)
        bView.addSubview(doneBtn)
        _ = bView.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.heightIs(44)
        _ = oriBtn.sd_layout()?.leftSpaceToView(bView, 20)?.centerYEqualToView(bView)?.widthIs(150)?.heightIs(30)
        _ = doneBtn.sd_layout()?.rightSpaceToView(bView, 20)?.centerYEqualToView(bView)?.widthIs(100)?.heightIs(30)
    }
    
    @objc private func btnClick(sender: UIButton) {
        if sender.isEqual(oriBtn) {
            JPhotoCenter.share.isOriginal = !JPhotoCenter.share.isOriginal
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: JPhoto_Noti_Select_Change), object: nil)
        } else {
            JPhotoCenter.share.endPicker()
            JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func judgeResult() {
        oriBtn.isSelected = JPhotoCenter.share.isOriginal
        var tempStr1 = "  "
        switch JPhotoCenter.share.cutType {
        case .onlyCut:
            oriBtn.setImage(nil, for: .normal)
            oriBtn.isUserInteractionEnabled = false
            break
        case .onlyOriginal:
            oriBtn.setImage(nil, for: .normal)
            oriBtn.isUserInteractionEnabled = false
            tempStr1 += L$("original_graph")
            tempStr1 += self.calcuteResult()
            break
        case .OriginalCut:
            oriBtn.setImage(UIImage.init(named: "JPhoto_circle"), for: .normal)
            oriBtn.setImage(UIImage.init(named: "JPhoto_selected"), for: .selected)
            oriBtn.isUserInteractionEnabled = true
            tempStr1 += L$("original_graph")
            if JPhotoCenter.share.isOriginal {
                tempStr1 += self.calcuteResult()
            }
            break
        }
        var tempStr2 = L$("finish")
        if JPhotoCenter.share.selectedAsset.count > 0 {
            tempStr2 += "(\(JPhotoCenter.share.selectedAsset.count))"
            self.enableStatus()
        } else {
            self.disEnableStatus()
        }
        oriBtn.setTitle(tempStr1, for: .normal)
        doneBtn.setTitle(tempStr2, for: .normal)
    }
    
    private func calcuteResult() -> String {
        var temp: Int = 0
        for asset in JPhotoCenter.share.selectedAsset {
            temp += asset.fileSize
        }
        if temp > 0 {
            let result = JPhotoManager.share.lengthStrFrom(length: temp)
            return "  (\(result))"
        }
        return ""
    }
    
    private func enableStatus() {
        self.backgroundColor = kOrangeDarkColor
        self.isUserInteractionEnabled = true
    }
    
    private func disEnableStatus() {
        self.backgroundColor = kOrangeLightColor
        self.isUserInteractionEnabled = false
    }

}
