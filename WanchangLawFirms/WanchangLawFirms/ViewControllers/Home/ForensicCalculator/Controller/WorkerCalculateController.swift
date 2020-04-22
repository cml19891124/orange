//
//  WorkerCalculateController.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/16.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 工伤计算
class WorkerCalculateController: BaseController {

    var model: ACModel!
    var block = { (mo: ACModel) in
        
    }
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "误工费"
        self.tabView.reloadData()
        self.calcuteBtn.isHidden = false
    }
    
    @objc private func calcuteClick(sender: UIButton) {
        self.block(model)
        self.navigationController?.popViewController(animated: true)
    }
}

extension WorkerCalculateController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabView.dequeueReusableCell(withIdentifier: "ACCell", for: indexPath) as! ACCell
        cell.tf.delegate = self
        if indexPath.row == 0 {
            cell.titleLab.text = model.title1
            cell.tf.text = model.text1
            cell.tf.tag = 1
        } else if indexPath.row == 1 {
            cell.titleLab.text = model.title2
            cell.tf.text = model.text2
            cell.tf.tag = 2
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

extension WorkerCalculateController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            model.text1 = textField.text ?? ""
        } else {
            model.text2 = textField.text ?? ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        if textField.text != nil && textField.text!.count > 20 {
            return false
        }
        return true
    }
}
