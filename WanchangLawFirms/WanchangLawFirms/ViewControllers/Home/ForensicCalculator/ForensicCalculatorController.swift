//
//  ForensicCalculatorController.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 法务计算器
class ForensicCalculatorController: BaseController {
    
    private let topH: CGFloat = 100
    private lazy var topV: ForensicCalculatorChooseView = {
        () -> ForensicCalculatorChooseView in
        let temp = ForensicCalculatorChooseView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: topH))
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: topH + kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - topH), style: .plain, space: 0)
        temp.bounces = false
        temp.separatorStyle = .none
        temp.backgroundColor = kCellColor
        temp.delegate = self
        temp.dataSource = self
        temp.register(ForensicCalculatorTitleCell.self, forCellReuseIdentifier: "ForensicCalculatorTitleCell")
        temp.register(ForensicCalculatorTextCell.self, forCellReuseIdentifier: "ForensicCalculatorTextCell")
        temp.register(ForensicCalculatorExtenCell.self, forCellReuseIdentifier: "ForensicCalculatorExtenCell")
        temp.register(ForensicCalculatorOKCell.self, forCellReuseIdentifier: "ForensicCalculatorOKCell")
        temp.register(ForensicCalculatorResultCell.self, forCellReuseIdentifier: "ForensicCalculatorResultCell")
        temp.register(ForensicCalculatorDocumentCell.self, forCellReuseIdentifier: "ForensicCalculatorDocumentCell")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.view.addSubview(temp)
        return temp
    }()
    
    private var dataArr: [[String]] = [[String]]()
    private var current_bind: String = "h_worker_compensation"
    
    private var workerModel: ForensicCalculatorModel = ForensicCalculatorModel.init(bind: "h_worker_compensation")
    private var trafficModel: ForensicCalculatorModel = ForensicCalculatorModel.init(bind: "h_traffic_compensation")
    private var lawyerModel: ForensicCalculatorModel = ForensicCalculatorModel.init(bind: "h_lawyer_fee_calculation")
    private var litiModel: ForensicCalculatorModel = ForensicCalculatorModel.init(bind: "h_litigation_cost_calculation")
    
    private var lawyerResultModel: FCResultModel = FCResultModel()
    private var lawyerResultArr: [String] = [String]()
    private var litiResultModel: FCResultModel = FCResultModel()
    private var litiResultArr: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("h_forensic_calculator")
        JKeyboardNotiManager.share.delegate = self
        self.getDataSource()
    }
    
    private func getDataSource() {
        self.topV.delegate = self
        self.forensicCalculatorChooseViewClick(bind: "h_worker_compensation")
    }
    
}

extension ForensicCalculatorController: ForensicCalculatorChooseViewDelegate {
    func forensicCalculatorChooseViewClick(bind: String) {
        self.view.endEditing(true)
        current_bind = bind
        dataArr.removeAll()
        var temp: [String] = [String]()
        if bind == "h_worker_compensation" {
            temp = ["h_calculate_condition","h_select_area","h_disability_grade","h_salary_yuan_month","ok"]
        } else if bind == "h_traffic_compensation" {
            temp = ["h_calculate_condition","h_select_area","h_choose_hukou","h_disability_grade","h_age","ok"]
        } else if bind == "h_lawyer_fee_calculation" {
            temp = ["h_calculate_condition","h_select_area","h_case_type","h_litigation_object","ok"]
        } else if bind == "h_litigation_cost_calculation" {
            temp = ["h_calculate_condition","h_case_type","h_property_involved","h_litigation_object","ok"]
        }
        dataArr.append(temp)
        if bind == "h_lawyer_fee_calculation" {
            if lawyerResultArr.count > 0 {
                dataArr.append(lawyerResultArr)
            }
        } else if bind == "h_litigation_cost_calculation" {
            if litiResultArr.count > 0 {
                dataArr.append(litiResultArr)
            }
        }
        self.tabView.reloadData()
    }
}

extension ForensicCalculatorController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = dataArr[section]
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arr = dataArr[indexPath.section]
        let bind = arr[indexPath.row]
        if bind == "h_calculate_condition" || bind == "h_calculate_result" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForensicCalculatorTitleCell", for: indexPath) as! ForensicCalculatorTitleCell
            cell.bind = bind
            return cell
        } else if bind == "ok" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForensicCalculatorOKCell", for: indexPath) as! ForensicCalculatorOKCell
            cell.calView.delegate = self
            return cell
        } else if bind == "h_select_area" || bind == "h_disability_grade" || bind == "h_choose_hukou" || bind == "h_case_type" || bind == "h_property_involved" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForensicCalculatorExtenCell", for: indexPath) as! ForensicCalculatorExtenCell
            cell.bind = bind
            cell.delegate = self
            if bind == "h_select_area" {
                if current_bind == "h_worker_compensation" {
                    cell.tf.text = workerModel.areaModel?.name
                } else if current_bind == "h_traffic_compensation" {
                    cell.tf.text = trafficModel.areaModel?.name
                } else if current_bind == "h_lawyer_fee_calculation" {
                    cell.tf.text = lawyerModel.areaModel?.name
                }
            } else if bind == "h_disability_grade" {
                if current_bind == "h_worker_compensation" {
                    cell.tf.text = workerModel.levelModel?.val
                } else if current_bind == "h_traffic_compensation" {
                    cell.tf.text = trafficModel.levelModel?.val
                }
            } else if bind == "h_choose_hukou" {
                cell.tf.text = trafficModel.hokouModel?.val
            } else if bind == "h_case_type" {
                if current_bind == "h_lawyer_fee_calculation" {
                    cell.tf.text = lawyerModel.typeModel?.val
                } else if current_bind == "h_litigation_cost_calculation" {
                    cell.tf.text = litiModel.typeModel?.val
                }
            } else if bind == "h_property_involved" {
                cell.tf.text = litiModel.propertyModel?.val
            }
            return cell
        } else if bind == "result" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForensicCalculatorResultCell", for: indexPath) as! ForensicCalculatorResultCell
            if current_bind == "h_lawyer_fee_calculation" {
                if lawyerResultModel.criminalModelArr.count > 0 {
                    let resultMulStr = NSMutableAttributedString.init(string: "")
                    for i in 0..<lawyerResultModel.criminalModelArr.count {
                        let m = lawyerResultModel.criminalModelArr[i]
                        let str1 = m.title + "："
                        let str2 = m.val
                        let str3 = " 元"
                        var str4 = ""
                        if i < lawyerResultModel.criminalModelArr.count - 1 {
                            str4 = "\n\n"
                        }
                        let totalStr = str1 + str2 + str3 + str4
                        let mulStr = NSMutableAttributedString.init(string: totalStr)
                        mulStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kOrangeDarkColor, range: NSRange.init(location: str1.count, length: str2.count))
                        resultMulStr.append(mulStr)
                    }
                    cell.lab.attributedText = resultMulStr
                } else {
                    let str1 = lawyerResultModel.lawyerFeeModel.title + "："
                    let str2 = lawyerResultModel.lawyerFeeModel.j_price
                    let str3 = " 元"
                    let totalStr = str1 + str2 + str3
                    let mulStr = NSMutableAttributedString.init(string: totalStr)
                    mulStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kOrangeDarkColor, range: NSRange.init(location: str1.count, length: str2.count))
                    cell.lab.attributedText = mulStr
                }
            } else if current_bind == "h_litigation_cost_calculation" {
                let acceptStr1 = litiResultModel.acceptFeeModel.title + "："
                let acceptStr2 = litiResultModel.acceptFeeModel.j_price
                let acceptStr3 = " 元\n\n"
                let acceptTotalStr = acceptStr1 + acceptStr2 + acceptStr3
                let applyStr1 = litiResultModel.applyFeeModel.title + "："
                let applyStr2 = litiResultModel.applyFeeModel.j_price
                let applyStr3 = " 元\n\n"
                let applyTotalStr = applyStr1 + applyStr2 + applyStr3
                let keepStr1 = litiResultModel.keepFeeModel.title + "："
                let keepStr2 = litiResultModel.keepFeeModel.j_price
                let keepStr3 = " 元"
                let keepTotalStr = keepStr1 + keepStr2 + keepStr3
                let totalStr = acceptTotalStr + applyTotalStr + keepTotalStr
                let mulStr = NSMutableAttributedString.init(string: totalStr)
                mulStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kOrangeDarkColor, range: NSRange.init(location: acceptStr1.count, length: acceptStr2.count))
                mulStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kOrangeDarkColor, range: NSRange.init(location: acceptTotalStr.count + applyStr1.count, length: applyStr2.count))
                mulStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kOrangeDarkColor, range: NSRange.init(location: acceptTotalStr.count + applyTotalStr.count + keepStr1.count, length: keepStr2.count))
                cell.lab.attributedText = mulStr
            }
            return cell
        } else if bind == "document" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForensicCalculatorDocumentCell", for: indexPath) as! ForensicCalculatorDocumentCell
            cell.bind = current_bind
            if current_bind == "h_lawyer_fee_calculation" {
                cell.model = lawyerResultModel.docModel
            } else if current_bind == "h_litigation_cost_calculation" {
                cell.model = litiResultModel.docModel
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForensicCalculatorTextCell", for: indexPath) as! ForensicCalculatorTextCell
        cell.tf.delegate = self
        cell.bind = bind
        if current_bind == "h_worker_compensation" {
            cell.tf.text = workerModel.text
        } else if current_bind == "h_traffic_compensation" {
            cell.tf.text = trafficModel.text
        } else if current_bind == "h_lawyer_fee_calculation" {
            cell.tf.text = lawyerModel.text
        } else if current_bind == "h_litigation_cost_calculation" {
            cell.tf.text = litiModel.text
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                if current_bind == "h_lawyer_fee_calculation" {
                    if lawyerResultModel.criminalModelArr.count > 0 {
                        let count = lawyerResultModel.criminalModelArr.count - 1
                        return CGFloat(60 + count * 30)
                    }
                    return 60
                } else if current_bind == "h_litigation_cost_calculation" {
                    return 120
                }
            } else if indexPath.row == 2 {
                return 80
            }
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kCellSpaceL
    }
}

extension ForensicCalculatorController: ForensicCalculatorExtenCellDelegate {
    func forensicCalculatorExtenCellClick(bind: String) {
        self.view.endEditing(true)
        if bind == "h_select_area" || bind == "h_disability_grade" || bind == "h_choose_hukou" || bind == "h_case_type" || bind == "h_property_involved" {
            var temp = bind
            if bind == "h_case_type" {
                if current_bind == "h_lawyer_fee_calculation" {
                    temp = "h_choose_lawyer_type"
                } else if current_bind == "h_litigation_cost_calculation" {
                    temp = "h_choose_liti_type"
                }
            }
            OLAlertManager.share.calculateShow(bind: temp)
            OLAlertManager.share.calcuteView?.delegate = self
        }
    }
}

extension ForensicCalculatorController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        guard let str = textField.text else {
            return true
        }
        if str.count > 9 {
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if current_bind == "h_worker_compensation" {
            workerModel.text = textField.text
        } else if current_bind == "h_traffic_compensation" {
            trafficModel.text = textField.text
        } else if current_bind == "h_lawyer_fee_calculation" {
            lawyerModel.text = textField.text
        } else if current_bind == "h_litigation_cost_calculation" {
            litiModel.text = textField.text
        }
    }
}

extension ForensicCalculatorController: JKeyboardNotiManagerDelegate {
    func jkeyboardHeightChange(kH: CGFloat, duration: Double) {
        let h1 = kDeviceHeight - topH - kNavHeight
        let h2 = h1 - kH
        let h3 = CGFloat(self.dataArr[0].count) * 70
        let offsetY = h3 - h2 + kCellSpaceL
        UIView.animate(withDuration: duration) {
            self.tabView.setContentOffset(CGPoint.init(x: 0, y: offsetY), animated: false)
        }
    }
    
    func jkeyboardWillHide(kH: CGFloat, duration: Double) {
        UIView.animate(withDuration: duration) {
            self.tabView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
        }
    }
}

extension ForensicCalculatorController: JCalculateAlertViewDelegate {
    func jcalculateAlertViewClick(bind: String, mo: JCalculateModel) {
        if bind == "h_select_area" {
            if current_bind == "h_worker_compensation" {
                workerModel.areaModel = mo
            } else if current_bind == "h_traffic_compensation" {
                trafficModel.areaModel = mo
            } else if current_bind == "h_lawyer_fee_calculation" {
                lawyerModel.areaModel = mo
            }
        } else if bind == "h_disability_grade" {
            if current_bind == "h_worker_compensation" {
                workerModel.levelModel = mo
            } else if current_bind == "h_traffic_compensation" {
                trafficModel.levelModel = mo
            }
        } else if bind == "h_choose_hukou" {
            if current_bind == "h_traffic_compensation" {
                trafficModel.hokouModel = mo
            }
        } else if bind == "h_property_involved" {
            if current_bind == "h_litigation_cost_calculation" {
                litiModel.propertyModel = mo
            }
        } else if bind == "h_choose_lawyer_type" {
            if current_bind == "h_lawyer_fee_calculation" {
                lawyerModel.typeModel = mo
            }
        } else if bind == "h_choose_liti_type" {
            if current_bind == "h_litigation_cost_calculation" {
                litiModel.typeModel = mo
            }
        }
        self.tabView.reloadData()
    }
}

extension ForensicCalculatorController: JCalculateResetViewDelegate {
    func jcalculateResetViewBtnsClick(sender: UIButton, bind: String) {
        self.view.endEditing(true)
        if bind == "calculate" {
            self.calcute(sender: sender)
        } else if bind == "reset" {
            if current_bind == "h_worker_compensation" {
                workerModel.clearAll()
            } else if current_bind == "h_traffic_compensation" {
                trafficModel.clearAll()
            } else if current_bind == "h_lawyer_fee_calculation" {
                lawyerModel.clearAll()
                lawyerResultArr.removeAll()
            } else if current_bind == "h_litigation_cost_calculation" {
                litiModel.clearAll()
                litiResultArr.removeAll()
            }
            self.forensicCalculatorChooseViewClick(bind: current_bind)
        }
    }
    
    private func calcute(sender: UIButton) {
        if current_bind == "h_worker_compensation" {
            if workerModel.areaModel == nil {
                PromptTool.promptText(L$("p_select_area_please"), 1)
                return
            }
            if workerModel.levelModel == nil {
                PromptTool.promptText(L$("p_select_disable_level_please"), 1)
                return
            }
            if workerModel.text?.haveTextStr() != true {
                PromptTool.promptText(L$("p_enter_salary_please"), 1)
                return
            }
            self.work_calcute(sender: sender)
        } else if current_bind == "h_traffic_compensation" {
            if trafficModel.areaModel == nil {
                PromptTool.promptText(L$("p_select_area_please"), 1)
                return
            }
            if trafficModel.hokouModel == nil {
                PromptTool.promptText(L$("p_select_hukou_please"), 1)
                return
            }
            if trafficModel.levelModel == nil {
                PromptTool.promptText(L$("p_select_disable_level_please"), 1)
                return
            }
            if trafficModel.text?.haveTextStr() != true {
                PromptTool.promptText(L$("p_enter_age"), 1)
                return
            }
            self.traffic_calcute(sender: sender)
        } else if current_bind == "h_lawyer_fee_calculation" {
            if lawyerModel.areaModel == nil {
                PromptTool.promptText(L$("p_select_area_please"), 1)
                return
            }
            if lawyerModel.typeModel == nil {
                PromptTool.promptText(L$("p_select_case_type"), 1)
                return
            }
//            if lawyerModel.text?.haveTextStr() != true {
//                PromptTool.promptText(L$("p_enter_object"), 1)
//                return
//            }
            self.lawyer_calcute(sender: sender)
        } else if current_bind == "h_litigation_cost_calculation" {
            if litiModel.typeModel == nil {
                PromptTool.promptText(L$("p_select_case_type"), 1)
                return
            }
            if litiModel.propertyModel == nil {
                PromptTool.promptText(L$("p_select_property"), 1)
                return
            }
//            if litiModel.text?.haveTextStr() != true {
//                PromptTool.promptText(L$("p_enter_object"), 1)
//                return
//            }
            self.liti_calcute(sender: sender)
        }
    }
    
    private func work_calcute(sender: UIButton) {
        guard let area = Int(workerModel.areaModel!.id) else {
            return
        }
        guard let level = Int(workerModel.levelModel!.code) else {
            return
        }
        guard let number = Int(workerModel.text!) else {
            return
        }
        let prams: NSDictionary = ["area":area,"level":level,"number":number]
        HomeManager.share.counterWork(prams: prams) { (m) in
            if m != nil {
                let vc = FCResultController()
                vc.currentNavigationBarAlpha = 0
                vc.conditionModel = self.workerModel
                vc.resultModel = m
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    private func traffic_calcute(sender: UIButton) {
        guard let area = Int(trafficModel.areaModel!.id) else {
            return
        }
        guard let level = Int(trafficModel.levelModel!.code) else {
            return
        }
        guard let resident_type = Int(trafficModel.hokouModel!.code) else {
            return
        }
        guard let age = Int(trafficModel.text!) else {
            return
        }
        let prams: NSDictionary = ["area":area,"level":level,"resident_type":resident_type,"age":age]
        HomeManager.share.counterTraffic(prams: prams) { (m) in
            if m != nil {
                let vc = FCResultController()
                vc.currentNavigationBarAlpha = 0
                vc.conditionModel = self.trafficModel
                vc.resultModel = m
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    private func lawyer_calcute(sender: UIButton) {
        guard let area = Int(lawyerModel.areaModel!.id) else {
            return
        }
        guard let case_type = Int(lawyerModel.typeModel!.code) else {
            return
        }
        var number: Int = 0
        if lawyerModel.text != nil {
            let s1 = Int(lawyerModel.text!)
            if s1 != nil {
                number = s1!
            }
        }
        let prams: NSDictionary = ["area":area,"case_type":case_type,"number":number]
        HomeManager.share.counterLawyer(prams: prams) { (m) in
            if m != nil {
                self.lawyerResultModel = m!
                self.lawyerResultArr = ["h_calculate_result","result","document"]
                self.forensicCalculatorChooseViewClick(bind: "h_lawyer_fee_calculation")
            }
        }
    }
    
    private func liti_calcute(sender: UIButton) {
        guard let case_code = Int(litiModel.typeModel!.code) else {
            return
        }
        guard let property_type = Int(litiModel.propertyModel!.code) else {
            return
        }
        var number: Int = 0
        if litiModel.text != nil {
            let s1 = Int(litiModel.text!)
            if s1 != nil {
                number = s1!
            }
        }
        let prams: NSDictionary = ["case_code":case_code,"property_type":property_type,"number":number]
        HomeManager.share.counterSue(prams: prams) { (m) in
            if m != nil {
                self.litiResultModel = m!
                self.litiResultArr = ["h_calculate_result","result","document"]
                self.forensicCalculatorChooseViewClick(bind: "h_litigation_cost_calculation")
            }
        }
    }
}
