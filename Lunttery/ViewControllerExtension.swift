//
//  UIViewControllerExtension.swift
//  Lunttery
//
//  Created by Ollie on 2016/11/16.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertWithMessage(alertMessage: String) {
        let alert = UIAlertController(title: "Lunttery", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        // 自定義message font size etc.
        let textFont = UIFont(name: ".PingFangTC-Regular", size: 15)
        let attributedStr = NSAttributedString(string: alertMessage, attributes: [NSFontAttributeName: textFont!])
        
        alert.setValue(attributedStr, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "關閉", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func userValidate(userAuth: [String: Any]) -> Bool {
        let authToken = userAuth["auth_token"] as! String
        let userId = userAuth["user_id"] as! Int
        
        if authToken != "" && userId != 0 {
            return true
        } else {
            return false
        }
    }

}
