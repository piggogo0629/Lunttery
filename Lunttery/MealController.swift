//
//  MealController.swift
//  Lunttery
//
//  Created by Ollie on 2016/11/14.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage

class MealController: UIViewController {
    
    //MARK:- Variables
    var queryResult: JSON?
    var resultArray: [JSON]!
    var currentJSONData: JSON!
    let myDefaults = UserDefaults.standard
    var myUserAuth: [String: Any]!
    
    //MARK:- @IBOutlet
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var kcalLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dinnerNameLabel: UILabel!
    @IBOutlet weak var dinnerPhoneLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var menuBookButton: UIButton!
    
    //MARK:- @IBAction
    @IBAction func addToMyFavorite(_ sender: UIButton) {
        if self.userValidate(userAuth: myUserAuth) == true {
            let myUserId = myUserAuth["user_id"] as! Int
            let myMealId = currentJSONData.dictionaryValue["id"]?.intValue
            
            let updateLikeUrl = ""
            let paras: Parameters = ["user_id": myUserId, "id": myMealId!]
            
            let updateLikeRequest = request(updateLikeUrl, method: .post, parameters: paras, encoding: URLEncoding.default, headers: nil)
            updateLikeRequest.responseJSON(completionHandler: { (response: DataResponse<Any>) in
                switch response.result {
                case .success(let value):
                    let userData = JSON(value)
                    
//                    if userData["message"] == "Ok" {
//                        // 更新使用者登入資訊
//                        var user_Auth = self.myDefaults.object(forKey: "user_Auth") as! [String: Any]
//                        user_Auth["user_id"] = userData["user_id"].intValue
//                        user_Auth["auth_token"] = userData["auth_token"].stringValue
//                        
//                        self.myDefaults.set(user_Auth, forKey: "user_Auth")
//                        // 回到主畫面
//                        self.dismiss(animated: true, completion: nil)
//                    } else {
//                        self.showAlertWithMessage(alertMessage: "新增最愛失敗，請再試一次～")
//                    }
                case .failure(let error):
                    self.showAlertWithMessage(alertMessage: "新增最愛失敗，請再試一次～")
                    print("=====\(error.localizedDescription)=====")
                }
            })
        } else {
            // 顯示登入畫面
            let loginController = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            self.present(loginController, animated: true, completion: { 
                print("===userAuth:\(self.myUserAuth)")
            })
        }
    }
    
    //MARK:- Self func
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            self.revealViewController().rightViewRevealWidth = 200
            
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back(sender:)))
        newBackButton.image = UIImage(named: "reply")
        self.navigationItem.leftBarButtonItem = newBackButton
        
        // 調整EdgeInsets，讓button呈現圖片在上文字在下的效果
        ratingButton.imageEdgeInsets = UIEdgeInsetsMake(-(ratingButton.titleLabel?.intrinsicContentSize.height)!, 0, 0, -(ratingButton.titleLabel?.intrinsicContentSize.width)!)
        ratingButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(ratingButton.imageView?.frame.width)!, -(ratingButton.imageView?.frame.height)!, 0)
        menuBookButton.imageEdgeInsets = UIEdgeInsetsMake(-(menuBookButton.titleLabel?.intrinsicContentSize.height)!, 0, 0, -(menuBookButton.titleLabel?.intrinsicContentSize.width)!)
        menuBookButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(menuBookButton.imageView?.frame.width)!, -(menuBookButton.imageView?.frame.height)!, 0)
        
        // 讀取使用者登入資訊
        if myDefaults.object(forKey: "user_Auth") != nil {
            myUserAuth = myDefaults.object(forKey: "user_Auth") as! [String : Any]
        }

        // 資料處理
        if let data = queryResult?["data"].array {
            resultArray = data
        }
        // 當前畫面的資料
        currentJSONData = resultArray[0]
        // 畫面載入時顯示第一筆
        viewDisplay(data: resultArray[0])
        
        print("\(currentJSONData)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 讀取使用者登入資訊
        if myDefaults.object(forKey: "user_Auth") != nil {
            myUserAuth = myDefaults.object(forKey: "user_Auth") as! [String : Any]
        }
    }
    
    //MARK: - User Defined Method
    func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // Go back to the previous ViewController
        let frontViewController = navigationController?.childViewControllers[0] as! FrontViewController
        frontViewController.resetViewDisplay()
        let _ = self.navigationController?.popToViewController(frontViewController, animated: true)
    }

    func viewDisplay(data: JSON) {
        // 餐點資訊
        let BasedUrl = "http://103.3.61.129"
        let defaultImage = (UIImage(named: "defaultImage"))!
        if let imageUrlArray = data.dictionaryValue["photos_urls"]?.array {
            if imageUrlArray.count > 0 {
                let fullUrlString = BasedUrl + imageUrlArray[0].stringValue
                let fullUrl = URL(string: fullUrlString)
                mealImageView.sd_setImage(with: fullUrl, placeholderImage: defaultImage)
            } else {
                mealImageView.image = defaultImage
            }
        }
        
        if let mealName = data.dictionaryValue["name"]?.string {
            mealNameLabel.text = mealName
        }
        if let price = data.dictionaryValue["price"]?.int {
            priceLabel.text = String(price)
        }
        if let kcal = data.dictionaryValue["carories"]?.int {
            kcalLabel.text = "\(String(kcal)) kcal"
        }
        if let liked_count = data.dictionaryValue["liked_counts"]?.int {
            likeCountLabel.text = String(liked_count)
        }
        // 餐廳資訊
        let dinner = data.dictionaryValue["dinner"]?.dictionaryValue
        if let dinnerName = dinner?["name"]?.string {
            dinnerNameLabel.text = dinnerName
        }
        if let dinnerPhone = dinner?["phone_number"]?.string {
            dinnerPhoneLabel.text = dinnerPhone
        }
        if let distance = data.dictionaryValue["distance"]?.double {
            let approximatelyNum = NSNumber(value: distance * 15.0) // 以1公里15分鐘來計算
            let approximatelyDist = NumberFormatter.localizedString(from: approximatelyNum, number: .none)
            
            distanceLabel.text = "路程約 \(approximatelyDist) min"
        }
        // 我的最愛按鈕顯示
        if self.userValidate(userAuth: myUserAuth) == true {
            if let isLike = data["liked"].bool {
                if isLike == true {
                    likeButton.imageView?.image = UIImage(named: "dislike")
                } else {
                    likeButton.imageView?.image = UIImage(named: "like")
                }
            }
        } else {
            likeButton.imageView?.image = UIImage(named: "dislike")
        }
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
