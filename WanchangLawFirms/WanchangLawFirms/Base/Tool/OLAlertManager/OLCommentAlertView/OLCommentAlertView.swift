//
//  OLCommentAlertView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/18.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol OLCommentAlertViewDelegate: NSObjectProtocol {
    func olCommentAlertViewEnd(ok: Bool, text: String, score: Float)
}

class OLCommentAlertView: UIView {
    
    weak var delegate: OLCommentAlertViewDelegate?
    
    private lazy var bView: UIView = {
        () -> UIView in
        let temp = UIView.init(baseColor: UIColor.white)
        return temp
    }()
    private lazy var topView: UIView = {
        () -> UIView in
        let temp = UIView()
        let gradLayer = CAGradientLayer.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth - kLeftSpaceL * 2, height: 60), startPoint: CGPoint.init(x: 0, y: 0), endPoint: CGPoint.init(x: 0, y: 1), colors: [kNavGradeStartColor, kNavGradeEndColor])
        temp.layer.addSublayer(gradLayer)
        return temp
    }()
    private lazy var titleV: JLineLabLineView = {
        () -> JLineLabLineView in
        let temp = JLineLabLineView.init(textColor: UIColor.white, font: kFontL, lineColor: UIColor.white)
        return temp
    }()
    private let scoreV: OLCScoreView = OLCScoreView.init(isBig: true)
    private lazy var tv: JTextView = {
        () -> JTextView in
        let temp = JTextView.init(font: kFontMS)
        temp.placeholder = "发表您的看法(300字以内)"
        return temp
    }()
    private lazy var okBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontL, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(btnsClick(sender:)))
        temp.setTitle(L$("sure"), for: .normal)
        temp.layer.cornerRadius = 20
        temp.clipsToBounds = true
        let gradLayer = CAGradientLayer.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth - kLeftSpaceL * 2, height: 40), startPoint: CGPoint.init(x: 0, y: 0), endPoint: CGPoint.init(x: 1, y: 0), colors: [kBtnGradeStartColor, kBtnGradeEndColor])
        temp.layer.insertSublayer(gradLayer, at: 0)
        return temp
    }()
    private lazy var backBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, kTextGrayColor, UIControl.ContentHorizontalAlignment.center, self, #selector(btnsClick(sender:)))
        temp.setImage(UIImage.init(named: "corss_border_white"), for: .normal)
        return temp
    }()
    
    convenience init(text: String, score: Float) {
        self.init()
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        self.layer.opacity = 0
        UIApplication.shared.keyWindow?.addSubview(self)
        self.setupViews()
        tv.text = text
        scoreV.score = score
        self.tv.becomeFirstResponder()
    }
    
    private func setupViews() {
        titleV.bind = L$("comment")
        tv.delegate = self
        tv.layer.borderColor = kLineGrayColor.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = kBtnCornerR
        
        self.addSubview(bView)
        bView.addSubview(topView)
        topView.addSubview(titleV)
        bView.addSubview(scoreV)
        bView.addSubview(tv)
        bView.addSubview(okBtn)
        self.addSubview(backBtn)
        
        _ = bView.sd_layout()?.centerXEqualToView(self)?.topSpaceToView(self, kBarStatusHeight + 80)?.widthIs(kDeviceWidth - kLeftSpaceL * 2)?.heightIs(330)
        _ = topView.sd_layout()?.leftEqualToView(bView)?.topEqualToView(bView)?.rightEqualToView(bView)?.heightIs(60)
        _ = titleV.sd_layout()?.leftSpaceToView(topView, 50)?.rightSpaceToView(topView, 50)?.centerYEqualToView(topView)?.heightIs(30)
        _ = scoreV.sd_layout()?.leftEqualToView(bView)?.rightEqualToView(bView)?.topSpaceToView(topView, 0)?.heightIs(50)
        _ = okBtn.sd_layout()?.leftSpaceToView(bView, kLeftSpaceL)?.rightSpaceToView(bView, kLeftSpaceL)?.bottomSpaceToView(bView, kLeftSpaceL)?.heightIs(40)
        _ = tv.sd_layout()?.leftSpaceToView(bView, kLeftSpaceS)?.rightSpaceToView(bView, kLeftSpaceS)?.topSpaceToView(scoreV, 0)?.bottomSpaceToView(okBtn, kLeftSpaceL)
        _ = backBtn.sd_layout()?.centerXEqualToView(self)?.topSpaceToView(bView, kLeftSpaceL)?.widthIs(40)?.heightIs(40)
    }
    
    @objc private func btnsClick(sender: UIButton) {
        OLAlertManager.share.commentHide()
        var ok: Bool = false
        if sender.isEqual(okBtn) {
            ok = true
            if tv.text.haveTextStr() != true {
                PromptTool.promptText("评论内容不能为空", 1)
                return
            } else if tv.text.count > 300 {
                PromptTool.promptText(L$("limit_comment_max"), 1)
                return
            }
        }
        self.delegate?.olCommentAlertViewEnd(ok: ok, text: tv.text, score: scoreV.score)
    }

}

extension OLCommentAlertView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "" {
            return true
        }
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        if textView.text.count > 300 {
            PromptTool.promptText(L$("limit_comment_max"), 1)
            return false
        }
        return true
    }
}
