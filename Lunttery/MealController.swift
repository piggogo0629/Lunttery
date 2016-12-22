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
    var queryResult: JSON?      //查詢結果
    var mealDataArray: [JSON]!  //查詢結果的餐點資料陣列
    var currentMealData: JSON!  //當前畫面顯示的餐點資料
    var menuDataArray: [JSON]!
    let myDefaults = UserDefaults.standard
    var myUserAuth: [String: Any]!
    var myTapCount = 1
    
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
    @IBOutlet weak var playDiceButton: UIButton!
    @IBOutlet weak var openQRCodeButton: UIButton!
    
    
    //MARK:- @IBAction
    @IBAction func playDice(_ sender: UIButton) {
        if mealDataArray.count == 1 || (mealDataArray.count - myTapCount) == 0 {
            return
        }
        
        currentMealData = mealDataArray[mealDataArray.count - myTapCount]
        viewDisplay(data: mealDataArray[mealDataArray.count - myTapCount])
        
        myTapCount += 1
        //sender.setTitle("再一次(\(mealDataArray.count - myTapCount))", for: .normal)
    }
    
    @IBAction func addToMyFavorite(_ sender: UIButton) {
        if self.userValidate(userAuth: myUserAuth) == true {
            let myUserId = myUserAuth["user_id"] as! Int
            let myMealId = currentMealData.dictionaryValue["id"]?.intValue
            
            // http://103.3.61.129/api/meals/MEAL_ID/user_meal_likeships/USER_ID/edit
            let updateLikeUrl = "http://103.3.61.129/api/meals/\(myMealId!)/user_meal_likeships/\(myUserId)/edit"
            
            let updateLikeRequest = request(updateLikeUrl, method: .get, headers: nil)
            updateLikeRequest.responseJSON(completionHandler: { (response: DataResponse<Any>) in
                switch response.result {
                case .success(let value):
                    let userLikeData = JSON(value)
                    //print("\(userLikeData)")
                    if userLikeData["data"] == "User like meal" {
                        // 更新畫面顯示
                        self.likeButton.setImage(UIImage(named: "like"), for: UIControlState.normal)
                        self.likeCountLabel.text = String(userLikeData["liked_counts"].intValue)
                    } else {
                         self.likeButton.setImage(UIImage(named: "dislike"), for: UIControlState.normal)
                        self.likeCountLabel.text = String(userLikeData["liked_counts"].intValue)
                    }
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
    
    @IBAction func goToMenu(_ sender: UIButton) {
        /* 呼叫API讀取餐廳菜單資料 */
        // http://103.3.61.129/api/dinners?id=29&auth_token=
        
        let dinnerId = currentMealData["dinner"].dictionaryValue["id"]?.intValue
        let authToken = myUserAuth["auth_token"] as! String
        
        let menulUrl = "http://103.3.61.129/api/dinners"
        let paras: Parameters = ["id": dinnerId!, "auth_token": authToken]
        let menuRequert = request(menulUrl, method: .get, parameters: paras, encoding: URLEncoding.default, headers: nil)
        
        menuRequert.responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success(let value):
                let menuData = JSON(value)
                self.menuDataArray = menuData["data"].arrayValue
                
                self.performSegue(withIdentifier: "meal_to_menu", sender: nil)
            case .failure(let error):
                self.showAlertWithMessage(alertMessage: "讀取資料失敗，請再試一次～")
                print("=====\(error.localizedDescription)=====")
                return
            }
        }
    }
    
    @IBAction func showMap(_ sender: UIButton) {
        let mapController = self.storyboard?.instantiateViewController(withIdentifier: "MapController") as! MapController
        mapController.dinnerData = currentMealData["dinner"]
        
        self.present(mapController, animated: true, completion: nil)
    }
    
    @IBAction func openQRCode(_ sender: UIButton) {
        let qrCodeReaderController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QRCodeReaderController")
        
        self.revealViewController().pushFrontViewController(qrCodeReaderController, animated: true)
    }

    //MARK:- Self func
    deinit {
        print("=====MealController deinit=====")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            self.revealViewController().rightViewRevealWidth = 200
            
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            // Simply ease out. No Spring animation.
            self.revealViewController().toggleAnimationType = SWRevealToggleAnimationType.easeOut
            // slide animation time
            //self.revealViewController().toggleAnimationDuration = 0.3;
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        /* 自定義返回動作
        let newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back(sender:)))
        newBackButton.image = UIImage(named: "reply")
        self.navigationItem.leftBarButtonItem = newBackButton
        */
 
        // 修改導覽列文字的顏色，字型
        let textForegroundColor = UIColor(red: 255.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        //let textFont = UIFont.systemFont(ofSize: 30, weight: UIFontWeightSemibold)
        let textFont = UIFont(name: ".PingFangTC-Semibold", size: 30)
        let textArttribute = [NSForegroundColorAttributeName: textForegroundColor, NSFontAttributeName: textFont]
        self.navigationController?.navigationBar.titleTextAttributes = textArttribute
        
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
            mealDataArray = data
            
            //playDiceButton.setTitle("再一次(\(mealDataArray.count-1))", for: .normal)
        }
        
        if let isFind = queryResult?["is_find"].boolValue {
            if isFind == false {
                self.showAlertWithMessage(alertMessage: "很抱歉，Lunttery暫無合適資料提供給您！\n將以隨機資料替代")
            }
        }
        
        // 當前畫面的資料
        currentMealData = mealDataArray[0]
        // 畫面載入時顯示第一筆
        viewDisplay(data: mealDataArray[0])
        
        //print("\(mealDataArray)")
        //print("\(mealDataArray[0].dictionaryObject)")
        
        let dicObj = mealDataArray[0].dictionaryObject!
        
        let dicJSON = JSON([dicObj])
        
        print("===dicJSON:\(dicJSON)")
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
        //frontViewController.resetViewDisplay()
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
            mealNameLabel.text = "\(mealName)"
        }
        if let price = data.dictionaryValue["price"]?.int {
            priceLabel.text = "\(String(price))元"
        }
        if let kcal = data.dictionaryValue["carories"]?.int {
            kcalLabel.text = "\(String(kcal)) kcal"
        }
        if let liked_count = data.dictionaryValue["liked_counts"]?.int {
            likeCountLabel.text = String(liked_count)
        }
        // 餐廳資訊
        let dinner = data.dictionaryValue["dinner"]?.dictionaryValue
        if let onSale = dinner?["onsale"]?.boolValue {
            if onSale == true {
                openQRCodeButton.isHidden = false
            } else {
                openQRCodeButton.isHidden = true
            }
        }
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
        // 我的最愛按鈕顯示 & 數字
        if self.userValidate(userAuth: myUserAuth) == true {
            if let isLike = data["liked"].bool {
                if isLike == true {
                    likeButton.setImage(UIImage(named: "like"), for: UIControlState.normal)
                } else {
                    likeButton.setImage(UIImage(named: "dislike"), for: UIControlState.normal)
                }
            }
        } else {
            likeButton.setImage(UIImage(named: "dislike"), for: UIControlState.normal)
        }
        
        // 將顯示的資料儲存 -> 歷程紀錄使用
        
    }
    
    func saveToUserRecord(mealData: JSON) {
        let mealDicObj = mealData.dictionaryObject!
        let mealId = mealData["id"].intValue
        
        var recordArray: [[String:Any]]
        
        if myDefaults.object(forKey: "UserRecord") != nil {
            recordArray = myDefaults.object(forKey: "UserRecord") as! [[String : Any]]
        } else {
            recordArray = [[String:Any]]()
        }
        
        // 判斷是否已存在於recordArray中
        for i in 0...recordArray.count - 1 {
            let eachId = recordArray[i]["id"] as! Int
            
            if mealId == eachId {
                // 移動該meal Data到最後一個
               recordArray = rearrange(array: recordArray, fromIndex: i, toIndex: recordArray.count - 1)
            }  else {
                // 新增
                recordArray.append(mealDicObj)
            }
        }
        
        // recordArray數量最多固定為10個
        if recordArray.count > 10 {
            for i in 0...recordArray.count - 11 {
                recordArray.remove(at: i)
            }
        }
        
        // 儲存到UserDefaults
        self.myDefaults.set(recordArray, forKey: "UserRecord")
    }
    
    func rearrange<T>(array: Array<T>, fromIndex: Int, toIndex: Int) -> Array<T> {
        var myArray = array
        let element = myArray.remove(at: fromIndex)
        myArray.insert(element, at: toIndex)
        
        return myArray
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "meal_to_menu" {
            let menuController = segue.destination as! MenuController
            menuController.menuDataArray = menuDataArray
        }
    }
}
