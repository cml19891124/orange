//
//  InvoiceHeadTFCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/26.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class InvoiceHeadTFCell: InvoiceHeadBaseCell {
    
    let tf: JTextField = JTextField.init(font: kFontMS)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        tf.textAlignment = .right
        self.addSubview(tf)
        _ = tf.sd_layout()?.rightSpaceToView(self, kLeftSpaceS)?.centerYEqualToView(self)?.leftSpaceToView(titleLab, 0)?.heightIs(30)
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
