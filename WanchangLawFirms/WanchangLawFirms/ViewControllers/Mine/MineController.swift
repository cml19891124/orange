//
//  MineController.swift
//  OLegal
//
//  Created by lh on 2018/11/19.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 我的
class MineController: BaseController {
    
    private var topH: CGFloat = {
        () -> CGFloat in
        let tempH = kDeviceHeight
        let temp = tempH - goldBigHeight(tempH)
        return temp
    }()
    
    private lazy var headV: MineHeadView = {
        () -> MineHeadView in
        let temp = MineHeadView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: topH))
        return temp
    }()
    
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: kDeviceHeight - kTabBarHeight), style: .grouped, space: kLeftSpaceS)
        temp.tableHeaderView = self.headV
        temp.delegate = self
        temp.dataSource = self
        temp.bounces = false
        temp.register(MineCell.self, forCellReuseIdentifier: "MineCell")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.view.addSubview(temp)
        return temp
    }()
    
    private var dataArr: [String] = [String]()
    private lazy var titleBind: String = {
        () -> String in
        if UserInfo.share.is_business {
            return "business"
        }
        return "mine"
    }()
    private lazy var loginView: JTouristLoginView = {
        () -> JTouristLoginView in
        let temp = JTouristLoginView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight - kTabBarHeight))
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = L$(titleBind)
        if UserInfo.share.is_tourist {
            self.touristDeal()
        } else {
            self.getDataSource()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "设置", style: .done, target: self, action: #selector(rightBtnClick))
            NotificationCenter.default.addObserver(self, selector: #selector(getDataSource), name: NSNotification.Name(rawValue: noti_business_refresh), object: nil)
        }
    }
    
    private func touristDeal() {
        self.view.addSubview(loginView)
    }
    
    @objc private func getDataSource() {
        //mine_business
        dataArr.removeAll()
        if UserInfo.share.is_business {
            //            let bindArr3: [String] = ["mine_service_comment","mine_common_question"]
            if UserInfo.share.isMother {
                dataArr = ["mine_business_profile","mine_business","mine_business_order","mine_business_vip","mine_consume","mine_business_feedback","mine_share","mine_business_service_comment"]
            } else {
                dataArr = ["mine_business_profile","mine_business_order","mine_business_feedback","mine_share","mine_business_service_comment"]
            }
        } else {
            dataArr = ["mine_profile","mine_order","mine_question","mine_vip","mine_feedback","mine_consume","mine_share","mine_service_comment"]
        }
        self.tabView.reloadData()
    }

    @objc private func rightBtnClick() {
        let vc = SetController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MineController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bind = dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MineCell", for: indexPath) as! MineCell
        cell.bind = bind
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let bind = dataArr[indexPath.row]
        if bind == "mine_profile" {
            let vc = MineProfileController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "mine_order" {
            let vc = MineOrderController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "mine_business_order" {
            if UserInfo.share.isMother {
                let vc = MineBusinessOrderController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = MineBusinessOrderSubAccountController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        } else if bind == "mine_question" {
            let vc = MineQuestionController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "mine_vip" {
            let vc = MineVIPController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "mine_business_vip" {
            let vc = MineBusinessVIPController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "mine_feedback" {
            let vc = MineFeedbackController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "mine_business_feedback" {
            let vc = MineBusinessFeedbackController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "mine_consume" {
            if UserInfo.share.is_business {
                let vc = MineBusinessConsumeController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = MineConsumeController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if bind == "mine_about" {
            let urlStr = BASE_URL + api_posts_info + "?symbol=" + "about"
            let vc = JURLController.init(urlStr: urlStr, bind: "mine_about")
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "mine_share" {
            OLAlertManager.share.pickerShow(bindArr: ["wechat","wechat_coil","qq","qq_space","weibo"])
            OLAlertManager.share.pickerView?.delegate = self
        } else if bind == "mine_business_profile" {
            let vc = MineBusinessController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "mine_business" {
            UserInfo.share.companyAccountList { (flag) in
                if flag {
                    let vc = MineBusinessAccountController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else if bind == "mine_service_comment" || bind == "mine_business_service_comment" {
            let vc = MineServiceCommentController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "mine_common_question" {
            let urlStr = BASE_URL + api_posts_info + "?symbol=" + "faq"
            let vc = JURLController.init(urlStr: urlStr, bind: "mine_common_question")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kCellSpaceL
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView")
        return vv
    }
}

extension MineController: OLPickerViewDelegate {
    func olpickerViewClick(bind: String) {
        JShareManager.share.bindShare(bind: bind)
    }
}
