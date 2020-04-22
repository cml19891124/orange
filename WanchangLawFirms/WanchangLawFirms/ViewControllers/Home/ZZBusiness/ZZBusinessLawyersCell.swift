//
//  ZZBusinessLawyersCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/28.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class ZZBusinessLawyersCell: BaseCell {
    
    var model: LawyerModel! {
        didSet {
            avatarImgView.avatar = model.avatar
            titleLab.text = model.name
            desLab.text = model.desc
            var score: Float = 0.0
            let s1 = Float(model.order_star_all)
            let s2 = Float(model.order_star_num)
            if s1 != nil && s2 != nil {
                if s2 != 0 {
                    score = s1! / s2!
                }
            }
            var meetCount: Int = 0
            let c1 = Int(model.subscribe_count)
            if c1 != nil {
                meetCount = c1!
            }
            scoreLab.text = String.init(format: "评分：%.1f     预约量%d", score, meetCount)
        }
    }
    
    private let bView: UIView = UIView()
    private let avatarImgView: JAvatarImgView = JAvatarImgView.init(cornerRadius: kAvatarWH / 2)
    private let titleLab: UILabel = UILabel.init(kFontMS, kTextBlackColor, NSTextAlignment.left)
    private let desLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    private let scoreLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    private lazy var appointBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(btnsClick(sender:)))
        let gradLayer = CAGradientLayer.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 40), startPoint: CGPoint.init(x: 0, y: 0), endPoint: CGPoint.init(x: 1, y: 0), colors: [kBtnGradeStartColor, kBtnGradeEndColor])
        temp.layer.insertSublayer(gradLayer, at: 0)
        temp.layer.cornerRadius = 15
        temp.clipsToBounds = true
        temp.setTitle("点击预约", for: .normal)
        return temp
    }()
    private lazy var lawyerBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, kOrangeDarkColor, UIControl.ContentHorizontalAlignment.center, self, #selector(btnsClick(sender:)))
        temp.layer.cornerRadius = 15
        temp.layer.borderColor = kOrangeDarkColor.cgColor
        temp.layer.borderWidth = 1
        temp.clipsToBounds = true
        temp.setTitle("律师函定制", for: .normal)
        return temp
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        desLab.adjustsFontSizeToFitWidth = false
        bView.layer.cornerRadius = kBtnCornerR
        bView.layer.borderWidth = 2
        bView.layer.borderColor = kOrangeDarkColor.cgColor
        self.addSubview(bView)
        bView.addSubview(avatarImgView)
        bView.addSubview(titleLab)
        bView.addSubview(desLab)
        bView.addSubview(scoreLab)
        bView.addSubview(appointBtn)
        bView.addSubview(lawyerBtn)
        
        _ = bView.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.rightSpaceToView(self, kLeftSpaceL)?.topSpaceToView(self, kLeftSpaceL)?.bottomSpaceToView(self, 0)
        _ = avatarImgView.sd_layout()?.leftSpaceToView(bView, kLeftSpaceL)?.topSpaceToView(bView, kLeftSpaceL)?.widthIs(kAvatarWH)?.heightIs(kAvatarWH)
        _ = titleLab.sd_layout()?.leftSpaceToView(avatarImgView, kLeftSpaceS)?.rightSpaceToView(bView, kLeftSpaceS)?.topEqualToView(avatarImgView)?.heightIs(20)
        _ = desLab.sd_layout()?.leftEqualToView(titleLab)?.rightEqualToView(titleLab)?.topSpaceToView(titleLab, 0)?.heightIs(40)
        _ = scoreLab.sd_layout()?.leftEqualToView(titleLab)?.rightEqualToView(titleLab)?.topSpaceToView(desLab, 0)?.heightIs(20)
        _ = appointBtn.sd_layout()?.bottomSpaceToView(bView, kLeftSpaceM)?.centerXEqualToView(bView)?.widthIs(100)?.heightIs(30)
    }
    
    @objc private func btnsClick(sender: UIButton) {
        if sender.isEqual(appointBtn) {
            let vc = ZZBusinessMeetLawyerController()
            vc.lawyer = model
            JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
        }
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
