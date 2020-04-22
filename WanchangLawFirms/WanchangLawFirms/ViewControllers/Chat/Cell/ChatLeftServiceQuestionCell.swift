//
//  ChatLeftServiceQuestionCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/20.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

protocol ChatLeftServiceQuestionCellDelegate: NSObjectProtocol {
    func chatLeftServiceQuestionCellClick(keyword: String)
}

/// 客服消息常见问题
class ChatLeftServiceQuestionCell: ChatLeftBaseCell {
    
    override var msg: STMessage! {
        didSet {
            self.modelArr = msg.j_model.attributeModel.autoReplyArr
            self.tableView.reloadData()
        }
    }
    
    weak var delegate: ChatLeftServiceQuestionCellDelegate?
    
    private var modelArr: [JAutoReplyModel] = [JAutoReplyModel]()
    
    private lazy var tableView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect(), style: .plain, space: 0)
        temp.separatorStyle = .none
        temp.delegate = self
        temp.dataSource = self
        temp.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        temp.register(CLSQuestionTitleCell.self, forCellReuseIdentifier: "CLSQuestionTitleCell")
        temp.register(CLSQuestionCell.self, forCellReuseIdentifier: "CLSQuestionCell")
        return temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bubbleImgView.addSubview(tableView)
        _ = tableView.sd_layout()?.leftSpaceToView(bubbleImgView, kBubbleSpaceL)?.topSpaceToView(bubbleImgView, kBubbleSpaceS)?.rightSpaceToView(bubbleImgView, kBubbleSpaceS)?.bottomSpaceToView(bubbleImgView, kBubbleSpaceS)
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

extension ChatLeftServiceQuestionCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CLSQuestionTitleCell", for: indexPath) as! CLSQuestionTitleCell
            cell.lab.text = msg.j_model.content
            return cell
        }
        let model = modelArr[indexPath.row - 1]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CLSQuestionCell", for: indexPath) as! CLSQuestionCell
        cell.keyword = model.keyword
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 25
        }
        let model = modelArr[indexPath.row - 1]
        return model.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        let model = modelArr[indexPath.row - 1]
        self.delegate?.chatLeftServiceQuestionCellClick(keyword: model.keyword)
    }
}
