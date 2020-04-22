//
//  JCalculateAlertView.swift
//  OLegal
//
//  Created by lh on 2018/11/28.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol JCalculateAlertViewDelegate: NSObjectProtocol {
    func jcalculateAlertViewClick(bind: String, mo: JCalculateModel)
}

class JCalculateAlertView: UIView {
    
    var bind: String = ""
    weak var delegate: JCalculateAlertViewDelegate?
    
    private lazy var tabView: UITableView = {
        () -> UITableView in
        var h = CGFloat(dataArr.count) * kCellHeight + 50
        if h > kDeviceWidth {
            h = kDeviceWidth
        }
        let temp = UITableView.init(frame: CGRect.init(x: kLeftSpaceL, y: (kDeviceHeight - h) / 2, width: kDeviceWidth - kLeftSpaceL * 2, height: h), style: .plain, space: kLeftSpaceS)
        temp.layer.cornerRadius = kBtnCornerR * 2
        temp.delegate = self
        temp.dataSource = self
        temp.bounces = false
        temp.register(JLabCell.self, forCellReuseIdentifier: "JLabCell")
        temp.register(JHeaderFooterLabView.self, forHeaderFooterViewReuseIdentifier: "JHeaderFooterLabView")
        self.addSubview(temp)
        return temp
    }()
    private lazy var dataArr: [JCalculateModel] = [JCalculateModel]()
    
    convenience init(bind: String) {
        self.init()
        self.bind = bind
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        self.layer.opacity = 0
        UIApplication.shared.keyWindow?.addSubview(self)
        self.getDataSource()
    }
    
    private func getDataSource() {
//        if bind == "h_select_area" {
//            dataArr = ["北京","上海","天津","重庆","浙江","广东","江苏","山东","福建","安徽","四川","湖北","河北","云南","黑龙江","吉林","辽宁","海南","湖南","河南","贵州","江西","广西","陕西","山西","青海","宁夏","甘肃","西藏","内蒙古","新疆"]
//        } else if bind == "h_disability_grade" {
//            dataArr = ["十级伤残","九级伤残","八级伤残","七级伤残","六级伤残","五级伤残","四级伤残","三级伤残","二级伤残","一级伤残","死亡"]
//        } else if bind == "h_choose_hukou" {
//            dataArr = ["农村","城镇"]
//        } else if bind == "h_choose_lawyer_type" {
//            dataArr = ["民事案件","刑事案件","行政案件"]
//        } else if bind == "h_choose_liti_type" {
//            dataArr = ["财产案件","离婚案件","侵害人身权案件","侵害专利权","著作权","商标权案件","治安行政案件","专利、商标行政案件","劳动争议案件","其它非财产案件"]
//        } else if bind == "h_property_involved" {
//            dataArr = ["是","否"]
//        }
        OLAlertManager.share.getCalModelArr(bind: bind) { (arr) in
            self.dataArr = arr
            self.tabView.reloadData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        OLAlertManager.share.calcuteHide()
    }

}

extension JCalculateAlertView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        let cell = tabView.dequeueReusableCell(withIdentifier: "JLabCell", for: indexPath) as! JLabCell
        if model.val.haveTextStr() == true {
            cell.lab.text = model.val
        } else {
            cell.lab.text = model.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataArr[indexPath.row]
        self.delegate?.jcalculateAlertViewClick(bind: bind, mo: model)
        OLAlertManager.share.calcuteHide()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "JHeaderFooterLabView") as! JHeaderFooterLabView
        vv.backgroundColor = kBaseColor
        vv.lab.text = L$(bind)
        vv.lab.textAlignment = .center
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
