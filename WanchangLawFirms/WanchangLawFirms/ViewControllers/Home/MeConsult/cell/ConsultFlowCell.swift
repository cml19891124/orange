//
//  ConsultFlowCell.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 我要咨询快速入门
class ConsultFlowCell: ConsultTypeCell {
    
    var content: String?
    
    var type_bind: String = ""
    private lazy var enterBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(btnClick))
        temp.backgroundColor = kOrangeDarkColor
        temp.layer.cornerRadius = 15
        temp.clipsToBounds = true
        temp.setTitle(L$("h_quick_get"), for: .normal)
        let gradLayer: CAGradientLayer = CAGradientLayer.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 30), startPoint: CGPoint.init(x: 0, y: 0), endPoint: CGPoint.init(x: 1, y: 0), colors: [kBtnGradeStartColor, kBtnGradeEndColor])
        temp.layer.insertSublayer(gradLayer, at: 0)
        return temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(enterBtn)
        _ = enterBtn.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(80)?.heightIs(30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func btnClick() {
        let vc = BusinessFastDoorController()
        vc.content = content
        JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
//        if UserInfo.share.is_business {
//            let vc = BusinessFastDoorController()
//            vc.content = content
//            JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
//        } else {
//            let vc = FastDoorController()
//            vc.bind = type_bind
//            JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
//        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
