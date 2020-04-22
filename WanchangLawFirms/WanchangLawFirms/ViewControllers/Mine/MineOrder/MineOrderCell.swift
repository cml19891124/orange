//
//  MineOrderCell.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol MineOrderCellDelegate: NSObjectProtocol {
    func mineOrderCellAsk(model: MessageModel)
}

class MineOrderCell: BaseCell {
    
    weak var delegate: MineOrderCellDelegate?
    var status: String = ""
    var model: MessageModel! {
        didSet {
            typeLab.text = model.product_title
            timeLab.text = model.created_at.theDateYMDStr()
            desLab.text = model.desc
            btnsView.status = status
            btnsView.model = model
            avatarImgView.avatar = model.avatar
        }
    }
    
    
    private let avatarImgView: JAvatarImgView = JAvatarImgView.init(cornerRadius: kAvatarWH / 2)
    private let typeLab: UILabel = UILabel.init(kFontM, kOrangeDarkColor, NSTextAlignment.left)
    private let timeLab: UILabel = UILabel.init(kFontS, kTextGrayColor, NSTextAlignment.right)
    private let desLab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    private let arrow: UIImageView = UIImageView.init(UIView.ContentMode.scaleAspectFit)
    
    private let btnsView: MineOrderBtnsView = MineOrderBtnsView.init(frame: CGRect.init(x: 0, y: 110, width: kDeviceWidth, height: 30))
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func askBtnClick() {
        self.delegate?.mineOrderCellAsk(model: model)
    }
    
    private func setupViews() {
        desLab.adjustsFontSizeToFitWidth = false
        self.addSubview(avatarImgView)
        self.addSubview(typeLab)
        self.addSubview(timeLab)
        self.addSubview(desLab)
        self.addSubview(btnsView)
        
        _ = btnsView.sd_layout()?.bottomSpaceToView(self, 10)?.centerXEqualToView(self)?.widthIs(kDeviceWidth)?.heightIs(30)
        _ = avatarImgView.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, kLeftSpaceS)?.widthIs(kAvatarWH)?.heightIs(kAvatarWH)
        _ = typeLab.sd_layout()?.topSpaceToView(self, kLeftSpaceS)?.leftSpaceToView(avatarImgView, kLeftSpaceS)?.widthIs(100)?.heightIs(20)
        _ = timeLab.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(typeLab)?.widthIs(150)?.heightIs(20)
        _ = desLab.sd_layout()?.leftEqualToView(typeLab)?.rightSpaceToView(self, 40)?.topSpaceToView(typeLab, 5)?.bottomSpaceToView(btnsView, kLeftSpaceS)
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
