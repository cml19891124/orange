//
//  HomeManager.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/3.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 首页网络请求管理
class HomeManager: NSObject {
    static let share: HomeManager = HomeManager()
    
    /// 产品列表
    var productList: [ProductListModel] = [ProductListModel]()
    /// 轮播数据源
    var sliderList: [OLCarouselModel] = [OLCarouselModel]()
    
    override init() {
        super.init()
    }

}

extension HomeManager {
    /// 获取轮播数据源
    func pubSliders() {
        HTTPManager.share.ask(isGet: true, url: api_pub_sliders, prams: NSDictionary(), needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let temp = dict[net_key_result] as? NSArray
                if temp != nil {
                    let str = temp?.mj_JSONString()
                    UserInfo.setStandard(key: standard_home_slider, text: str)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_home_slider_refresh), object: nil)
                }
            }
        }) { (err) in
            
        }
    }
}

extension HomeManager {
    /// 获取消费记录
    func userTrades(prams: NSDictionary, success:@escaping([MineConsumeModel]?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_user_trades, prams: prams, needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let resultDict = dict[net_key_result] as? NSDictionary
                let arr = MineConsumeModel.mj_objectArray(withKeyValuesArray: resultDict?["data"]) as? [MineConsumeModel]
                success(arr)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
    }
    
    /// 意见反馈
    func userFeedback(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_user_feedback, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (error) in
            success(false)
        }
    }
    
    /// 我的订单
    func userOrders(prams: NSDictionary, success:@escaping([MessageModel]?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_user_orders, prams: prams, needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let resultDict = dict[net_key_result] as? NSDictionary
                let arr = MessageModel.mj_objectArray(withKeyValuesArray: resultDict?["data"]) as? [MessageModel]
                success(arr)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
    }
    
    /// 我的订单
    func userOrdersAll(prams: NSDictionary, success:@escaping([MessageModel]?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_user_orders_all, prams: prams, needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let resultDict = dict[net_key_result] as? NSDictionary
                let arr = MessageModel.mj_objectArray(withKeyValuesArray: resultDict?["data"]) as? [MessageModel]
                success(arr)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
    }
    
    /// 企业订单
    func companyOrders(prams: NSDictionary, success:@escaping([MessageModel]?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_company_orders_all, prams: prams, needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let resultDict = dict[net_key_result] as? NSDictionary
                let arr = MessageModel.mj_objectArray(withKeyValuesArray: resultDict?["data"]) as? [MessageModel]
                success(arr)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (err) in
            success(nil)
        }
    }
    
    func companyOrderDelete(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_order_delete, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                success(false)
                PromptTool.promptText(dict[net_key_msg], 1)
            }
        }) { (err) in
            success(false)
        }
    }
    
    func companyTransferInfo(success:@escaping(OrangeBankModel?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_company_transfer_info, prams: NSDictionary(), needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let m = OrangeBankModel.mj_object(withKeyValues: dict[net_key_result])
                success(m)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (err) in
            success(nil)
        }
    }
}

extension HomeManager {
    /// 服务产品列表
    func serviceList(id: String, success:@escaping([ProductModel]?) -> Void) {
        let url = api_services_list + "/" + id
        HTTPManager.share.ask(isGet: true, url: url, prams: NSDictionary(), needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let arr = ProductModel.mj_objectArray(withKeyValuesArray: dict[net_key_result]) as? [ProductModel]
                success(arr)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
        
    }
    
    /// 服务产品详情
    func serviceDetail(id: String, success:@escaping(ProductModel?) -> Void) {
        let url = api_services_detail + "/" + id
        HTTPManager.share.ask(isGet: true, url: url, prams: NSDictionary(), needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let model = ProductModel.mj_object(withKeyValues: dict[net_key_result])
                success(model)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
    }
    
    /// 服务产品详情
    func serviceDetailWithBind(bind: String, success:@escaping(ProductModel?) -> Void) {
        let id = self.idByBind(bind: bind)
        let url = api_services_detail + "/" + id
        HTTPManager.share.ask(isGet: true, url: url, prams: NSDictionary(), needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let model = ProductModel.mj_object(withKeyValues: dict[net_key_result])
                RemindersManager.share.updateContent(bind: bind, content: model?.desc)
                success(model)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
    }
    
    /// 意见反馈分类
    func serviceListShow(success:@escaping([ProductModel]?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_services_list_show, prams: NSDictionary(), needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let arr = ProductModel.mj_objectArray(withKeyValuesArray: dict[net_key_result]) as? [ProductModel]
                success(arr)
            } else {
                success(nil)
            }
        }) { (err) in
            success(nil)
        }
    }
    
    /// 创建订单
    func orderCreate(prams: NSDictionary, success:@escaping(Bool, String?) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_order_create, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let sn = dict[net_key_result] as? String
                success(true, sn)
            } else if code == 105 {
                success(false, dict[net_key_msg] as? String)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false, nil)
            }
        }) { (error) in
            success(false, nil)
        }
    }
    
    /// 结束订单
    func orderFinish(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_order_finish, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let order_sn = prams["order_sn"] as! String
                RealmManager.share().updateConversationFinish(order_sn)
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (error) in
            success(false)
        }
    }
    
    /// 订单数据源
    func orderView(prams: NSDictionary, success:@escaping(MessageModel?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_order_view, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let model = MessageModel.mj_object(withKeyValues: dict[net_key_result])
                success(model)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
    }
    
    /// 创建Vip订单
    func vipOrderCreate(prams: NSDictionary, success:@escaping(Bool, String?) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_vip_order_create, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let sn = dict[net_key_result] as? String
                success(true, sn)
            } else if code == 105 {
                success(false, dict[net_key_msg] as? String)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false, nil)
            }
        }) { (error) in
            success(false, nil)
        }
    }
    
    /// Vip列表
    func vipList(prams: NSDictionary, success:@escaping([JVipListModel]?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_vip_list, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let arr = JVipListModel.mj_objectArray(withKeyValuesArray: dict[net_key_result]) as? [JVipListModel]
                success(arr)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
    }
    
    /// Vip列表
    func businessVipList(prams: NSDictionary, success:@escaping([JVipListModel]?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_company_vip, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let arr = JVipListModel.mj_objectArray(withKeyValuesArray: dict[net_key_result]) as? [JVipListModel]
                success(arr)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
    }
    
    /// 企业vip订单列表
    func companyVipOrderList(success:@escaping([MessageModel]?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_company_vip_order_list, prams: NSDictionary(), needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let arr = MessageModel.mj_objectArray(withKeyValuesArray: dict[net_key_result]) as? [MessageModel]
                success(arr)
            } else {
                success(nil)
            }
        }) { (err) in
            success(nil)
        }
    }
    
    func companyVipOrderView(prams: NSDictionary, success:@escaping(MessageModel?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_company_vip_order_view, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let m = MessageModel.mj_object(withKeyValues: dict[net_key_result])
                success(m)
            } else {
                success(nil)
            }
        }) { (err) in
            success(nil)
        }
    }
    
}

extension HomeManager {
    /// 获取资讯分类
    func postsCategories(prams: NSDictionary, success:@escaping([HCategoryModel]?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_posts_categories, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let arr = HCategoryModel.mj_objectArray(withKeyValuesArray: dict[net_key_result]) as? [HCategoryModel]
                success(arr)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
    }
    
    /// 获取资讯分类下的文章列表
    func postsList(prams: NSDictionary, success:@escaping([HomeModel]?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_posts_list, prams: prams, needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let resultDict = dict[net_key_result] as? NSDictionary
                let arr = HomeModel.mj_objectArray(withKeyValuesArray: resultDict?["data"]) as? [HomeModel]
                success(arr)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
    }
    
    /// 获取资讯详情
    func postsDetail(prams: NSDictionary, success:@escaping(String?) -> Void) {
        HTTPManager.share.html(isGet: true, url: api_posts_detail, prams: prams, needPrompt: true, successHandler: { (htmlStr) in
            success(htmlStr)
        }) { (error) in
            success(nil)
        }
    }
    
    /// 获取资讯数据源
    func vipView(prams: NSDictionary, success:@escaping(MineVIPModel?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_posts_view, prams: prams, needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let model = MineVIPModel.mj_object(withKeyValues: dict[net_key_result])
                success(model)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
    }
    func businessVipView(prams: NSDictionary, success:@escaping(MineBusinessVIPModel?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_posts_view, prams: prams, needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let model = MineBusinessVIPModel.mj_object(withKeyValues: dict[net_key_result])
                success(model)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
    }
    
    /// 订单评论
    func orderComment(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_order_comment, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (err) in
            success(false)
        }
    }
    
    func orderConfirmCancel(isCancel: Bool, prams: NSDictionary, success:@escaping(Bool) -> Void) {
        var api_str = api_order_confirm
        if isCancel {
            api_str = api_order_cancel
        }
        HTTPManager.share.ask(isGet: false, url: api_str, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (err) in
            success(false)
        }
    }
    
    func orderVipConfirmCancel(isCancel: Bool, prams: NSDictionary, success:@escaping(Bool) -> Void) {
        var api_str = api_vip_order_confirm
        if isCancel {
            api_str = api_vip_order_cancel
        }
        HTTPManager.share.ask(isGet: false, url: api_str, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (err) in
            success(false)
        }
    }
}

extension HomeManager {
    /// 发送到邮箱
    func pubEmailSend(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_pub_email_send, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(false)
            }
        }) { (erro) in
            success(false)
        }
    }
}

extension HomeManager {
    /// 计算器配置
    func counterSetting(prams: NSDictionary, success:@escaping(JCalculateTypeModel?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_counter_setting, prams: prams, needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let model = JCalculateTypeModel.mj_object(withKeyValues: dict[net_key_result])
                success(model)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
    }
    
    /// 工伤计算
    func counterWork(prams: NSDictionary, success:@escaping(FCResultModel?) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_counter_work, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let m = FCResultModel.mj_object(withKeyValues: dict[net_key_result])
                success(m)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
    }
    
    /// 交通人身赔偿计算
    func counterTraffic(prams: NSDictionary, success:@escaping(FCResultModel?) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_counter_traffic, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let m = FCResultModel.mj_object(withKeyValues: dict[net_key_result])
                success(m)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
    }
    
    /// 律师费计算
    func counterLawyer(prams: NSDictionary, success:@escaping(FCResultModel?) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_counter_lawyer, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let m = FCResultModel.mj_object(withKeyValues: dict[net_key_result])
                success(m)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
    }
    
    /// 诉讼费计算
    func counterSue(prams: NSDictionary, success:@escaping(FCResultModel?) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_counter_sue, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let m = FCResultModel.mj_object(withKeyValues: dict[net_key_result])
                success(m)
            } else {
                PromptTool.promptText(dict[net_key_msg], 1)
                success(nil)
            }
        }) { (error) in
            success(nil)
        }
    }
    
    /// 计算详情
    func counterInfo(prams: NSDictionary, success:@escaping(String?) -> Void) {
        HTTPManager.share.html(isGet: true, url: api_counter_info, prams: prams, needPrompt: true, successHandler: { (str) in
            success(str)
        }) { (err) in
            success(nil)
        }
    }
}

extension HomeManager {
    func invoiceList(success:@escaping([InvoiceListModel]?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_invoice_list, prams: NSDictionary(), needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let arr = InvoiceListModel.mj_objectArray(withKeyValuesArray: dict[net_key_result]) as? [InvoiceListModel]
                success(arr)
            } else {
                success(nil)
            }
        }) { (err) in
            success(nil)
        }
    }
    
    func invoiceCreate(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_invoice_create, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                success(false)
            }
        }) { (err) in
            success(false)
        }
    }
    
    func invoiceView(prams: NSDictionary, success:@escaping(InvoiceListModel?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_invoice_view, prams: prams, needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let model = InvoiceListModel.mj_object(withKeyValues: dict[net_key_result])
                success(model)
            } else {
                success(nil)
            }
        }) { (err) in
            success(nil)
        }
    }
    
    func invoiceHeadInfo(success:@escaping(InvoiceHeadListModel?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_invoice_head_info, prams: NSDictionary(), needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let model = InvoiceHeadListModel.mj_object(withKeyValues: dict[net_key_result])
                success(model)
            } else {
                success(nil)
            }
        }) { (err) in
            success(nil)
        }
    }
    
    func invoiceHeadCreate(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_invoice_head_create, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                success(false)
            }
        }) { (err) in
            success(false)
        }
    }
    
    func invoiceHeadUpdate(prams: NSDictionary, success:@escaping(Bool) -> Void) {
        HTTPManager.share.ask(isGet: false, url: api_invoice_head_update, prams: prams, needPrompt: true, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                success(true)
            } else {
                success(false)
            }
        }) { (err) in
            success(false)
        }
    }
    
    func userTradesInvoice(success:@escaping([InvoiceListModel]?) -> Void) {
        HTTPManager.share.ask(isGet: true, url: api_user_trades_invoice, prams: NSDictionary(), needPrompt: false, successHandler: { (dict) in
            let code = dict[net_key_code] as? Int
            if code == 200 {
                let arr = InvoiceListModel.mj_objectArray(withKeyValuesArray: dict[net_key_result]) as? [InvoiceListModel]
                success(arr)
            } else {
                success(nil)
            }
        }) { (err) in
            success(nil)
        }
    }
}

extension HomeManager {
    func bindById(id: String) -> String {
        var str2 = ""
        if id == "1" {
            str2 = "mine_question"
        } else if id == "2" {
            str2 = "h_me_consult"
        } else if id == "3" {
            str2 = "h_agreement_custom"
        } else if id == "4" {
            str2 = "h_agreement_check"
        } else if id == "5" {
            str2 = "h_lawyer_letter"
        } else if id == "6" {
            str2 = "h_notification_letter"
        } else if id == "7" {
            str2 = "h_litigant_document"
        } else if id == "8" {
            str2 = "h_business_business_contract"
        } else if id == "9" {
            str2 = "h_business_equity_affairs"
        } else if id == "10" {
            str2 = "h_business_manage_system"
        } else if id == "11" {
            str2 = "h_business_litigant_document"
        } else if id == "12" {
            str2 = "h_business_lawyer_letter"
        } else if id == "13" {
            str2 = "h_business_book_check"
        } else if id == "14" {
            str2 = "h_business_consult"
        } else if id == "16" {
            str2 = "h_meeting_lawyer"
        } else if id == "17" {
            str2 = "h_meeting_teach"
        }
        return str2
    }
    
    func idByBind(bind: String) -> String {
        var id = ""
        if bind == "mine_question" {
            id = "1"
        } else if bind == "h_me_consult" {
            id = "2"
        } else if bind == "h_agreement_custom" {
            id = "3"
        } else if bind == "h_agreement_check" {
            id = "4"
        } else if bind == "h_lawyer_letter" {
            id = "5"
        } else if bind == "h_notification_letter" {
            id = "6"
        } else if bind == "h_litigant_document" {
            id = "7"
        } else if bind == "h_business_business_contract" {
            id = "8"
        } else if bind == "h_business_equity_affairs" {
            id = "9"
        } else if bind == "h_business_manage_system" {
            id = "10"
        } else if bind == "h_business_litigant_document" {
            id = "11"
        } else if bind == "h_business_lawyer_letter" {
            id = "12"
        } else if bind == "h_business_book_check" {
            id = "13"
        } else if bind == "h_business_consult" {
            id = "14"
        } else if bind == "h_meeting_lawyer" {
            id = "16"
        } else if bind == "h_meeting_teach" {
            id = "17"
        }
        return id
    }
    
    func logoImgNameBy(title: String) -> String {
        var temp = "consume_record_vip"
        if title == "会员开通" {
            temp = "consume_record_vip"
        } else if title == "我要咨询" || title == "购买问题" {
            temp = "h_me_consult_detail"
        } else if title == "合同定制" {
            temp = "h_agreement_custom_detail"
        } else if title == "合同审查" {
            temp = "h_agreement_check_detail"
        } else if title == "律师函" {
            temp = "h_lawyer_letter_detail"
        } else if title == "告知函" {
            temp = "h_notification_letter_detail"
        } else if title == "诉讼文书" {
            temp = "h_litigant_document_detail"
        } else if title == "会面咨询" {
            temp = "h_meeting_consult_detail"
        }
        return temp
    }
    
    func statusStrBy(id: String) -> String {
        var temp = ""
        if id == "0" {
            temp = "c_un_pay"
        } else if id == "1" {
            temp = "c_dealing"
        } else if id == "2" {
            temp = "c_finished"
        } else if id == "4" {
            temp = "c_cancelled"
        }
        return temp
    }
    
    func statusIdBy(bind: String) -> String {
        var temp = ""
        if bind == "c_un_pay" {
            temp = "0"
        } else if bind == "c_dealing" {
            temp = "1"
        } else if bind == "c_finished" {
            temp = "2"
        } else if bind == "c_cancelled" {
            temp = "4"
        } else if bind == "c_un_pay_un_sure" {
            temp = "0"
        } else if bind == "c_un_sure" {
            temp = "0"
        }
        return temp
    }
}
