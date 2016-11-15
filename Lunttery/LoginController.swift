//
//  TestController.swift
//  Lunttery
//
//  Created by Ollie on 2016/11/14.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
// http://103.3.61.129/api/login?access_token=YOUR_FB_TOKEN

class LoginController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let positionX = UIScreen.main.bounds.width * (114/375)
        let positionY = UIScreen.main.bounds.height * (225/667)
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = CGPoint(x: positionX, y: positionY)
        self.view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
