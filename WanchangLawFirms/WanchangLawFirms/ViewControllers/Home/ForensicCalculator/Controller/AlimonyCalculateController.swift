//
//  AlimonyCalculateController.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/15.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 抚养计算
class AlimonyCalculateController: BaseController {
    
    var conditionModel: ForensicCalculatorModel!
    var dataArr: [ACModel] = [ACModel]()
    
    var block = { (result: FCResultModel, arr: [ACModel]) in
        
    }
    
    private let titleStr1: String = "被抚养人年龄"
    private let titleStr2: String = "承担抚养义务的人数"
    
    private lazy var tabView: JHPTabView = {
        () -> JHPTabView in
        let temp = JHPTabView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - 50), style: .grouped)
        temp.delegate = self
        temp.dataSource = self
        temp.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        temp.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 0.01))
        temp.register(ACCell.self, forCellReuseIdentifier: "ACCell")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var calcuteBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontM, UIColor.white, UIControl.ContentHorizontalAlignment.center, self, #selector(calcuteClick(sender:)))
        temp.frame = CGRect.init(x: 0, y: kDeviceHeight - 50, width: kDeviceWidth, height: 50)
        temp.setTitle(L$("calculate"), for: .normal)
        temp.backgroundColor = kOrangeDarkColor
        self.view.addSubview(temp)
        return temp
    }()
    private var selectedArr: [ACModel] = [ACModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L$("h_alimony_calcute")
        if dataArr.count == 0 {
            let model = ACModel.init(title1: titleStr1, title2: titleStr2)
            dataArr.append(model)
        }
        self.tabView.reloadData()
        self.calcuteBtn.isHidden = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "calculate_add"), style: .done, target: self, action: #selector(addClick))
    }
    
    @objc private func addClick() {
        self.view.endEditing(true)
        if self.dataArr.count > 30 {
            return
        }
        let model = ACModel.init(title1: titleStr1, title2: titleStr2)
        self.dataArr.append(model)
        self.tabView.reloadData()
    }
    
    @objc private func calcuteClick(sender: UIButton) {
        self.selectedArr.removeAll()
        let tempArr: NSMutableArray = NSMutableArray()
        for m in dataArr {
            if m.age > 0 && m.number > 0 {
                let prams: NSDictionary = ["age":m.age,"number":m.number]
                tempArr.add(prams)
                self.selectedArr.append(m)
            }
        }
        if tempArr.count == 0 {
            PromptTool.promptText("请补全信息", 1)
            return
        }
        guard let area = Int(conditionModel.areaModel!.id) else {
            return
        }
        guard let level = Int(conditionModel.levelModel!.code) else {
            return
        }
        guard let resident_type = Int(conditionModel.hokouModel!.code) else {
            return
        }
        guard let age = Int(conditionModel.text!) else {
            return
        }
        guard let dependents = tempArr.mj_JSONString() else {
            return
        }
        let prams: NSDictionary = ["area":area,"level":level,"resident_type":resident_type,"age":age,"dependents":dependents]
        HomeManager.share.counterTraffic(prams: prams) { (m) in
            if m != nil {
                self.block(m!, self.selectedArr)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

}

extension AlimonyCalculateController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.section]
        let cell = tabView.dequeueReusableCell(withIdentifier: "ACCell", for: indexPath) as! ACCell
        cell.tf.delegate = self
        if indexPath.row == 0 {
            cell.titleLab.text = model.title1
            cell.tf.text = model.text1
            cell.tf.tag = 1000 + indexPath.section
        } else if indexPath.row == 1 {
            cell.titleLab.text = model.title2
            cell.tf.text = model.text2
            cell.tf.tag = 2000 + indexPath.section
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kCellSpaceL
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

extension AlimonyCalculateController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        if textField.tag < 2000 {
            if textField.text != nil && textField.text!.count >= 3 {
                return false
            }
        }
        if textField.text != nil && textField.text!.count > 20 {
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var tag = 0
        if textField.tag >= 2000 {
            tag = textField.tag - 2000
        } else {
            tag = textField.tag - 1000
        }
        if tag > 0 {
            self.tabView.setContentOffset(CGPoint.init(x: 0, y: CGFloat(tag) * (kCellHeight * 2 + kCellSpaceL)), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var tag = textField.tag
        if tag >= 2000 {
            let model = dataArr[tag - 2000]
            model.text2 = textField.text ?? ""
            tag = textField.tag - 2000
        } else {
            let model = dataArr[tag - 1000]
            model.text1 = textField.text ?? ""
            tag = textField.tag - 1000
        }
        if tag > 0 {
            self.tabView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }
    }
}
