//
//  ConsultTextCell.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 我要咨询文本框
class ConsultTextCell: BaseCell {
    
    let tv: JTextView = JTextView.init(font: kFontMS)
    
    let doneView: JKeyboardDoneView = JKeyboardDoneView.init(bind: "limit_requirement_min")
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        tv.backgroundColor = UIColor.clear
        tv.frame = CGRect.init(x: kLeftSpaceS, y: 0, width: kDeviceWidth - kLeftSpaceS * 2, height: 180)
        tv.placeholder = L$("p_enter_your_requirement")
        self.doneView.addTV(tv: tv)
        self.addSubview(tv)
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
