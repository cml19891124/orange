//
//  JFilePickerController.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/3/24.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class JFilePickerController: UIDocumentPickerViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let bar = UINavigationBar.appearance()
        bar.tintColor = kTextBlackColor
        bar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : kTextBlackColor, NSAttributedString.Key.font: kFontL]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : kTextBlackColor, NSAttributedString.Key.font: kFontMS], for: UIControl.State.normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let bar = UINavigationBar.appearance()
        bar.tintColor = UIColor.white
        bar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: kFontL]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: kFontMS], for: UIControl.State.normal)
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
