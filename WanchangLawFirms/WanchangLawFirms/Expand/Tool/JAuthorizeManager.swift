//
//  JAuthorizeManager.swift
//  OLegal
//
//  Created by lh on 2018/11/22.
//  Copyright © 2018 gaming17. All rights reserved.
//

import UIKit
import Photos
import Contacts

/// 授权管理
class JAuthorizeManager: NSObject {
    var view: UIView?
    
    convenience init(view: UIView) {
        self.init()
        self.view = view
    }
    
    func responseChainViewController() -> UIViewController {
        var vc = UIViewController()
        var responder: UIResponder? = view?.next
        while responder != nil {
            if (responder?.isKind(of: UIViewController.self)) == true {
                vc = responder as! UIViewController
                break
            }
            responder = responder?.next
        }
        return vc
    }

}

extension JAuthorizeManager {
    /// 授权相机
    func cameraAuthorization(success:@escaping() -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted {
                    JQueueManager.share.mainAsyncQueue {
                        success()
                    }
                }
            }
        } else if status == .authorized {
            success()
        } else {
            let alertCon = UIAlertController.init(title: L$("application_cannot_camera"), message: L$("camera_ask_set"), preferredStyle: .alert)
            let actionSure = UIAlertAction.init(title: L$("go_to_set"), style: .default) { (action) in
                let url = URL.init(string: UIApplication.openSettingsURLString)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url!)
                }
            }
            let actionCancel = UIAlertAction.init(title: L$("cancel"), style: .cancel, handler: nil)
            alertCon.addAction(actionSure)
            alertCon.addAction(actionCancel)
            self.responseChainViewController().present(alertCon, animated: true, completion: nil)
        }
    }
    
    /// 授权相册
    func photoLibraryAuthorization(success:@escaping() -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (result) in
                if result == .authorized {
                    JQueueManager.share.mainAsyncQueue {
                        success()
                    }
                }
            }
        } else if status == .authorized {
            success()
        } else {
            let alertCon = UIAlertController.init(title: L$("application_cannot_album"), message: L$("album_ask_set"), preferredStyle: .alert)
            let actionSure = UIAlertAction.init(title: L$("go_to_set"), style: .default) { (action) in
                let url = URL.init(string: UIApplication.openSettingsURLString)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url!)
                }
            }
            let actionCancel = UIAlertAction.init(title: L$("cancel"), style: .cancel, handler: nil)
            alertCon.addAction(actionSure)
            alertCon.addAction(actionCancel)
            self.responseChainViewController().present(alertCon, animated: true, completion: nil)
        }
    }
    
    /// 授权麦克风
    func microphoneAuthorization(success:@escaping() -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .audio) { (granted) in
                if granted {
                    JQueueManager.share.mainAsyncQueue {
                        success()
                    }
                }
            }
        } else if status == .authorized {
            success()
        } else {
            let alertCon = UIAlertController.init(title: L$("application_cannot_micro"), message: L$("micro_set"), preferredStyle: .alert)
            let actionSure = UIAlertAction.init(title: L$("go_to_set"), style: .default) { (action) in
                let url = URL.init(string: UIApplication.openSettingsURLString)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url!)
                }
            }
            let actionCancel = UIAlertAction.init(title: L$("cancel"), style: .cancel, handler: nil)
            alertCon.addAction(actionSure)
            alertCon.addAction(actionCancel)
            self.responseChainViewController().present(alertCon, animated: true, completion: nil)
        }
    }
    
    /// 授权通讯录
    func addressBookAuthorization(success:@escaping() -> Void) {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .notDetermined {
            CNContactStore().requestAccess(for: .contacts) { (flag, error) in
                if flag {
                    JQueueManager.share.mainAsyncQueue {
                        success()
                    }
                }
            }
        } else if status == .authorized {
            success()
        } else {
            let alertCon = UIAlertController.init(title: L$("application_ask_contacts"), message: L$("contacts_ask_set"), preferredStyle: .alert)
            let actionSure = UIAlertAction.init(title: L$("go_to_set"), style: .default) { (action) in
                let url = URL.init(string: UIApplication.openSettingsURLString)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url!)
                }
            }
            let actionCancel = UIAlertAction.init(title: L$("cancel"), style: .cancel, handler: nil)
            alertCon.addAction(actionSure)
            alertCon.addAction(actionCancel)
            self.responseChainViewController().present(alertCon, animated: true, completion: nil)
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

extension JAuthorizeManager {
    func alertController(style: UIAlertController.Style, titleStr: String?, message: String?, sure: String?, cancel: String?, sureHandler:((UIAlertAction) -> Void)?, cancelHandler:((UIAlertAction) -> Void)?) {
        let alertCon = UIAlertController.init(title: titleStr, message: message, preferredStyle: style)
        if sure != nil {
            let actionSure = UIAlertAction.init(title: sure, style: .default) { (action) in
                if sureHandler != nil {
                    sureHandler!(action)
                }
            }
            alertCon.addAction(actionSure)
        }
        if cancel != nil {
            let actionCancel = UIAlertAction.init(title: cancel, style: .cancel) { (action) in
                if cancelHandler != nil {
                    cancelHandler!(action)
                }
            }
            alertCon.addAction(actionCancel)
        }
        self.responseChainViewController().present(alertCon, animated: true, completion: nil)
    }
}

extension JAuthorizeManager {
    /// 相机、相册选择
    func alertCameraAlbum(titleStr: String?, allowsEditing: Bool, addDelegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?) {
        let alertCon = UIAlertController.init(title: titleStr, message: nil, preferredStyle: .actionSheet)
        let actionCamera = UIAlertAction.init(title: L$("camera"), style: .default) { (action) in
            self.cameraAuthorization {
                let picker = UIImagePickerController.init(sourceType: .camera, mediaType: 1, allowsEditing: allowsEditing)
                picker.delegate = addDelegate
                self.responseChainViewController().present(picker, animated: true, completion: nil)
            }
        }
        let actionAlbum = UIAlertAction.init(title: L$("album"), style: .default) { (action) in
            self.photoLibraryAuthorization {
                let picker = UIImagePickerController.init(sourceType: .photoLibrary, mediaType: 1, allowsEditing: allowsEditing)
                picker.delegate = addDelegate
                self.responseChainViewController().present(picker, animated: true, completion: nil)
            }
        }
        let actionCancel = UIAlertAction.init(title: L$("cancel"), style: .cancel, handler: nil)
        alertCon.addAction(actionCamera)
        alertCon.addAction(actionAlbum)
        alertCon.addAction(actionCancel)
        self.responseChainViewController().present(alertCon, animated: true, completion: nil)
    }
}
