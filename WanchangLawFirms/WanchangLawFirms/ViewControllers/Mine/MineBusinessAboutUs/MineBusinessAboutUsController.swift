//
//  MineBusinessAboutUsController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/1/21.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

/// 关于我们
class MineBusinessAboutUsController: BaseController {

    private lazy var logoImgBtn: JVLogoBtn = {
        () -> JVLogoBtn in
        let temp = JVLogoBtn.init(logo: "about_orange_logo")
        temp.frame = CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: temp.j_height)
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kDeviceWidth, height: kDeviceHeight - kNavHeight), style: .plain, space: 0)
        temp.separatorStyle = .none
        temp.bounces = false
        temp.tableHeaderView = logoImgBtn
        temp.delegate = self
        temp.dataSource = self
        temp.register(MineBusinessAboutUsCell.self, forCellReuseIdentifier: "MineBusinessAboutUsCell")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var bottomV: MineBusinessAboutUsBottomView = {
        () -> MineBusinessAboutUsBottomView in
        let temp = MineBusinessAboutUsBottomView.init(frame: CGRect.init(x: 0, y: kDeviceHeight - 100, width: kDeviceWidth, height: 100))
        self.view.addSubview(temp)
        return temp
    }()
//    private let bindArr: [String] = ["m_us_function","m_us_help","m_us_version"]
    private let bindArr: [String] = ["m_us_version"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = customColor(255, 127, 39)
        self.title = L$("mine_about_orange")
        self.tabView.reloadData()
        self.bottomV.isHidden = false
    }
}

extension MineBusinessAboutUsController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return bindArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bind = bindArr[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MineBusinessAboutUsCell", for: indexPath) as! MineBusinessAboutUsCell
        cell.headLab.text = L$(bind)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kCellSpaceL
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BaseHeaderFooterSpaceView") as! BaseHeaderFooterSpaceView
        vv.contentView.backgroundColor = customColor(255, 127, 39)
        return vv
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bind = bindArr[indexPath.section]
        if bind == "m_us_function" {
            let urlStr = BASE_URL + api_posts_info + "?symbol=" + "co_introduce"
            let vc = JURLController.init(urlStr: urlStr, bind: "m_us_function")
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "m_us_help" {
            let urlStr = BASE_URL + api_posts_info + "?symbol=" + "co_help"
            let vc = JURLController.init(urlStr: urlStr, bind: "m_us_help")
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "m_us_version" {
            self.appstore()
        }
    }
}

extension MineBusinessAboutUsController {
    func appstore() {
        let urlStr = "https://itunes.apple.com/lookup?id=1318568813"
        HTTPManager.share.other_ask(isGet: true, url: urlStr, prams: NSDictionary(), needPrompt: true, successHandler: { (dict) in
            let array = dict["results"] as? NSArray
            let d1 = array?.lastObject as? NSDictionary
            let version = d1?["version"] as? String
            let desc = d1?["releaseNotes"] as? String
            if version == UserInfo.share.version {
                PromptTool.promptText(L$("p_current_latest_version"), 1)
            } else {
                JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: L$("p_check_new_version"), message: desc, sure: L$("p_go_to_update"), cancel: L$("cancel"), sureHandler: { (action) in
                    let url = URL.init(string: "https://itunes.apple.com/cn/app/id1318568813?mt=8")
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url!)
                    }
                }, cancelHandler: nil)
            }
        }) { (error) in
            
        }
    }
    
    func adhoc() {
        let url = URL.init(string: "https://fir.im/iorange")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
}
