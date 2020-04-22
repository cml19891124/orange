//
//  ChatContentSearchCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/22.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class ChatContentSearchCell: BaseCell {
    
    var msg: STMessage! {
        didSet {
            let body = msg.body as! STTextMessageBody
            lab.text = body.text
        }
    }
    
    private let lab: UILabel = UILabel.init(kFontMS, kTextGrayColor, NSTextAlignment.left)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        lab.adjustsFontSizeToFitWidth = false
        self.addSubview(lab)
        _ = lab.sd_layout()?.leftSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceS)?.topSpaceToView(self, kLeftSpaceS)?.bottomSpaceToView(self, kLeftSpaceS)
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
