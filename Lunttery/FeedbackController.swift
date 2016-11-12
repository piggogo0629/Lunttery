//
//  MailController.swift
//  Lunttery
//
//  Created by Ollie on 2016/11/7.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FeedbackController: UIViewController, UITextViewDelegate {
    // How to make UITextView With placeholder Text? -> https://grokswift.com/uitextview-placeholder/
    
    // MARK:- Variables
    let placeholderText = "Say Something"
    
    // MARK:- @IBOutlets
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var InfoLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var successImageView: UIImageView!
    @IBOutlet weak var successLabel: UILabel!
    
    // MARK:- @IBActions
    @IBAction func touchDownToCloseKeyboard(_ sender: UIControl) {
        // 點擊空白區域時，鍵盤自動隱藏 -> http://devonios.com/ios-hide-keykeyboard.html
        // 一般此空白區域就是一個UIView，要讓UIView響應點擊（tap）事件，但是要知道響應事件是UIControl的事情，所以我们需要把UIView的class改成UIControl，因为UIControl是UIView的子類別，所以完全可行！那麼這個View就能像UIControl那些元件一樣接收點擊事件了
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        feedbackTextView.resignFirstResponder()
    }
    
    @IBAction func sendFeedback(_ sender: UIButton) {
        // Validate text
        let nameText = nameTextField.text!
        let emailText = emailTextField.text!
        let feedbackText = feedbackTextView.text!
        
        var alertMessage = ""
        
        if nameText.isBlank() {
            alertMessage += "\nName尚未輸入唷～"
        }
        
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
        
        if feedbackText == placeholderText {
            alertMessage += (alertMessage == "" ? "意見回饋尚未輸入唷～" : "\n\n意見回饋尚未輸入唷～")
        }

        if alertMessage.isBlank() == false {
            showAlertWithMessage(alertMessage: alertMessage)
        } else {
            // 通過驗證 -> call API 傳送資料 ＆ 顯示成功圖片及文字
            /* 呼叫API */
            //let feedbackUrl = ""
            //let paras: Parameters = ["name": "", "email": "", "content": ""]
            //let feedbackRequest = request(feedbackUrl, method: .post, parameters: paras, encoding: URLEncoding.default)
            //feedbackRequest.responseJSON(completionHandler: { (response: DataResponse<Any>) in
                //switch response.result {
                //case .success(let value):
                    //let returnJSON = JSON(value)
                    
                    self.InfoLabel.isHidden = true
                    self.nameTextField.isHidden = true
                    self.emailTextField.isHidden = true
                    self.feedbackTextView.isHidden = true
                    self.sendButton.isHidden = true
                    
                    self.successImageView.isHidden = false
                    self.successLabel.isHidden = false
                    
                    self.closeButton.setTitleColor(UIColor.white, for: .normal)
                    self.closeButton.titleLabel?.font = UIFont(name: ".PingFangTC-Medium", size: 24)
                    self.closeButton.backgroundColor = UIColor(red: 255.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
                
                //case .failure(let error):
                    //self.showAlertWithMessage(alertMessage: "傳送失敗，請再試一次～")
                    //print("=====\(error.localizedDescription)=====")
                //}
            //})
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        if self.revealViewController() != nil {
            self.revealViewController().performSegue(withIdentifier: "sw_front", sender: nil)
        }
    }
    
    // MARK:- Controller Funcs
    deinit {
         print("=====FeedbackController deinit=====")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            self.revealViewController().rightViewRevealWidth = 200
            
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // 修改導覽列文字的顏色，字型
        let textForegroundColor = UIColor(red: 124.0/255.0, green: 124.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        //let textFont = UIFont.systemFont(ofSize: 30, weight: UIFontWeightSemibold)
        let textFont = UIFont(name: ".PingFangTC-Semibold", size: 30)
        let textArttribute = [NSForegroundColorAttributeName: textForegroundColor, NSFontAttributeName: textFont]
        self.navigationController?.navigationBar.titleTextAttributes = textArttribute
        
        // 調整nameTextField border
        nameTextField.attributedPlaceholder = NSAttributedString(string: " Name", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        nameTextField.layer.borderColor = textForegroundColor.cgColor
        nameTextField.layer.borderWidth = 1.5
        // 顯示nameTextField rightView
        let userImageView = UIImageView(image: UIImage(named: "user"))
        userImageView.frame = CGRect(x: 0.0, y: 0.0, width: (userImageView.image?.size.width)!, height: (userImageView.image?.size.height)!)
        nameTextField.rightViewMode = .unlessEditing
        nameTextField.rightView = userImageView
        // 調整emailTextField border
        emailTextField.attributedPlaceholder = NSAttributedString(string: " E-mail", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        emailTextField.layer.borderColor = textForegroundColor.cgColor
        emailTextField.layer.borderWidth = 1.5
        // 顯示emailTextField rightView
        let emailImgeView = UIImageView(image: UIImage(named: "inputmail"))
        emailImgeView.frame = CGRect(x: 0.0, y: 0.0, width: (emailImgeView.image?.size.width)!, height: (emailImgeView.image?.size.height)!)
        emailTextField.rightViewMode = .unlessEditing
        emailTextField.rightView = emailImgeView
        
        feedbackTextView.layer.borderColor = textForegroundColor.cgColor
        feedbackTextView.layer.borderWidth = 1.5
        
        feedbackTextView.delegate = self
        applyPlaceholderStyle(textView: feedbackTextView, placeholderText: placeholderText)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UITextViewDelegate Method
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == feedbackTextView && textView.text == placeholderText {
            // move cursor to start
            moveCursorToStart(textView: textView)
        }
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // remove the placeholder text when they start typing
        // first, see if the field is empty
        //  if it's not empty, then the text should be black and not italic
        //  BUT, we also need to remove the placeholder text if that's the only text
        //  if it is empty, then the text should be the placeholder
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        
        // have text, so don't show the placeholder
        if newLength > 0 {
            // check if the only text is the placeholder and remove it if needed
            // unless they've hit the delete button with the placeholder displayed
            if textView == feedbackTextView && textView.text == placeholderText {
                // they hit the back button
                if text.utf16.count == 0 {
                    // ignore it
                    return false
                }
                
                applyNonPlaceholderStyle(textView: textView)
                textView.text = ""
            }
            
            return true
        } else {
            // no text, so show the placeholder
            applyPlaceholderStyle(textView: textView, placeholderText: placeholderText)
            moveCursorToStart(textView: textView)
            
            return false
        }
    }
    
    // MARK:- User Defined Method
    func applyPlaceholderStyle(textView: UITextView, placeholderText: String) {
        // make it look (initially) like a placeholder
        feedbackTextView.textColor = UIColor.lightGray
        feedbackTextView.text = placeholderText
    }
    
    func applyNonPlaceholderStyle(textView: UITextView) {
        // make it look like normal text instead of a placeholder
        feedbackTextView.textColor = UIColor.darkText
        feedbackTextView.alpha = 1
    }
    
    func moveCursorToStart(textView: UITextView) {
        DispatchQueue.main.async {
            textView.selectedRange = NSRange(location: 0, length: 0)
        }
    }
    
    func showAlertWithMessage(alertMessage: String){
        let alert = UIAlertController(title: "Lunttery", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        // 自定義message font size etc.
        let textFont = UIFont(name: ".PingFangTC-Regular", size: 15)
        let attributedStr = NSAttributedString(string: alertMessage, attributes: [NSFontAttributeName: textFont!])
        
        alert.setValue(attributedStr, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "關閉", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    //}
}
