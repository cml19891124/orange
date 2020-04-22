//
//  JOKBtnCell.swift
//  OLegal
//
//  Created by lh on 2018/11/21.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol JOKBtnCellDelegate: NSObjectProtocol {
    func jOKBtnCellClick(sender: UIButton)
}

class JOKBtnCell: BaseCell {
    
    weak var delegate: JOKBtnCellDelegate?
    
    lazy var btn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontL, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(btnClick(sender:)))
        temp.layer.cornerRadius = 20
        temp.clipsToBounds = true
        let gradLayer = CAGradientLayer.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth - kLeftSpaceL * 2, height: 40), startPoint: CGPoint.init(x: 0, y: 0), endPoint: CGPoint.init(x: 1, y: 0), colors: [kBtnGradeStartColor, kBtnGradeEndColor])
        temp.layer.insertSublayer(gradLayer, at: 0)
        return temp
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = kBaseColor
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(btn)
        _ = btn.sd_layout()?.centerXEqualToView(self)?.centerYEqualToView(self)?.widthIs(kDeviceWidth - kLeftSpaceL * 2)?.heightIs(40)
    }
    
    @objc private func btnClick(sender: UIButton) {
        self.delegate?.jOKBtnCellClick(sender: sender)
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
