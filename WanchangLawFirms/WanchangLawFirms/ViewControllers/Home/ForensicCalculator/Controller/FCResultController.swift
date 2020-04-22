//
//  FCResultController.swift
//  OLegal
//
//  Created by lh on 2018/11/29.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import SafariServices

/// 法务计算结果
class FCResultController: BaseController {
    
    var conditionModel: ForensicCalculatorModel!
    var resultModel: FCResultModel!
    
    private var alimonyArr: [ACModel] = [ACModel]()
    private var workerModel: ACModel = ACModel.init(title1: "误工月收入", title2: "误工时长(天)")
    
    private lazy var topV: FCResultTopView = {
        () -> FCResultTopView in
        let temp = FCResultTopView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: kBarStatusHeight + 220))
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var bottomV: FCResultBottomView = {
        () -> FCResultBottomView in
        let temp = FCResultBottomView.init(frame: CGRect.init(x: 0, y: kDeviceHeight - 80, width: kDeviceWidth, height: 80))
        temp.lab.delegate = self
        return temp
    }()
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: 220 + kBarStatusHeight, width: kDeviceWidth, height: kDeviceHeight - 220 - kBarStatusHeight), style: .grouped, space: kLeftSpaceS)
        temp.separatorStyle = .none
        temp.delegate = self
        temp.dataSource = self
        temp.tableFooterView = self.bottomV
        temp.register(FCResultDetailCell.self, forCellReuseIdentifier: "FCResultDetailCell")
        temp.register(FCResultReadHeaderView.self, forHeaderFooterViewReuseIdentifier: "FCResultReadHeaderView")
        temp.register(FCResultFuneralHeaderView.self, forHeaderFooterViewReuseIdentifier: "FCResultFuneralHeaderView")
        temp.register(FCResultReadWriteHeaderView.self, forHeaderFooterViewReuseIdentifier: "FCResultReadWriteHeaderView")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        temp.register(JHeaderFooterLabView.self, forHeaderFooterViewReuseIdentifier: "JHeaderFooterLabView")
        self.view.addSubview(temp)
        return temp
    }()
    
    private var otherSectionArr: [FCOtherModel] = [FCOtherModel]()
    private var otherModelArr: [[FCOtherModel]] = [[FCOtherModel]]()
    private var readSectionCount = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("h_calculate_result")
        if resultModel.funeralModel.j_val > 0 {
            readSectionCount = 2
        }
        self.topV.model = conditionModel
        self.calcuteTotal()
        self.bottomV.model = resultModel.docModel
        if resultModel.otherModelArr.count > 0 {
            self.otherSectionArr = resultModel.otherModelArr
        } else {
            self.otherSectionArr = resultModel.familyModelArr
        }
        self.tabView.reloadData()
    }

    private func calcuteTotal() {
        var result: Float = 0
        result += resultModel.damageModel.j_number
        for m in otherSectionArr {
            if m.j_selected {
                result += m.j_result
            }
        }
        if resultModel.funeralModel.j_val > 0 {
            result += resultModel.funeralModel.j_number
        }
        let resultStr = String.init(format: "%.2f", result)
        self.topV.calcuteResult = resultStr
    }
}

extension FCResultController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return readSectionCount + otherSectionArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section > readSectionCount - 1 && otherSectionArr.count > 0 {
            let model = otherSectionArr[section - readSectionCount]
            if model.otherDataArr.count > 0 {
                return model.otherDataArr.count + 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = otherSectionArr[indexPath.section - readSectionCount]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FCResultDetailCell", for: indexPath) as! FCResultDetailCell
        if indexPath.row == model.otherDataArr.count {
            let str1 = "总计："
            let str2 = String.init(format: "%.0f", model.j_result)
            let str3 = " 元"
            let totalStr = str1 + str2 + str3
            let mulStr = NSMutableAttributedString.init(string: totalStr)
            mulStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kOrangeDarkColor, range: NSRange.init(location: str1.count, length: str2.count))
            cell.lab.attributedText = mulStr
        } else {
            cell.model = model.otherDataArr[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section < readSectionCount {
            if section == 0 {
                let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FCResultReadHeaderView") as! FCResultReadHeaderView
                vv.model = resultModel.damageModel
                return vv
            }
            let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FCResultFuneralHeaderView") as! FCResultFuneralHeaderView
            vv.delegate = self
            vv.model = resultModel.funeralModel
            return vv
        }
        let model = otherSectionArr[section - readSectionCount]
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FCResultReadWriteHeaderView") as! FCResultReadWriteHeaderView
        if model.otherDataArr.count > 0 {
            vv.line.isHidden = true
        } else {
            vv.line.isHidden = false
        }
        vv.delegate = self
        vv.model = model
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section < readSectionCount {
            if conditionModel.bind == "h_worker_compensation" {
                if section == readSectionCount - 1 {
                    let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "JHeaderFooterLabView") as! JHeaderFooterLabView
                    if resultModel.otherModelArr.count > 0 {
                        vv.lab.text = "生活护理费"
                    } else {
                        vv.lab.text = "亲属抚恤金"
                    }
                    return vv
                }
            }
        }
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < readSectionCount {
            if conditionModel.bind == "h_worker_compensation" {
                if section == readSectionCount - 1 {
                    return 40
                }
            }
            return kCellSpaceL
        }
        return 0.01
    }
}

extension FCResultController: FCResultReadWriteHeaderViewDelegate {
    func fcResultReadWriteHeaderViewSelect() {
        self.calcuteTotal()
    }
    
    func fcResultReadWriteHeaderViewTapClick(model: FCOtherModel) {
        if conditionModel.bind == "h_traffic_compensation" {
            if model.id == "1" {
                let vc = WorkerCalculateController()
                vc.model = workerModel
                weak var weakSelf = self
                vc.block = { (mo) in
                    model.j_text = "\(mo.calcuteResult)"
                    weakSelf?.calcuteTotal()
                    weakSelf?.tabView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                return
            } else if model.id == "2" {
                let vc = AlimonyCalculateController()
                vc.dataArr = alimonyArr
                vc.conditionModel = conditionModel
                weak var weakSelf = self
                vc.block = { (m, arr) in
                    for mo in m.otherModelArr {
                        if mo.id == model.id {
                            model.data = mo.data
                            model.j_selected = true
                            break
                        }
                    }
                    weakSelf?.alimonyArr = arr
                    weakSelf?.calcuteTotal()
                    weakSelf?.tabView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
        }
        if model.enter_month {
            OLAlertManager.share.tfShow(titleBind: model.title, placeholderBind: "p_enter_month_count", text: "")
        } else {
            OLAlertManager.share.tfShow(titleBind: model.title, placeholderBind: "p_enter_money_amount", text: model.j_text)
        }
        OLAlertManager.share.tfView?.delegate = self
    }
    
}

extension FCResultController: FCResultFuneralHeaderViewDelegate {
    func fcResultFuneralHeaderViewTapClick(model: FCFuneralModel) {
        OLAlertManager.share.tfShow(titleBind: "p_enter_month_count", placeholderBind: "p_enter_month_count", text: "")
        OLAlertManager.share.tfView?.delegate = self
    }
}

extension FCResultController: OLAlertTFViewDelegate {
    func olalertTFViewOKClick(titleBind: String, text: String) {
        if titleBind == "p_enter_month_count" {
            guard let count = Int(text) else {
                return
            }
            resultModel.funeralModel.count = count
            self.calcuteTotal()
            self.tabView.reloadData()
            return
        }
        for m in otherSectionArr {
            if m.title == titleBind {
                if m.enter_month {
                    m.count = Int(text)
                } else {
                    m.j_text = text
                }
                self.calcuteTotal()
                self.tabView.reloadData()
                break
            }
        }
    }
}

extension FCResultController: LLabelDelegate {
    func llabelClick(text: String) {
//        let vc = FCDocumentController()
//        vc.bind = self.conditionModel.bind
//        vc.model = self.resultModel.docModel
//        self.navigationController?.pushViewController(vc, animated: true)
        var type = "traffic"
        if self.conditionModel.bind == "h_worker_compensation" {
            type = "work"
        }
        let urlStr = BASE_URL + api_counter_info + "?id=" + self.resultModel.docModel.id + "&type=" + type
        let vc = JSafariController.init(urlStr: urlStr, title: self.resultModel.docModel.title)
        self.present(vc, animated: true, completion: nil)
    }
}
