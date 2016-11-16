//
//  FontViewController.swift
//  Lunttery
//
//  Created by Ollie on 2016/11/5.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire

// 讓 ViewController 聲明對CLLocationManagerDelegate protocol的實現
class FrontViewController: UIViewController, CLLocationManagerDelegate {

    //MARK:- Variables
    let myDefaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    var myAppDelegate = UIApplication.shared.delegate as! AppDelegate
    var myUserSetting: UserSetting? = nil
    var isFirstQuery: Bool = false
    var returnJSON: JSON?
    
    //MARK:- @IBOutlet
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var queryButton: UIButton!
    @IBOutlet weak var luntteryLabel: UILabel!
    @IBOutlet weak var luntteryImageView: UIImageView!
    
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var decisionLabel: UILabel!
    @IBOutlet weak var emoticonLabel: UILabel!
    
    //MARK:- @IBAction
    @IBAction func oneTouchSearch(_ sender: Any) {
         //if myLocation == nil {
            // default -> 松江南京站 lat:25.0512257,lng:121.5305447
            myAppDelegate.myLocation = CLLocation(latitude: 25.0512257, longitude: 121.5305447)
            // demo1 -> 四平陽光商圈 lat:25.0529708,lng:121.5315674
            myAppDelegate.myLocation = CLLocation(latitude: 25.0529708, longitude: 121.5315674)
        
        //}

        let myCoordinate = (myAppDelegate.myLocation?.coordinate)!
        var myStyleArray = [String]()
        
        for item in (myUserSetting?.styleSelected)! {
            if item.value == true {
                myStyleArray.append(String(item.key))
            }
        }
        // http://103.3.61.129/api/meals?lat=25.0521723&lng=121.5321898&distant=0.1&style_ids=1,3,4&price=101
        /* 呼叫API */
        let queryUrl = "http://103.3.61.129/api/meals"
        let paras: Parameters = ["lat": myCoordinate.latitude,
                                 "lng": myCoordinate.longitude,
                                 "distant": (myUserSetting?.restrictedKm)!,
                                 "price": (myUserSetting?.price)!,
                                 "style_ids": myStyleArray.joined(separator: ",")
                                ]
        let queryRequest = request(queryUrl, method: .get, parameters: paras, encoding: URLEncoding.default, headers: nil)
        
        //debugPrint(qrCodeRequest)
        queryRequest.responseJSON(completionHandler: { (response: DataResponse<Any>) in
            switch response.result {
            case .success(let value):
                
                self.returnJSON = JSON(value)
                
                //print("returnJSON:\(self.returnJSON)")
                
                UIView.animate(withDuration: 0.7, animations: {
                    //if self.isFirstQuery == true {
                        self.queryButton.isHidden = true
                        self.luntteryLabel.isHidden = true
                        self.luntteryImageView.image = nil
                    
                        self.view.bringSubview(toFront: self.heartImageView)
                        self.view.bringSubview(toFront: self.emoticonLabel)
                        self.view.bringSubview(toFront: self.decisionLabel)
                        
                        //self.myDefaults.set(false, forKey: "isFirstQuery")
                    //}
                }, completion: { (animated: Bool) in
                    // 延遲0.7秒
                    let _ = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(self.myPerform(timer:)), userInfo: nil, repeats: false)
                })
            case .failure(let error):
                self.showAlertWithMessage(alertMessage: "查詢失敗，請再試一次～")
                print("=====\(error.localizedDescription)=====")
            }
        })
    }
    
    //MARK:- Self func
    deinit {
        print("=====FrontViewController deinit=====")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            self.revealViewController().rightViewRevealWidth = 200
            
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            // 第一次使用App,導引至偏好設定畫面
            let isFirstLaunch = myDefaults.bool(forKey: "isFirstLaunch")
            if isFirstLaunch == true {
                self.performSegue(withIdentifier: "front_to_set", sender: nil)
            }
        }
        
        if myDefaults.object(forKey: "isFirstQuery") != nil {
            isFirstQuery = myDefaults.bool(forKey: "isFirstQuery")
        }
        
        // 修改導覽列文字的顏色，字型
        let textForegroundColor = UIColor(red: 255.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        //let textFont = UIFont.systemFont(ofSize: 30, weight: UIFontWeightSemibold)
        let textFont = UIFont(name: ".PingFangTC-Semibold", size: 30)
        let textArttribute = [NSForegroundColorAttributeName: textForegroundColor, NSFontAttributeName: textFont]
        self.navigationController?.navigationBar.titleTextAttributes = textArttribute
        
        // ps.如果有設定LeftBarButtonItem,則預設的backBarButtonItem會消失
        // e.g.controller A -> controller B
        // 要修改backBarButtonItem title文字（預設是前一畫面的標題):所以從 controller A 設定
        // 要隱藏backBarButtonItem：self.navigationItem.hideBackButton = true , 從 controller B 設定
        //let myBackBarButton =  UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: Selector(("resetViewDisplay:")))
        //self.navigationItem.backBarButtonItem = myBackBarButton
        //self.navigationItem.backBarButtonItem?.setTitleTextAttributes([:], for: .normal)
        
        // 修改 backBarButtonItem color
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        
        // 配置locationManager
        locationManager.delegate = self
        locationManager.distanceFilter  = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 在 viewDidAppear 方法而不是其它方法中檢查用戶授權狀態，是因為有用戶會去設置程序中修改授權，然後又回到 App。因此我們需要在這時重新對用戶授權狀態進行檢查。
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            // 還沒有詢問過用戶以獲得權限
            locationManager.requestWhenInUseAuthorization()
        } else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
            // 用戶不同意
            self.showAlertWithMessage(alertMessage: "已拒絕啟用定位服務。請從設置程序中重新啟用。")
        } else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            // 用戶已經同意
            locationManager.startUpdatingLocation()
        }
        
        // 畫面呈現時，讀取UserSetting
        if myDefaults.object(forKey: "UserSetting") != nil {
            let savedUserSettingData = myDefaults.object(forKey: "UserSetting") as! Data
            myUserSetting = NSKeyedUnarchiver.unarchiveObject(with:savedUserSettingData) as? UserSetting
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            myAppDelegate.myLocation = location
        }
    }
    
    //MARK:- User Defined Method
    func myPerform(timer: Timer) {
        self.performSegue(withIdentifier: "front_to_meal", sender: nil)
    }
    
    func resetViewDisplay() {
        self.luntteryImageView.image = UIImage(named: "frontImage")
        self.queryButton.isHidden = false
        self.luntteryLabel.isHidden = false
 
        self.view.sendSubview(toBack: self.heartImageView)
        self.view.sendSubview(toBack: self.emoticonLabel)
        self.view.sendSubview(toBack: self.decisionLabel)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "front_to_meal" {
            let controller = segue.destination as! MealController
            controller.queryResult = returnJSON
        }
    }
}
