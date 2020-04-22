//
//  HomeController.swift
//  OLegal
//
//  Created by lh on 2018/11/19.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 首页控制器
class HomeController: BaseController {
    private var head_height: CGFloat = 0
    
    private lazy var headV: HomeHeadView = {
        () -> HomeHeadView in
        let temp = HomeHeadView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: head_height))
        head_height = temp.end_height
        temp.frame = CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: head_height)
        temp.customView.delegate = self
        temp.funcView.delegate = self
        return temp
    }()
    
    private lazy var j_header: JRefreshHeader = {
        () -> JRefreshHeader in
        let temp = JRefreshHeader.init(refreshingTarget: self, refreshingAction: #selector(getDataSource))
        return temp!
    }()
    lazy var tabView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: kDeviceHeight - kTabBarHeight), style: .grouped, space: kLeftSpaceL)
        temp.delegate = self
        temp.dataSource = self
        temp.mj_header = self.j_header
        if #available(iOS 11.0, *) {
            temp.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        temp.register(HomeCell.self, forCellReuseIdentifier: "HomeCell")
        temp.register(HomeHeaderView.self, forHeaderFooterViewReuseIdentifier: "HomeHeaderView")
        temp.register(BaseHeaderFooterSpaceView.self, forHeaderFooterViewReuseIdentifier: "BaseHeaderFooterSpaceView")
        self.view.addSubview(temp)
        return temp
    }()
    private var serviceClicked: Bool = false
    private var dataArr: [HomeModel] = [HomeModel]()
    private var completeDataReminded: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        UserInfo.share.localDataSource()
        self.setupViews()
        if UserInfo.share.is_tourist {
            self.touristConfigDeal()
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "nav_back_icon"), style: .done, target: self, action: #selector(touristBack))
        } else {
            self.configDeal()
        }
        if !UserInfo.defaultLeaded() {
            let _ = OLeadView.init(head_height: kBarStatusHeight + 200)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(personDataJudge), name: NSNotification.Name(rawValue: "noti_user_model_refresh"), object: nil)
        }
    }
    
    @objc private func personDataJudge() {
        if completeDataReminded {
            return
        }
        completeDataReminded = true
        if UserInfo.share.is_business {
            return
        }
        if UserInfo.share.model?.mobile.haveTextStr() == true || UserInfo.share.model?.email.haveTextStr() == true || UserInfo.share.model?.address.haveTextStr() == true {
            return
        }
        JAuthorizeManager.init(view: self.view).alertController(style: .alert, titleStr: "温馨提示", message: "请先完善个人资料", sure: "去完善", cancel: L$("cancel"), sureHandler: { (action) in
            let vc = MineProfileController()
            self.navigationController?.pushViewController(vc, animated: true)
        }, cancelHandler: nil)
    }
    
    @objc private func touristBack() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_tourist_back), object: nil)
    }
    
    /// 首页布局，要设置UITableView的下沉偏移量，实现特定刷新功能
    private func setupViews() {
        self.tabView.addSubview(self.headV)
        self.tabView.reloadData()
        self.tabView.contentInset = UIEdgeInsets.init(top: head_height, left: 0, bottom: 0, right: 0)
        self.localDataSource()
    }
    
    /// 加载本地缓存数据
    @objc private func localDataSource() {
        let arr = RealmManager.share().getHomeLatest()
        self.dataArr.removeAll()
        var i = 0
        for m in arr {
            if i > 4 {
                break
            }
            self.dataArr.append(m)
            i += 1
        }
        self.tabView.reloadData()
    }
    
    /// 刷新网络数据，先刷新token，再进行其它操作
    private func configDeal() {
        RealmManager.share().updateUnsendMsgFailed()
        UserInfo.share.netRefreshToken {
            HomeManager.share.pubSliders()
            if self.dataArr.count == 0 {
                self.tabView.mj_header.beginRefreshing()
            } else {
                self.getDataSource()
            }
            JSocketHelper.share.connectionSocket()
            UserInfo.share.netUserInfo()
        }
    }
    
    private func touristConfigDeal() {
        HomeManager.share.pubSliders()
        if self.dataArr.count == 0 {
            self.tabView.mj_header.beginRefreshing()
        } else {
            self.getDataSource()
        }
    }

    @objc private func getDataSource() {
        let prams: NSDictionary = ["cid":"1","recommend":"1","child":"1"]
        HomeManager.share.postsList(prams: prams) { (arr) in
            self.j_header.jDelayEndRefreshing {
                if arr != nil {
                    self.dataArr.removeAll()
                    var i = 0
                    for m in arr! {
                        if i >= 5 {
                            break
                        }
                        self.dataArr.append(m)
                        i += 1
                    }
                    self.tabView.reloadData()
                    RealmManager.share().addHomeLatest(arr!)
                }
            }
        }
    }
    
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataArr[indexPath.row]
        let vc = ArticleDetailController()
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeHeaderView") as! HomeHeaderView
        vv.delegate = self
        vv.titleBtn.setTitle(kBtnSpaceString + L$("h_latest_information"), for: .normal)
        vv.moreBtn.setTitle(L$("h_watch_more"), for: .normal)
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
        return 30
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tempY: CGFloat = 200
        let offsetY = scrollView.contentOffset.y + head_height
        if offsetY > tempY {
            self.navigationItem.title = L$("home")
            self.currentNavigationBarAlpha = 1
        } else if offsetY < tempY {
            if offsetY < 100 {
                self.navigationItem.title = ""
                self.currentNavigationBarAlpha = 0
            } else {
                self.navigationItem.title = L$("home")
                let alpha = (tempY - offsetY) / offsetY
                self.currentNavigationBarAlpha = 1 - alpha
            }
        }
        if offsetY >= 0 {
            self.headV.frame = CGRect.init(x: 0, y: -head_height, width: kDeviceWidth, height: head_height)
        } else {
            self.headV.frame = CGRect.init(x: 0, y: -head_height + offsetY, width: kDeviceWidth, height: head_height)
        }
        let o_y: CGFloat = scrollView.contentSize.height - scrollView.bounds.size.height
        if scrollView.contentOffset.y >= o_y {
            scrollView.contentOffset.y = o_y
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y + head_height
        if offsetY > 0 {
            scrollView.bounces = false
        } else {
            scrollView.bounces = true
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.bounces = true
    }
    
}

/// 最新资讯
extension HomeController: HomeHeaderViewDelegate {
    func homeHeaderViewMoreClick() {
        let vc = ArticleListController()
        vc.titleBind = "h_latest_information"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

/// 首页功能按钮点击
extension HomeController: HomeCollectionDelegate {
    func homeCollectionClick(bind: String) {
        if bind == "h_me_consult" {
            let vc = MeConsultController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "h_person_custom" {
            let vc = PersonCustomController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "h_classic_case" {
            let vc = ArticleListController()
            vc.titleBind = "h_classic_case"
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "h_document_template" {
            if serviceClicked == true {
                return
            }
            serviceClicked = true
            var pid = "11"
            if UserInfo.share.is_business {
                pid = "22"
            }
            let prams: NSDictionary = ["pid":pid]
            HomeManager.share.postsCategories(prams: prams) { (arr) in
                if arr != nil {
                    let vc = DocumentTemplateController()
                    vc.categoryModelArr = arr!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                self.serviceClicked = false
            }
        } else if bind == "h_forensic_calculator" {
            let vc = ForensicCalculatorController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "h_online_service" {
            if JRootVCManager.share.touristJudgeAlert() {
                return
            }
            if serviceClicked == true {
                return
            }
            serviceClicked = true
            UserInfo.share.netChatCS { (model) in
                if model != nil {
                    LawyerManager.share.addLawyersByList(arr: [model!])
                    let vc = ChatController()
                    vc.model = model!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                self.serviceClicked = false
            }
        } else if bind == "h_business_consult" {
            let vc = ZZBusinessDetailController()
            vc.id = "14"
            self.navigationController?.pushViewController(vc, animated: true)
        } else if bind == "h_business_custom" {
            let vc = ZZBusinessFirstController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
