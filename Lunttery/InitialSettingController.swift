//
//  InitialSettingController.swift
//  Lunttery
//
//  Created by Ollie on 2016/11/10.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit
import CoreLocation

class InitialSettingController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate {

    //MARK:- Variables
    let priceArray    = ["100元以內", "150元以內", "300元以內"]
    let distanceArray = ["10分鐘以內", "15分鐘以內", "30分鐘以內"]
    let priceNumArray = [101, 151, 301]
    let distanceNumArray = [0.67, 1.0, 2.0]
    var defaultNoticeTime:Date?
    var styleSelected = [Int: Bool]()
    var myUserSetting: UserSetting? = nil
    var mySelectedCount = 0 // 記錄有幾個style被選取
    var isLeastOne = false
    var leastOneTag = 0
    
    let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
    let locationManager = CLLocationManager()
    let myDefaults = UserDefaults.standard
    let myCalendar = Calendar.current
    
    //MARK:- @IBOutlet
    @IBOutlet weak var pricePicker: UIPickerView!
    @IBOutlet weak var distancePicker: UIPickerView!
    @IBOutlet weak var taiwanButton: UIButton!
    @IBOutlet weak var americaButton: UIButton!
    @IBOutlet weak var italyButton: UIButton!
    @IBOutlet weak var japanButton: UIButton!
    @IBOutlet weak var vietnamButton: UIButton!
    @IBOutlet weak var koreaButton: UIButton!
    
    //MARK:- @IBAction
    @IBAction func selectStyle(_ sender: UIButton) {
        // 至少要選一個
        if mySelectedCount >= 1 {
            // 是最後一個且點到一樣的button -> return
            if isLeastOne == true && sender.tag == leastOneTag {
                return
            }
            
            let styleId  = sender.tag
            let selected = !(styleSelected[styleId]!)
            
            if selected == true {
                mySelectedCount += 1
                // 大於一個 -> isLeastOne = false
                if mySelectedCount > 1 {
                    isLeastOne = false
                }
            } else {
                // 只有一個 -> count不變
                if mySelectedCount == 1 {
                    mySelectedCount -= 0
                } else {
                    mySelectedCount -= 1
                }
            }
            // set Change
            if isLeastOne == false {
                styleSelected[styleId] = selected
                // display button
                changeButtonDisplay(isSelected: selected, button: sender)
            }
            // 最後判斷只有一個時 -> 記錄最後一個button & isLeastOne = true
            if mySelectedCount == 1 {
                isLeastOne = true
                leastOneTag = sender.tag
            }
        }
    }
    
    //MARK:- Self func
    deinit {
        print("=====SettingController deinit=====")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 修改導覽列文字的顏色，字型
        let textForegroundColor = UIColor(red: 255.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        //let textFont = UIFont.systemFont(ofSize: 30, weight: UIFontWeightSemibold)
        let textFont = UIFont(name: ".PingFangTC-Semibold", size: 30)
        let textArttribute = [NSForegroundColorAttributeName: textForegroundColor, NSFontAttributeName: textFont]
        self.navigationController?.navigationBar.titleTextAttributes = textArttribute
        
        pricePicker.delegate = self
        pricePicker.dataSource = self
        distancePicker.delegate = self
        distancePicker.dataSource = self
        
        // 檢查UserSetting是否已存在UserDefaults中
        if myDefaults.object(forKey: "UserSetting") == nil {
            // init UserSetting values
            let timeString = "2016-11-23 12:00"
            let myDateFormatter = DateFormatter()
            myDateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            defaultNoticeTime = myDateFormatter.date(from: timeString)
            //noticeTimePicker.setDate(setTime!, animated: true)
            
            pricePicker.selectRow(0, inComponent: 0, animated: true)
            distancePicker.selectRow(0, inComponent: 0, animated: true)
            
            for i in 3...8 {
                if i == 6 || i == 7 || i == 8 {
                    // 台式,義式,越式
                    styleSelected.updateValue(true, forKey: i)
                    mySelectedCount += 1
                } else {
                    styleSelected.updateValue(false, forKey: i)
                }
            }
        }
        
        // init button dislay
        changeButtonDisplay(isSelected: styleSelected[taiwanButton.tag]!, button: taiwanButton)
        changeButtonDisplay(isSelected: styleSelected[americaButton.tag]!, button: americaButton)
        changeButtonDisplay(isSelected: styleSelected[italyButton.tag]!, button: italyButton)
        changeButtonDisplay(isSelected: styleSelected[japanButton.tag]!, button: japanButton)
        changeButtonDisplay(isSelected: styleSelected[vietnamButton.tag]!, button: vietnamButton)
        changeButtonDisplay(isSelected: styleSelected[koreaButton.tag]!, button: koreaButton)
        
        // 配置locationManager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Prepare Values to Store with UserSetting class
        let pricePickerIndex = pricePicker.selectedRow(inComponent: 0)
        let distancePickerIndex = distancePicker.selectedRow(inComponent: 0)
        //let noticeTime = noticeTimePicker.date
        
        let price = priceNumArray[pricePickerIndex]
        let distance = distanceNumArray[distancePickerIndex]
        
        // 檢查UserSetting是否已存在UserDefaults中
        if myDefaults.object(forKey: "UserSetting") == nil {
            myUserSetting = UserSetting(noticeTime: defaultNoticeTime!, price: price, styleSelected: styleSelected, restrictedKm: distance)
        }
        
        let archivedUserSetting = NSKeyedArchiver.archivedData(withRootObject: myUserSetting!)
        myDefaults.setValue(archivedUserSetting, forKey: "UserSetting")
        
        // 將第一次進入App改成false
        let isFirstLaunch: Bool = false
        self.myDefaults.set(isFirstLaunch, forKey: "isFirstLaunch")
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 在 viewWillAppear 方法而不是其它方法中檢查用戶授權狀態，是因為有用戶會去設置程序中修改授權，然後又回到 App。因此我們需要在這時重新對用戶授權狀態進行檢查。
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
    }

    //MARK:- CLLocationManagerDelegate protocol
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            myAppDelegate.myLocation = location
        }
    }
    
    //MARK:- UIPickerView Protocol
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.restorationIdentifier == "pricePicker" {
            return priceArray[row]
        } else {
            return distanceArray[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return self.view.frame.size.height * (50 / 667)
    }
    
    //MARK: - User Defined Method
    func changeButtonDisplay(isSelected: Bool, button: UIButton) {
        if isSelected == false {
            let myGrayColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
            button.backgroundColor = UIColor.clear
            button.setTitleColor(myGrayColor, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = myGrayColor.cgColor
        } else {
            button.backgroundColor = UIColor(red: 255.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1.0)
            button.setTitleColor(UIColor.white, for: .normal)
            button.layer.borderWidth = 0
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
