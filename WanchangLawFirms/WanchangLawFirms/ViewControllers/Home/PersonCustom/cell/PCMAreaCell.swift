//
//  PCMAreaCell.swift
//  OLegal
//
//  Created by lh on 2018/11/27.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 会面咨询地点
class PCMAreaCell: BaseCell {

    var bind: String = "" {
        didSet {
            if bind == "h_meet_time_duration" {
                btn.setTitle("下午14:30-16:30", for: .normal)
                btn.setImage(UIImage.init(named: "triangle_down_black"), for: .normal)
                btn.isUserInteractionEnabled = true
            } else if bind == "h_meet_area" {
                btn.setTitle("固定地点，欧伶猪公司", for: .normal)
                btn.setImage(nil, for: .normal)
                btn.isUserInteractionEnabled = false
            } else if bind == "h_meet_teach_obj" {
                btn.setTitle(L$("p_enter_teach_obj"), for: .normal)
                btn.setImage(UIImage.init(named: "triangle_down_black"), for: .normal)
                btn.isUserInteractionEnabled = false
            } else if bind == "h_meet_teach_content" {
                btn.setTitle(L$("p_enter_teach_content"), for: .normal)
                btn.setImage(UIImage.init(named: "triangle_down_black"), for: .normal)
                btn.isUserInteractionEnabled = false
            }
        }
    }
    private lazy var btn: HImgCenterAlignmentBtn = {
        () -> HImgCenterAlignmentBtn in
        let temp = HImgCenterAlignmentBtn.init(kFontMS, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, self, #selector(btnsClisk(sender:)))
        temp.layer.cornerRadius = 20
        temp.layer.borderColor = kLineGrayColor.cgColor
        temp.layer.borderWidth = 1
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
        self.addSubview(btn)
        let space: CGFloat = 50
        _ = btn.sd_layout()?.leftSpaceToView(self, space)?.rightSpaceToView(self, space)?.centerYEqualToView(self)?.heightIs(40)
    }
    
    @objc private func btnsClisk(sender: HImgCenterAlignmentBtn) {
        let amStr = "上午9:30-11:30"
        let pmStr = "下午14:30-16:30"
        let alertCon = UIAlertController.init(title: "选择时间段", message: nil, preferredStyle: .actionSheet)
        let amAction = UIAlertAction.init(title: amStr, style: .default, handler: { (action) in
            sender.setTitle(amStr, for: .normal)
            JMeetManager.share.model.time = "0"
        })
        let pmAction = UIAlertAction.init(title: pmStr, style: .default, handler: { (action) in
            sender.setTitle(pmStr, for: .normal)
            JMeetManager.share.model.time = "1"
        })
        let cancelAction = UIAlertAction.init(title: L$("cancel"), style: .cancel, handler: nil)
        alertCon.addAction(amAction)
        alertCon.addAction(pmAction)
        alertCon.addAction(cancelAction)
        JAuthorizeManager.init(view: self).responseChainViewController().present(alertCon, animated: true, completion: nil)
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
