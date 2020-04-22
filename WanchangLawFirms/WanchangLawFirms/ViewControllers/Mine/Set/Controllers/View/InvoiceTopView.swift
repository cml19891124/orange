//
//  InvoiceTopView.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

protocol InvoiceTopViewDelegate: NSObjectProtocol {
    func invoiceTopViewClick(isApply: Bool)
}

class InvoiceTopView: UIView {
    
    weak var delegate: InvoiceTopViewDelegate?
    
    private lazy var bgImgView: JNavConnectImgView = {
        () -> JNavConnectImgView in
        let temp = JNavConnectImgView.init(frame: self.bounds)
        return temp
    }()
    private lazy var applyBtn: JVerticalBtn = {
        () -> JVerticalBtn in
        let temp = JVerticalBtn.init(kFontMS, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(btnsClick(sender:)))
        temp.frame = CGRect.init(x: 0, y: 0, width: kDeviceWidth / 2, height: 80)
        temp.setImage(UIImage.init(named: "m_invoice_apply"), for: .normal)
        temp.setTitle(L$("m_invoice_apply"), for: .normal)
        return temp
    }()
    private lazy var headBtn: JVerticalBtn = {
        () -> JVerticalBtn in
        let temp = JVerticalBtn.init(kFontMS, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(btnsClick(sender:)))
        temp.frame = CGRect.init(x: kDeviceWidth / 2, y: 0, width: kDeviceWidth / 2, height: 80)
        temp.setImage(UIImage.init(named: "m_invoice_head"), for: .normal)
        temp.setTitle(L$("m_invoice_head"), for: .normal)
        return temp
    }()
    private lazy var desLab: UILabel = {
        () -> UILabel in
        let temp = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
        temp.frame = CGRect.init(x: 0, y: self.frame.size.height - 50, width: kDeviceWidth, height: 50)
        temp.backgroundColor = UIColor.white
        temp.text = "    近期发票"
        self.addSubview(temp)
        let line = UIView.init(lineColor: kLineGrayColor)
        temp.addSubview(line)
        _ = line.sd_layout()?.leftEqualToView(temp)?.bottomEqualToView(temp)?.rightEqualToView(temp)?.heightIs(kLineHeight)
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
        self.addSubview(applyBtn)
        self.addSubview(headBtn)
        self.addSubview(desLab)
    }
    
    @objc private func btnsClick(sender: JVerticalBtn) {
        var open = false
        if sender.isEqual(applyBtn) {
            open = true
        }
        self.delegate?.invoiceTopViewClick(isApply: open)
    }

}
