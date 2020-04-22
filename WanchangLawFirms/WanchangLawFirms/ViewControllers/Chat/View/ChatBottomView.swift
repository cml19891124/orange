//
//  ChatBottomView.swift
//  OLegal
//
//  Created by lh on 2018/11/28.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit

protocol ChatBottomViewDelegate: NSObjectProtocol {
    func chatBottomViewHeightChange(bH: CGFloat, scrollToBottom: Bool)
    func chatBottomViewSendText(text: String)
    func chatBottomViewClick(bind: String)
}

/// 聊天底部视图
class ChatBottomView: UIView {
    
    weak var delegate: ChatBottomViewDelegate?
    private lazy var topV: UIView = {
        () -> UIView in
        let temp = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: 50))
        temp.layer.borderColor = customColor(220, 220, 220).cgColor
        temp.layer.borderWidth = 1
        return temp
    }()
    lazy var tv: JTextView = {
        () -> JTextView in
        let temp = JTextView.init(font: kFontM)
        temp.layer.cornerRadius = kBtnCornerR
        temp.layer.borderWidth = 1
        temp.isScrollEnabled = true
        temp.layer.borderColor = customColor(173, 173, 173).cgColor
        temp.delegate = self
        temp.returnKeyType = .send
        return temp
    }()
    private lazy var emoBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontS, kTextGrayColor, UIControl.ContentHorizontalAlignment.center, self, #selector(btnsClisk(sender:)))
        temp.setImage(UIImage.init(named: "chat_emo"), for: .normal)
        temp.setImage(UIImage.init(named: "chat_keyboard"), for: .selected)
        return temp
    }()
    private lazy var addBtn: UIButton = {
        () -> UIButton in
        let temp = UIButton.init(kFontS, kTextGrayColor, UIControl.ContentHorizontalAlignment.center, self, #selector(btnsClisk(sender:)))
        temp.setImage(UIImage.init(named: "chat_add"), for: .normal)
        temp.setImage(UIImage.init(named: "chat_keyboard"), for: .selected)
        return temp
    }()
    private let emoHeight: CGFloat = (kDeviceWidth - 50) / 4 * 2 + 30
    private lazy var emoView: ChatEmoView = {
        () -> ChatEmoView in
        let temp = ChatEmoView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: emoHeight))
        temp.delegate = self
        self.addSubview(temp)
        _ = temp.sd_layout()?.leftEqualToView(self)?.rightEqualToView(self)?.bottomSpaceToView(self, kXBottomHeight)?.topSpaceToView(topV, 0)
        return temp
    }()
    private let funcHeight: CGFloat = (kDeviceWidth - 50) / 4 + 20
    private lazy var funcView: ChatFuncView = {
        () -> ChatFuncView in
        let temp = ChatFuncView.init(frame: CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: funcHeight))
        temp.delegate = self
        self.addSubview(temp)
        _ = temp.sd_layout()?.leftEqualToView(self)?.rightEqualToView(self)?.bottomSpaceToView(self, kXBottomHeight)?.topSpaceToView(topV, 0)
        return temp
    }()
    private lazy var panHangupGes: DirectionPanGestureRecognizer = {
        () -> DirectionPanGestureRecognizer in
        let temp = DirectionPanGestureRecognizer.init(target: self, action: #selector(hangupKeyboard))
        temp.direction = DirectionPanGestureRecognizerDrag
        return temp
    }()
    private var isEmoClick: Bool = false
    private var isCellClick: Bool = false
    
    var input_text: String = "" {
        didSet {
            self.tv.text = input_text
            self.mTextChange()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kBaseColor
        self.setupViews()
        JKeyboardNotiManager.share.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(hangupKeyboard), name: NSNotification.Name(rawValue: noti_chat_hangeup_keyboard), object: nil)
        self.addGestureRecognizer(panHangupGes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(topV)
        topV.addSubview(tv)
        topV.addSubview(emoBtn)
        topV.addSubview(addBtn)
        
        _ = tv.sd_layout()?.leftSpaceToView(topV, 10)?.topSpaceToView(topV, 7)?.bottomSpaceToView(topV, 7)?.rightSpaceToView(topV, 80)
        _ = addBtn.sd_layout()?.bottomSpaceToView(topV, 10)?.rightSpaceToView(topV, 7)?.widthIs(30)?.heightIs(30)
        _ = emoBtn.sd_layout()?.bottomSpaceToView(topV, 10)?.rightSpaceToView(addBtn, 5)?.widthIs(30)?.heightIs(30)
    }
    
    @objc func hangupKeyboard() {
        if tv.isFirstResponder {
            isCellClick = true
            self.tv.resignFirstResponder()
            isCellClick = false
        } else {
            let resultH = self.topV.height + kXBottomHeight
            self.heightChange(bH: resultH, scrollToBottom: false)
            UIView.animate(withDuration: 0.25, animations: {
                self.frame = CGRect.init(x: 0, y: kDeviceHeight - resultH, width: kDeviceWidth, height: resultH)
            }) { (flag) in
                self.funcView.isHidden = true
                self.emoView.isHidden = true
                self.emoBtn.isSelected = false
                self.addBtn.isSelected = false
            }
        }
    }
    
    @objc private func btnsClisk(sender: UIButton) {
        if sender.isEqual(emoBtn) {
            emoBtn.isSelected = !emoBtn.isSelected
            if emoBtn.isSelected {
                addBtn.isSelected = false
                isEmoClick = true
                tv.resignFirstResponder()
                isEmoClick = false
                self.funcView.isHidden = true
                self.emoView.isHidden = false
                let resultH = self.topV.height + self.emoHeight + 30 + kXBottomHeight
                self.heightChange(bH: resultH, scrollToBottom: true)
                UIView.animate(withDuration: 0.25) {
                    self.frame = CGRect.init(x: 0, y: kDeviceHeight - resultH, width: kDeviceWidth, height: resultH)
                }
            } else {
                tv.becomeFirstResponder()
            }
        } else if sender.isEqual(addBtn) {
            addBtn.isSelected = !addBtn.isSelected
            if addBtn.isSelected {
                emoBtn.isSelected = false
                isEmoClick = true
                tv.resignFirstResponder()
                isEmoClick = false
                self.emoView.isHidden = true
                self.funcView.isHidden = false
                let resultH = self.topV.height + self.funcHeight + 30 + kXBottomHeight
                self.heightChange(bH: resultH, scrollToBottom: true)
                UIView.animate(withDuration: 0.25) {
                    self.frame = CGRect.init(x: 0, y: kDeviceHeight - resultH, width: kDeviceWidth, height: resultH)
                }
            } else {
                tv.becomeFirstResponder()
            }
        }
    }

}

extension ChatBottomView: ChatFuncViewDelegate {
    func chatFuncViewClick(bind: String) {
        self.delegate?.chatBottomViewClick(bind: bind)
    }
}

extension ChatBottomView: ChatEmoViewDelegate {
    func chatEmoViewClick(bind: String) {
        self.delegate?.chatBottomViewClick(bind: bind)
    }
}

extension ChatBottomView: JKeyboardNotiManagerDelegate {
    func jkeyboardHeightChange(kH: CGFloat, duration: Double) {
        let resultH = kH + self.topV.height
        self.heightChange(bH: resultH, scrollToBottom: !isCellClick)
        UIView.animate(withDuration: duration) {
            self.frame = CGRect.init(x: 0, y: kDeviceHeight - resultH, width: kDeviceWidth, height: resultH)
        }
    }
    
    func jkeyboardWillHide(kH: CGFloat, duration: Double) {
        if !isEmoClick {
            let resultH = self.topV.height + kXBottomHeight
            self.heightChange(bH: resultH, scrollToBottom: !isCellClick)
            UIView.animate(withDuration: duration) {
                self.frame = CGRect.init(x: 0, y: kDeviceHeight - resultH, width: kDeviceWidth, height: resultH)
            }
            emoBtn.isSelected = false
            addBtn.isSelected = false
            emoView.isHidden = true
            funcView.isHidden = true
        }
    }
}

extension ChatBottomView: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.emoBtn.isSelected = false
        self.addBtn.isSelected = false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if textView.text.haveTextStr() {
                if textView.text.count > 2000 {
                    PromptTool.promptText(L$("limit_chat_content_max"), 1)
                    return false
                }
                self.delegate?.chatBottomViewSendText(text: textView.text)
                textView.text = ""
                self.mTextChange()
            } else {
                textView.resignFirstResponder()
            }
            return false
        }
        if text == "" {
            return true
        }
        if textView.text.count > 2000 {
            PromptTool.promptText(L$("limit_chat_content_max"), 1)
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.mTextChange()
    }
    
    func mTextChange() {
        var tempH = self.tv.sizeThatFits(CGSize.init(width: kDeviceWidth - 90, height: CGFloat(MAXFLOAT))).height
        if tempH < 36 {
            tempH = 36
        } else if tempH > 100 {
            tempH = 100
        }
        let currentTopH = tempH + 14
        let lastTopH = self.topV.height
        let del = currentTopH - lastTopH
        let ori = self.frame.origin
        let siz = self.frame.size
        
        
        self.topV.frame = CGRect.init(x: 0, y: 0, width: kDeviceWidth, height: currentTopH)
        self.frame = CGRect.init(x: 0, y: ori.y - del, width: kDeviceWidth, height: siz.height + del)
        
        self.heightChange(bH: siz.height + del, scrollToBottom: true)
        
        if tempH == 100 {
            self.perform(#selector(tvScrollToVisible), with: nil, afterDelay: 0)
        } else {
            self.tv.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: kDeviceWidth - 90, height: currentTopH - 14), animated: false)
        }
        

    }
    
    @objc private func tvScrollToVisible() {
        let tempStr = tv.text
        tv.text = ""
        tv.text = tempStr
        guard let start = tv.selectedTextRange?.start else {
            return
        }
        guard let end = tv.selectedTextRange?.end else {
            return
        }
        let a = tv.offset(from: tv.beginningOfDocument, to: start)
        let b = tv.offset(from: tv.beginningOfDocument, to: end)
        self.tv.scrollRangeToVisible(NSRange.init(location: a, length: b - a))
    }
    
    private func heightChange(bH: CGFloat, scrollToBottom: Bool) {
        self.delegate?.chatBottomViewHeightChange(bH: bH, scrollToBottom: scrollToBottom)
    }
}
