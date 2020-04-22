//
//  OLeadView.swift
//  WanchangLawFirms
//
//  Created by szcy on 2019/9/30.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class OLeadView: UIView {
    
    private let notiWidth: CGFloat = 114 * 1.2
    private let notiHeight: CGFloat = 82 * 1.2
    
    private let pigWH: CGFloat = 70
    
    private let pigOffsetY: CGFloat = 5
    private let pigOffsetX: CGFloat = 10
    
    private let notiSpace: CGFloat = 40
    private let notiOffsetY: CGFloat = 20
    
    private var head_height: CGFloat = 0
    
    private lazy var bgView: OLeadBGView = {
        let tmp = OLeadBGView.init(supView: self)
        return tmp
    }()
    
    private lazy var notiImgView: UIImageView = {
        let tmp = UIImageView.init(UIView.ContentMode.scaleAspectFit)
        tmp.frame.size = CGSize.init(width: notiWidth, height: notiHeight)
        self.addSubview(tmp)
        return tmp
    }()
    private lazy var pigImgView: UIImageView = {
        let tmp = UIImageView.init(UIView.ContentMode.scaleAspectFit)
        tmp.frame.size = CGSize.init(width: pigWH, height: pigWH)
        self.addSubview(tmp)
        return tmp
    }()
    private var step = 1
    
    private lazy var tap: UITapGestureRecognizer = {
        let tmp = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        return tmp
    }()
    
    convenience init(head_height: CGFloat) {
        self.init(frame: UIScreen.main.bounds)
        self.head_height = head_height
        self.bgView.isHidden = false
        location1()
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    @objc private func tapClick() {
        step += 1
        if step == 2 {
            location2()
        } else if step == 3 {
            location3()
        } else if step == 4 {
            location4()
        } else {
            UserInfo.setLeaded(text: "1")
            self.removeFromSuperview()
        }
    }
    
    private func location1() {
        notiImgView.image = UIImage.init(named: "o_lead_consult")
        pigImgView.image = UIImage.init(named: "o_pig_right")
        notiImgView.frame.origin = CGPoint.init(x: kLeftSpaceS + notiSpace, y: head_height - notiHeight - notiOffsetY)
        pigImgView.frame.origin = CGPoint.init(x: kLeftSpaceS + notiSpace + notiWidth - pigOffsetX, y: head_height - notiHeight - notiOffsetY + pigOffsetY)
        let rect = CGRect.init(x: ((kDeviceWidth - kLeftSpaceS * 2) / 4 - 35), y: head_height - notiOffsetY, width: 90, height: 90)
        self.bgView.drawCircle(rect: rect)
    }
    
    private func location2() {
        notiImgView.image = UIImage.init(named: "o_lead_make")
        pigImgView.image = UIImage.init(named: "o_pig_left")
        notiImgView.frame.origin = CGPoint.init(x: kDeviceWidth - kLeftSpaceS - notiSpace - notiWidth, y: head_height - notiHeight - notiOffsetY)
        pigImgView.frame.origin = CGPoint.init(x: kDeviceWidth - kLeftSpaceS - notiSpace - notiWidth - pigWH + pigOffsetX, y: head_height - notiHeight + pigOffsetY - notiOffsetY)
        let rect = CGRect.init(x: (kDeviceWidth / 2) + ((kDeviceWidth - kLeftSpaceS * 2) / 4 - 45), y: head_height - notiOffsetY, width: 90, height: 90)
        self.bgView.drawCircle(rect: rect)
    }
    
    private func location3() {
        notiImgView.image = UIImage.init(named: "o_lead_msg")
        pigImgView.image = UIImage.init(named: "o_pig_left")
        notiImgView.frame.origin = CGPoint.init(x: (kDeviceWidth - notiWidth) / 2, y: kDeviceHeight - 72 - notiOffsetY - notiHeight)
        pigImgView.frame.origin = CGPoint.init(x: (kDeviceWidth - notiWidth) / 2 - pigWH + pigOffsetX, y: kDeviceHeight - notiHeight - 72 - notiOffsetY + pigOffsetY)
        let rect = CGRect.init(x: (kDeviceWidth - 67) / 2, y: kDeviceHeight - 72, width: 67, height: 67)
        self.bgView.drawCircle(rect: rect)
    }
    
    private func location4() {
        notiImgView.image = UIImage.init(named: "o_lead_person")
        pigImgView.image = UIImage.init(named: "o_pig_left")
        notiImgView.frame.origin = CGPoint.init(x: kDeviceWidth - notiWidth - 20, y: kDeviceHeight - 49 - notiHeight - notiOffsetY)
        pigImgView.frame.origin = CGPoint.init(x: kDeviceWidth - notiWidth - 20 - pigWH + pigOffsetX, y: kDeviceHeight - 49 - notiHeight - notiOffsetY + pigOffsetY)
        let rect = CGRect.init(x: kDeviceWidth * 78 / 100, y: kDeviceHeight - 50, width: 40, height: 40)
        self.bgView.drawCircle(rect: rect)
    }
    
    /**
        3/4  == 75/100
        4/5  == 80/100
     **/
    
}
