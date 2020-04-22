//
//  PCMCalendarView.swift
//  WanchangLawFirms
//
//  Created by lh on 2018/12/13.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

/// 日历视图
class PCMCalendarView: UIView {
    
    var isTeachMeet: Bool = false
    
    private lazy var bView: UIView = {
        () -> UIView in
        let temp = UIView.init(frame: CGRect.init(x: (kDeviceWidth - 300) / 2, y: 10, width: 300, height: 240))
        temp.layer.cornerRadius = 20
        temp.layer.borderColor = kLineGrayColor.cgColor
        temp.layer.borderWidth = 1
        self.addSubview(temp)
        return temp
    }()
    private lazy var leftBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, self, #selector(leftRightBtnsClick(sender:)))
        temp.setImage(UIImage.init(named: "triangle_left_black"), for: .normal)
        bView.addSubview(temp)
        return temp
    }()
    private lazy var rightBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontMS, kTextBlackColor, UIControl.ContentHorizontalAlignment.center, self, #selector(leftRightBtnsClick(sender:)))
        temp.setImage(UIImage.init(named: "triangle_right_black"), for: .normal)
        bView.addSubview(temp)
        return temp
    }()
    private lazy var menuView: JTCalendarMenuView = {
        () -> JTCalendarMenuView in
        let temp = JTCalendarMenuView()
        return temp
    }()
    private lazy var dateView: JTHorizontalCalendarView = {
        () -> JTHorizontalCalendarView in
        let temp = JTHorizontalCalendarView()
        return temp
    }()
    private lazy var calendarManager: JTCalendarManager = {
        () -> JTCalendarManager in
        return JTCalendarManager.init()
    }()
    private var selectedDate: Date?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.calendarManager.delegate = self
        self.calendarManager.settings.weekDayFormat = JTCalendarWeekDayFormat.single
        
        self.bView.addSubview(menuView)
        self.bView.addSubview(dateView)
        
        _ = menuView.sd_layout()?.topSpaceToView(bView, 0)?.leftSpaceToView(bView, 70)?.rightSpaceToView(bView, 70)?.heightIs(40)
        _ = dateView.sd_layout()?.topSpaceToView(menuView, 0)?.leftSpaceToView(bView, 10)?.rightSpaceToView(bView, 10)?.bottomSpaceToView(bView, 10)
        
        self.calendarManager.menuView = self.menuView
        self.calendarManager.contentView = self.dateView
        self.calendarManager.setDate(Date())
        
        _ = leftBtn.sd_layout()?.leftSpaceToView(bView, 30)?.centerYEqualToView(self.menuView)?.widthIs(30)?.heightIs(40)
        _ = rightBtn.sd_layout()?.rightSpaceToView(bView, 30)?.centerYEqualToView(self.menuView)?.widthIs(30)?.heightIs(40)
    }
    
    @objc private func leftRightBtnsClick(sender: UIButton) {
        leftBtn.isUserInteractionEnabled = false
        rightBtn.isUserInteractionEnabled = false
        dateView.isUserInteractionEnabled = false
        if sender.isEqual(leftBtn) {
            dateView.loadPreviousPageWithAnimation()
        } else {
            dateView.loadNextPageWithAnimation()
        }
        self.perform(#selector(lrBtnEnable), with: nil, afterDelay: 0.4)
    }
    
    @objc private func lrBtnEnable() {
        leftBtn.isUserInteractionEnabled = true
        rightBtn.isUserInteractionEnabled = true
        dateView.isUserInteractionEnabled = true
    }
    
}

extension PCMCalendarView: JTCalendarDelegate {
    func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: (UIView & JTCalendarDay)!) {
        let vv: JTCalendarDayView = dayView as! JTCalendarDayView
        vv.isHidden = false
        vv.circleView.isHidden = true
        vv.circleView.backgroundColor = UIColor.clear
        vv.textLabel.textColor = kTextBlackColor
        if vv.isFromAnotherMonth {
            vv.isHidden = true
        } else if calendarManager.dateHelper.date(Date(), isTheSameDayThan: vv.date) {
            vv.circleView.isHidden = false
            vv.circleView.backgroundColor = kOrangeLightColor
            vv.textLabel.textColor = UIColor.white
        } else if calendarManager.dateHelper.date(Date(), isEqualOrAfter: vv.date) {
            vv.textLabel.textColor = kTextGrayColor
        } else if (selectedDate != nil && calendarManager.dateHelper.date(selectedDate!, isTheSameDayThan: vv.date)) {
            vv.circleView.isHidden = false
            vv.circleView.backgroundColor = kOrangeDarkColor
            vv.textLabel.textColor = UIColor.white
        } else if vv.date.isWeekends() {
            vv.textLabel.textColor = kTextGrayColor
        } else {
            vv.circleView.isHidden = true
            vv.textLabel.textColor = kTextBlackColor
        }
    }
    
    func calendar(_ calendar: JTCalendarManager!, didTouchDayView dayView: (UIView & JTCalendarDay)!) {
        let vv: JTCalendarDayView = dayView as! JTCalendarDayView
        if vv.date.isWeekends() {
            return
        }
        if vv.date.isToday() {
            PromptTool.promptText("不能预约当天哦～", 1)
            return
        }
        if calendarManager.dateHelper.date(Date(), isEqualOrAfter: vv.date) {
            return
        }
        if UserInfo.share.is_business {
            if isTeachMeet {
                let t1 = Int(vv.date.timeIntervalSince1970)
                let t2 = Int(Date().timeIntervalSince1970)
                if t1 - t2 < 3600 * 24 * 9 {
                    PromptTool.promptText("企业培训需要提前10日预约哦～", 1)
                    return
                }
            } else {
                if UserInfo.share.is_vip {
                    if UserInfo.share.vip_from_index == 0 {
                        if vv.date.isTomorrow() || vv.date.isAfterTomorrow() {
                            PromptTool.promptText("钻石会员需要提前3天预约哦～", 1)
                            return
                        }
                    } else if UserInfo.share.vip_from_index == 1 {
                        if vv.date.isTomorrow() {
                            PromptTool.promptText("星耀会员需要提前2天预约哦～", 1)
                            return
                        }
                    }
                } else {
                    PromptTool.promptText("需要开通会员才能预约哦～", 1)
                    return
                }
            }
        }
        selectedDate = vv.date
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let str1 = dateFormatter.string(from: vv.date)
        let str2 = vv.date.weekdayStr()
        JMeetManager.share.model.date = str1 + str2
        calendarManager.reload()
    }
    
    func calendarBuildWeekDayView(_ calendar: JTCalendarManager!) -> (UIView & JTCalendarWeekDay)! {
        let vv: JTCalendarWeekDayView = JTCalendarWeekDayView()
        for i in 0..<vv.dayViews.count {
            let lab = vv.dayViews[i] as? UILabel
            if i > 0 && i < 6 {
                lab?.textColor = kTextBlackColor
            } else {
                lab?.textColor = kTextGrayColor
            }
        }
        return vv
    }
    
    func calendar(_ calendar: JTCalendarManager!, prepareMenuItemView menuItemView: UIView!, date: Date!) {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy年M月"
        let lab = menuItemView as! UILabel
        lab.text = dateFormatter.string(from: date)
    }
    
}
