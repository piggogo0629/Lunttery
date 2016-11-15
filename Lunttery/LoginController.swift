//
//  TestController.swift
//  Lunttery
//
//  Created by Ollie on 2016/11/14.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FBSDKCoreKit
import FBSDKLoginKit

class LoginController: UIViewController, FBSDKLoginButtonDelegate {

    //MARK:- Variables
    let myDefaults = UserDefaults.standard
    
    //MARK:- @IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK:- @IBAction
    @IBAction func touchDownToCloseKeyboard(_ sender: UIControl) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func login(_ sender: UIButton) {
        // Validate text
        let emailText = emailTextField.text!
        let passwordText = passwordTextField.text!
        
        var alertMessage = ""
        
        if emailText.isBlank() {
            alertMessage += (alertMessage == "" ? "E-mail尚未輸入唷～" : "\n\nE-mail尚未輸入唷～")
        } else {
            do {
                let mailValid = try emailText.isEmail()
                
                if mailValid == false {
                    alertMessage += (alertMessage == "" ? "E-mail格式輸入有誤唷～" : "\n\nE-mail格式輸入有誤唷～")
                }
            } catch let err as NSError {
                print("===\(err.localizedDescription)===")
            }
        }
        
        if passwordText.isBlank() {
            alertMessage += (alertMessage == "" ? "密碼尚未輸入唷～" : "\n\n密碼尚未輸入唷～")
        }
        
        if alertMessage.isBlank() == false {
            showAlertWithMessage(alertMessage: alertMessage)
        } else {
            // 通過驗證 -> call API 傳送資料 
            /* 呼叫API */
            let loginUrl = "http://103.3.61.129/api/login"
            let paras: Parameters = ["email": emailText, "password": passwordText]
            let loginRequest = request(loginUrl, method: .get, parameters: paras, encoding: URLEncoding.default, headers: nil)
            loginRequest.responseJSON(completionHandler: { (response: DataResponse<Any>) in
                switch response.result {
                case .success(let value):
                    let userData = JSON(value)
                    
                    if userData["message"] == "Ok" {
                        // 更新使用者登入資訊
                        var user_Auth = self.myDefaults.object(forKey: "user_Auth") as! [String: Any]
                        user_Auth["user_id"] = userData["user_id"].intValue
                        user_Auth["auth_token"] = userData["auth_token"].stringValue
                        
                        self.myDefaults.set(user_Auth, forKey: "user_Auth")
                        // 回到主畫面
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.showAlertWithMessage(alertMessage: "登入失敗，請再試一次～")
                    }
                case .failure(let error):
                    self.showAlertWithMessage(alertMessage: "登入失敗，請再試一次～")
                    print("=====\(error.localizedDescription)=====")
                }
            })
        }
    }
    
    //MARK:- Self funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let textForegroundColor = UIColor(red: 124.0/255.0, green: 124.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        // 調整emailTextField border
        emailTextField.attributedPlaceholder = NSAttributedString(string: " E-mail", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        emailTextField.layer.borderColor = textForegroundColor.cgColor
        emailTextField.layer.borderWidth = 1.5
        // 顯示emailTextField rightView
        let emailImageView = UIImageView(image: UIImage(named: "inputmail"))
        emailImageView.frame = CGRect(x: 0.0, y: 0.0, width: (emailImageView.image?.size.width)!, height: (emailImageView.image?.size.height)!)
        emailTextField.rightViewMode = .unlessEditing
        emailTextField.rightView = emailImageView
        // 調整passwordTextField border
        passwordTextField.attributedPlaceholder = NSAttributedString(string: " Password", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        passwordTextField.layer.borderColor = textForegroundColor.cgColor
        passwordTextField.layer.borderWidth = 1.5
        // 顯示passwordTextField rightView
        let passwordImgeView = UIImageView(image: UIImage(named: "lock"))
        passwordImgeView.frame = CGRect(x: 0.0, y: 0.0, width: (passwordImgeView.image?.size.width)!, height: (passwordImgeView.image?.size.height)!)
        passwordTextField.rightViewMode = .unlessEditing
        passwordTextField.rightView = passwordImgeView
        
        
        //let positionX = UIScreen.main.bounds.width * (114/375)
        //let positionY = UIScreen.main.bounds.height * (225/667)
        //let loginButton = FBSDKLoginButton()
        //loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        //loginButton.center = CGPoint(x: positionX, y: positionY)
        //self.view.addSubview(loginButton)
        
        //loginButton.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- FBSDKLoginButtonDelegate Protocol
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("===\(error.localizedDescription)")
            return
        }
        
        if let accessToken = result.token.tokenString {
            let loginUrl = "http://103.3.61.129/api/login"
            let paras: Parameters = ["access_token": accessToken]
            let loginRequest = request(loginUrl, method: .get, parameters: paras, encoding: URLEncoding.default)
            
            loginRequest.responseJSON(completionHandler: { (response: DataResponse<Any>) in
                switch response.result {
                case .success(let value):
                    let returnJSON = JSON(value)
                    print("===return:\(returnJSON)")
                    
                case .failure(let error):
                    //self.showAlertWithMessage(alertMessage: "傳送失敗，請再試一次～")
                    print("=====\(error.localizedDescription)=====")
                }
            })
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("=====DidLogOut")
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        print("=====WillLogin")
        return true
    }
    
    //MARK:- User defined Method
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
