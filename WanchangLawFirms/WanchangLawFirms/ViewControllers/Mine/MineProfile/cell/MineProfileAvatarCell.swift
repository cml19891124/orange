//
//  MineProfileAvatarCell.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

class MineProfileAvatarCell: MineCell {
    
    var img: UIImage? {
        didSet {
            guard let img = img else {
                return
            }
            avatarImgView.image = img
        }
    }
    
    var remotePath: String? {
        didSet {
            avatarImgView.avatar = remotePath
        }
    }
    
    private lazy var avatarImgView: JAvatarImgView = {
        () -> JAvatarImgView in
        let wh = kCellHeight - kLeftSpaceS
        let temp = JAvatarImgView.init(cornerRadius: wh / 2)
        temp.isMe = true
        return temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews1()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews1() {
        let wh = kCellHeight - kLeftSpaceS
        avatarImgView.layer.cornerRadius = wh / 2
        avatarImgView.backgroundColor = UIColor.clear
        self.addSubview(avatarImgView)
        _ = avatarImgView.sd_layout()?.rightSpaceToView(self.arrow, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(wh)?.heightIs(wh)
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
