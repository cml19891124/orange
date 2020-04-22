//
//  SetNotiCell.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol SetNotiCellDelegate: NSObjectProtocol {
    func setNotiCellClick(mSwitch: UISwitch, bind: String)
}

class SetNotiCell: MineCell {
    
    weak var delegate: SetNotiCellDelegate?
    
    let mswitch: UISwitch = UISwitch()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.arrow.isHidden = true
        mswitch.onTintColor = kOrangeDarkColor
        mswitch.addTarget(self, action: #selector(mSwitchClick), for: .valueChanged)
        self.addSubview(mswitch)
        _ = mswitch.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.widthIs(80)?.heightIs(30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func mSwitchClick() {
        self.delegate?.setNotiCellClick(mSwitch: mswitch,bind: bind)
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
