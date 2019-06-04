//
//  ToastView.swift
//  iOSShowcaseApp
//
//  Created by Umang Davessar on 4/6/19.
//  Copyright © 2019 Umang Davessar. All rights reserved.
//

import Foundation
import UIKit


/*
 
 self.view.makeToast() { didTap in
     if didTap {
         print("completion from tap")
     }
     else {
         print("completion without tap")
     }
 
 */


class ToastView: UIView {
    
    @IBOutlet weak var toastImageView: UIImageView!
    @IBOutlet weak var toastTitleView: UILabel!
    @IBOutlet weak var toastMessageView: UILabel!
    
    class func creatToastViewFromNib() -> ToastView {
        let classBundle = Bundle.init(for: ToastView.classForCoder())
        let toastViewNib = UINib(nibName: "ToastView", bundle: classBundle)
        return toastViewNib.instantiate(withOwner: nil, options: nil)[0] as! ToastView
    }
}
