//
//  LoginBtnCell.swift
//  OLegal
//
//  Created by lh on 2018/11/19.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol LoginBtnCellDelegate: NSObjectProtocol {
    func loginBtnCellClick(sender: UIButton)
}

/// 登陆按钮
class LoginBtnCell: BaseCell {
    
    weak var delegate: LoginBtnCellDelegate?
    
    lazy var btn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontL, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(btnClick))
        temp.backgroundColor = kOrangeDarkColor
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
        _ = btn.sd_layout()?.leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.topEqualToView(self)
    }
    
    @objc private func btnClick() {
        self.delegate?.loginBtnCellClick(sender: btn)
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
