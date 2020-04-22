//
//  PersonCustomMeetCell.swift
//  OLegal
//
//  Created by lh on 2018/11/27.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 会面咨询
class PersonCustomMeetCell: BaseCell {
    
    var isTeachMeet: Bool = false {
        didSet {
            if isTeachMeet {
                titleBind = ["h_meet_time","h_meet_time_duration","h_meet_teach_area","h_meet_teach_obj","h_meet_teach_content","h_meet_teach_phone"]
                self.tabView.reloadData()
            }
        }
    }
    
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect(), style: .plain, space: 0)
        temp.bounces = false
        temp.separatorStyle = .none
        temp.delegate = self
        temp.dataSource = self
        temp.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        temp.register(PCMDateCell.self, forCellReuseIdentifier: "PCMDateCell")
        temp.register(PCMAreaCell.self, forCellReuseIdentifier: "PCMAreaCell")
        temp.register(PCMTextCell.self, forCellReuseIdentifier: "PCMTextCell")
        temp.register(PCMContactCell.self, forCellReuseIdentifier: "PCMContactCell")
        temp.register(PCMHeaderView.self, forHeaderFooterViewReuseIdentifier: "PCMHeaderView")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.addSubview(temp)
        return temp
    }()
    
    private var titleBind: [String] = ["h_meet_time","h_meet_time_duration","h_meet_area","h_meet_reason","h_meet_contact_way"]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        tabView.reloadData()
        _ = self.tabView.sd_layout()?.leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.bottomEqualToView(self)
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

extension PersonCustomMeetCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleBind.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let bind = titleBind[section]
        if bind == "h_meet_contact_way" {
            return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bind = titleBind[indexPath.section]
        if bind == "h_meet_time" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PCMDateCell", for: indexPath) as! PCMDateCell
            cell.calendarV.isTeachMeet = isTeachMeet
            return cell
        } else if bind == "h_meet_contact_way" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PCMContactCell", for: indexPath) as! PCMContactCell
            cell.tf.delegate = self
            if indexPath.row == 0 {
                cell.titleBtn.setTitle(L$("h_contact_person_count"), for: .normal)
                cell.tf.placeholder = L$("p_enter_people_count")
                cell.tf.keyboardType = .numberPad
            } else if indexPath.row == 1 {
                cell.titleBtn.setTitle(L$("h_contact_person"), for: .normal)
                cell.tf.placeholder = L$("p_enter_name")
                cell.tf.keyboardType = .default
            } else {
                cell.titleBtn.setTitle(L$("h_contact_mobile"), for: .normal)
                cell.tf.placeholder = L$("p_enter_contact_mobile")
                cell.tf.keyboardType = .numberPad
            }
            return cell
        } else if bind == "h_meet_time_duration" || bind == "h_meet_area" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PCMAreaCell", for: indexPath) as! PCMAreaCell
            cell.bind = bind
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "PCMTextCell", for: indexPath) as! PCMTextCell
        cell.tf.delegate = self
        cell.bind = bind
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.endEditing(true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let bind = titleBind[indexPath.section]
        if bind == "h_meet_time" {
            return 260
        } else if bind == "h_meet_contact_way" {
            return 80
        }
        return kCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bind = titleBind[section]
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PCMHeaderView") as! PCMHeaderView
        vv.bind = bind
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

extension PersonCustomMeetCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let str = textField.text else {
            return true
        }
        if string == "" {
            return true
        }
        if str.count > 50 {
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.placeholder == L$("p_enter_name") {
            JMeetManager.share.model.meet_contact_name = textField.text ?? ""
        } else if textField.placeholder == L$("p_enter_contact_mobile") {
            JMeetManager.share.model.meet_contact_mobile = textField.text ?? ""
        } else if textField.placeholder == L$("p_enter_people_count") {
            JMeetManager.share.model.meet_people = textField.text ?? ""
        } else if textField.placeholder == L$("p_enter_meet_reason") {
            JMeetManager.share.model.reason = textField.text ?? ""
        } else if textField.placeholder == L$("p_enter_teach_phone") {
            JMeetManager.share.model.train_contact_mobile = textField.text ?? ""
        } else if textField.placeholder == L$("p_enter_teach_address") {
            JMeetManager.share.model.address = textField.text ?? ""
        } else if textField.placeholder == L$("p_enter_teach_obj") {
            JMeetManager.share.model.train_people = textField.text ?? ""
        } else if textField.placeholder == L$("p_enter_teach_content") {
            JMeetManager.share.model.train_content = textField.text ?? ""
        }
    }
}
