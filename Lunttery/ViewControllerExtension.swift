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

    func showActivityIndicator(with targetView: UIView) -> UIView {
        let container: UIView = UIView()
        container.frame = targetView.frame
        container.center = targetView.center
        container.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = targetView.center
        loadingView.backgroundColor = UIColor(red: 68.0/255.0, green: 68.0/255.0, blue: 68.0/255.0, alpha: 0.8)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        targetView.addSubview(container)
        activityIndicator.startAnimating()
        
        return container
    }
}
