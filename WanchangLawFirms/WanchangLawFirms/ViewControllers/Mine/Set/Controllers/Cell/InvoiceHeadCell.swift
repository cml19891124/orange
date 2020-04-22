//
//  InvoiceHeadCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class InvoiceHeadCell: BaseCell {
    
    let tf: JTextField = JTextField.init(font: kFontMS)
    let line: UIView = UIView.init(lineColor: kLineGrayColor)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.addSubview(tf)
        self.addSubview(line)
        _ = tf.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.heightIs(30)
        _ = line.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.bottomEqualToView(self)?.heightIs(kLineHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
