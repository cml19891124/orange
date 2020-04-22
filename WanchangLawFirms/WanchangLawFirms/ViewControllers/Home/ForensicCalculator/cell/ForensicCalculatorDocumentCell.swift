//
//  ForensicCalculatorDocumentCell.swift
//  OLegal
//
//  Created by lh on 2018/11/23.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import SafariServices

/// 计算文档
class ForensicCalculatorDocumentCell: BaseCell {
    
    var bind: String = ""
    var model: FCDocModel! {
        didSet {
            let str1 = "本\(L$(bind))器的计算方法按现行"
            let xieyi = "《" + model.title + "》"
            let str2 = "编制"
            lab.text = str1 + xieyi + str2
            lab.addClickText(str: xieyi, original_color: kOrangeDarkColor, click_color: kOrangeDarkClickColor)
        }
    }
    
    lazy var lab: LLabel = {
        () -> LLabel in
        let temp = LLabel.init(font: kFontMS, textAlignment: NSTextAlignment.center)
        temp.delegate = self
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
        self.addSubview(lab)
        _ = lab.sd_layout()?.leftSpaceToView(self, 40)?.rightSpaceToView(self, 40)?.topSpaceToView(self, 0)?.bottomSpaceToView(self, 0)
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

extension ForensicCalculatorDocumentCell: LLabelDelegate {
    func llabelClick(text: String) {
//        let vc = FCDocumentController()
//        vc.bind = bind
//        vc.model = model
//        JAuthorizeManager.init(view: self).responseChainViewController().navigationController?.pushViewController(vc, animated: true)
        var type = "sue"
        if bind == "h_lawyer_fee_calculation" {
            type = "lawyer"
        } 
        let urlStr = BASE_URL + api_counter_info + "?id=" + model.id + "&type=" + type
        let vc = JSafariController.init(urlStr: urlStr, title: model.title)
        JAuthorizeManager.init(view: self).responseChainViewController().present(vc, animated: true, completion: nil)
    }
}
