//
//  PersonCustomMeetPreviewCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/13.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 会面咨询预览
class PersonCustomMeetPreviewCell: BaseCell {
    
    var model: JMeetModel = JMeetModel() {
        didSet {
            self.tabView.reloadData()
        }
    }
    var isTeachMeet: Bool = false {
        didSet {
            if isTeachMeet {
                bindArr = ["h_meet_data","h_meet_time","h_meet_time_duration","h_meet_teach_area","h_meet_teach_obj","h_meet_teach_content","h_meet_teach_phone"]
                self.tabView.reloadData()
            }
        }
    }
    
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect(), style: .plain, space: kLeftSpaceS)
        temp.bounces = false
        temp.separatorStyle = .none
        temp.delegate = self
        temp.dataSource = self
        temp.register(PCMPCell.self, forCellReuseIdentifier: "PCMPCell")
        temp.register(PCMHeaderView.self, forHeaderFooterViewReuseIdentifier: "PCMHeaderView")
        temp.register(PCMIconHeaderView.self, forHeaderFooterViewReuseIdentifier: "PCMIconHeaderView")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.addSubview(temp)
        return temp
    }()
    private var bindArr: [String] = ["h_meet_data","h_meet_time","h_meet_time_duration","h_meet_area","h_meet_reason","h_meet_contact_way"]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        tabView.reloadData()
        _ = tabView.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)
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

extension PersonCustomMeetPreviewCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return bindArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let bind = bindArr[section]
        if bind == "h_meet_contact_way" {
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PCMPCell", for: indexPath) as! PCMPCell
        if indexPath.row == 0 {
            cell.lab.text = "来访人数：\(model.meet_people)人"
        } else if indexPath.row == 1 {
            cell.lab.text = "联系人：" + model.meet_contact_name
        } else if indexPath.row == 2 {
            cell.lab.text = "联系电话：" + model.meet_contact_mobile
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bind = bindArr[section]
        if bind == "h_meet_data" {
            let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PCMHeaderView") as! PCMHeaderView
            vv.bind = "h_meet_data"
            return vv
        }
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PCMIconHeaderView") as! PCMIconHeaderView
        vv.model = model
        vv.bind = bind
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
