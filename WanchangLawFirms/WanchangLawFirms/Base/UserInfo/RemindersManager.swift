//
//  RemindersManager.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 单例  本地温馨提示等内容
class RemindersManager: NSObject {
    @objc static let share = RemindersManager()
    
    private var modelArr: [RemindersModel] = [RemindersModel]()
    
    /// 健
    private let bindArr: [String] =
        [
            "h_me_consult",
            "h_agreement_custom",
            "h_agreement_check",
            "h_lawyer_letter",
            "h_notification_letter",
            "h_litigant_document",
            "h_meeting_consult",
            "h_meeting_lawyer",
            "h_meeting_teach",
            "h_watch_flow_desc",
            "h_me_consult_desc",
            "h_agreement_custom_desc",
            "h_agreement_check_desc",
            "h_lawyer_letter_desc",
            "h_notification_letter_desc",
            "h_litigant_document_desc",
            "h_meeting_consult_desc",
            "mine_question",
            "vip_consult",
            "vip_template",
            "vip_rank",
            "business_vip_rank",
            "vip_sum",
            "m_vip_regular",
            "h_meeting_teach_desc",
            "h_meeting_lawyer_desc"
        ]
    /// 值
    private let contentArr: [String] =
        [
            "1.描述问题时为避免因文字歧义带来的误解，请尽量使用简明扼要的文字将您的要求描述清晰。\n2.工作时间：8:30-20:30。",
            "1.描述问题时为避免因文字歧义带来的误解，请尽量使用简明扼要的文字将您的要求描述清晰。\n2.会员专享折扣：钻石会员享9折优惠，星耀会员享8折优惠，荣耀会员享7折优惠！\n3.定制的每份合同拥有两次修改的机会。\n4.工作时间：8:30-20:30。",
            "1.描述问题时为避免因文字歧义带来的误解，请尽量使用简明扼要的文字将您的要求描述清晰。\n2.会员专享折扣：钻石会员享9折优惠，星耀会员享8折优惠，荣耀会员享7折优惠！\n3.审查的每份合同拥有两次修改的机会。\n4.工作时间：8:30-20:30。",
            "1.描述问题时为避免因文字歧义带来的误解，请尽量使用简明扼要的文字将您的要求描述清晰。\n2.会员专享折扣：钻石会员享9折优惠，星耀会员享8折优惠，荣耀会员享7折优惠！\n3.代写的每份律师函拥有两次修改的机会。\n4.工作时间：8:30-20:30。",
            "1.描述问题时为避免因文字歧义带来的误解，请尽量使用简明扼要的文字将您的要求描述清晰。\n2.会员专享折扣：钻石会员享9折优惠，星耀会员享8折优惠，荣耀会员享7折优惠！\n3.代写的每份告知函拥有两次修改的机会。\n4.工作时间：8:30-20:30。",
            "1.描述问题时为避免因文字歧义带来的误解，请尽量使用简明扼要的文字将您的要求描述清晰。\n2.会员专享折扣：钻石会员享9折优惠，星耀会员享8折优惠，荣耀会员享7折优惠！\n3.代写的每份文书拥有两次修改的机会。\n4.工作时间：8:30-20:30。",
            "1.请提前24小时预约，可约见时间为：早上9:30-11:30、下午14:30-16:30。\n2.预约成功后，如遇特殊情形，需要更改约见时间，请提前一个工作日告知客服人员。\n3.如会面时间更改，会面律师可能根据实际情况进行调整；若调整律师，我们将会于下一个工作日前与你进行联系。\n4.预约成功后，若因用户自身原因，导致会见无法进行，欧伶猪无须承担与此有关的任何责任。",
            "1.荣耀会员享有会员有效期内共2次企业培训（以开通时间为基准，每6个月1次 ）\n2.请提前10个工作日预约培训，若要取消，请提前3个工作日取消预约。\n3.律师进行企业培训的时长为1.5个小时内\n4.律师工作时间为9:30-16:30\n5.预约成功后我们将以系统消息及短信通知您，请留意信息。",
            "1.荣耀会员提前1天预约，星耀会员提前2天预约，钻石会员提前3天预约，可预约时间为：早上9:30-11:30  下午：14：30-16：30\n2.预约成功后，如遇特殊情形，需要更改约见时间，请提前一个工作日告知客服人员。\n3.如会面时间更改，会面律师可能根据实际情况进行调整，若调整律师，我们将会于下一个工作日前与你进行联系。\n4.预约成功后，若因用户自身原因，导致会见无法进行，欧伶猪无须承担与此有关的任何责任。",
            "图解流程，直观易懂",
            "专业人员为您提供各类法律意见",
            "专业人员为您定制，严格把控每一个细节",
            "专业人员为您审查合同，成立合同，确保合同目的的实现",
            "专业人员为您指导，提供专业法律意见及法律函件",
            "专业人员为您撰写更规范的告知函件，有效保障权利主张",
            "专业人员为您定制文书，起草协议，提供各类法律意见",
            "专业人员面对面，为您排忧解惑",
            "1.购买问题后，该问题有效期为1年。\n2.一个问题数量只可咨询一个法律事件。\n3.问题数量只可单次购买，如需进行多个法律事件咨询，请累加购买。\n4.会员专享折扣：钻石会员享9折优惠，星耀会员享8折优惠，荣耀会员享7折优惠！现加入欧伶猪会员尊享过多特权！",
            "一对一快速咨询，实时在线解答，最高享受7折优惠。",
            "海量模版在线预览，会员一键下载。",
            "· 钻石会员288元/年：免费咨询法律事件1次，即省230元；\n· 星耀会员488元/年：免费咨询法律事件2次，即省548元；\n· 荣耀会员698元/年：免费咨询法律事件3次，即省856元。",
            "· 钻石会员3888元/年，免费咨询法律事件无限次\n· 星耀会员6888元/年，免费咨询法律事件无限次，文书定制审查36次（包含其它文书但不包含律师函）；\n· 荣耀会员12888元/年，免费咨询法律事件无限次，文书审查+文书定制不限次数（包含其它文书但不包含律师函），律师约见6次，每次约见时长为2小时内，在原有基础上赠送1个子账号，律师函购买9折，企业培训共2次（以开通时间为准，每6个月1次），问题处理绿色通道（优先推送服务），文书模版下载不限次。",
            "欧伶猪会员在线咨询优先回复、最新资源任意浏览，更多会员福利等您来享。",
            "1.会员有效期为一年。\n2.会员开通期间，可点击下方“升级会员”提升会员级别，尊享更多特权。",
            "专业律师为您进行法律培训",
            "专业律师为您面对面解答"
        ]
    
    override init() {
        super.init()
        for i in 0..<bindArr.count {
            let m = RemindersModel.init(bind: bindArr[i], content: contentArr[i])
            self.modelArr.append(m)
        }
    }

}

extension RemindersManager {
    
    /// 根据bind获取提示语
    ///
    /// - Parameter bind: 健
    /// - Returns: 提示内容
    func reminders(bind: String) -> String {
        var result = ""
        for m in modelArr {
            if m.bind == bind {
                result = m.showContent
                break
            }
        }
        return result
    }
    
    /// 根据key获取标题
    ///
    /// - Parameter bind: key
    /// - Returns: 标题内容
    func remindTitle(bind: String) -> String {
        var result = L$(bind)
        for m in modelArr {
            if m.bind == bind {
                result = m.showTitle
            }
        }
        return result
    }
    
    /// 获取提示内容的高度
    ///
    /// - Parameters:
    ///   - bind: 健
    ///   - font: 字体大小
    ///   - width: 宽度
    /// - Returns: 文本高度
    func remiderHeight(bind: String, font: UIFont, width: CGFloat) -> CGFloat {
        let ns = self.reminders(bind: bind) as NSString
        let h = ns.boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size.height
        return h
    }
}

extension RemindersManager {
    /// 网络请求后更新为网络端的提示语
    ///
    /// - Parameters:
    ///   - bind: key
    ///   - content: 提示内容
    func updateContent(bind: String, content: String?) {
        for m in modelArr {
            if m.bind == bind {
                m.net_content = content
                break
            }
        }
    }
    
    /// 网络请求后更新为网络端的标题
    ///
    /// - Parameters:
    ///   - bind: key
    ///   - title: 标题
    ///   - content: 内容
    func updateTitleContent(bind: String, title: String?, content: String?) {
        for m in modelArr {
            if m.bind == bind {
                m.net_title = title
                m.net_content = content
                break
            }
        }
    }
}
