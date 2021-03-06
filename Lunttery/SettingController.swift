//
//  TemporarySettingController.swift
//  Lunttery
//
//  Created by Ollie on 2016/11/21.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit
import UserNotifications

class SettingController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK:- Variables
    let priceArray    = ["100元以內", "150元以內", "300元以內"]
    let distanceArray = ["10分鐘以內", "15分鐘以內", "30分鐘以內"]
    let priceNumArray = [101, 151, 301]
    let distanceNumArray = [0.67, 1.0, 0.0]
    var styleSelected = [Int: Bool]()
    var myUserSetting: UserSetting? = nil
    var mySelectedCount = 0
    var isLeastOne = false
    var leastOneTag = 0
    let myDefaults = UserDefaults.standard
    let myCalendar = Calendar.current
    let myNotiCenter = UNUserNotificationCenter.current()
    
    //MARK:- @IBOutlet
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var noticeTimePicker: UIDatePicker!
    @IBOutlet weak var pricePicker: UIPickerView!
    @IBOutlet weak var distancePicker: UIPickerView!
    @IBOutlet weak var taiwanButton: UIButton!
    @IBOutlet weak var americaButton: UIButton!
    @IBOutlet weak var italyButton: UIButton!
    @IBOutlet weak var japanButton: UIButton!
    @IBOutlet weak var vietnamButton: UIButton!
    @IBOutlet weak var koreaButton: UIButton!
    
    //MARK:- @IBAction
    @IBAction func close(_ sender: UIButton) {
        if self.revealViewController() != nil {
            self.revealViewController().performSegue(withIdentifier: "sw_front", sender: nil)
        }
    }
    
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

        // 修改導覽列文字的顏色，字型
        let textForegroundColor = UIColor(red: 124.0/255.0, green: 124.0/255.0, blue: 124.0/255.0, alpha: 1.0)
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
            let setTime = myDateFormatter.date(from: timeString)
            
            noticeTimePicker.setDate(setTime!, animated: true)
            
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
        } else {
            if let savedUserSettingData = myDefaults.object(forKey: "UserSetting") as? Data {
                myUserSetting = NSKeyedUnarchiver.unarchiveObject(with:savedUserSettingData) as? UserSetting
                
                noticeTimePicker.setDate((myUserSetting?.noticeTime)!, animated: true)
                styleSelected = (myUserSetting?.styleSelected)!
                
                let pricePickerIndex = priceNumArray.index(of: (myUserSetting?.price)!)
                let distancePickerIndex = distanceNumArray.index(of: (myUserSetting?.restrictedKm)!)
                
                pricePicker.selectRow(pricePickerIndex!, inComponent: 0, animated: true)
                distancePicker.selectRow(distancePickerIndex!, inComponent: 0, animated: true)
                
                var countDownNumber = styleSelected.count - 1
                
                for item in styleSelected {
                    countDownNumber -= 1
                    
                    if item.value == true {
                        mySelectedCount += 1
                    }
                    
                    // 最後一次時，檢查：如果偏好只設定一種，則要賦值給 leastOneTag & isLeastOne，避免點擊後全部都不選的狀況
                    if countDownNumber == 0 && mySelectedCount == 1 {
                         leastOneTag = item.key
                         isLeastOne = true
                    }
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
        
        // 向User申請通知權限
        myNotiCenter.requestAuthorization(options: [.alert, .sound]) { (granted: Bool, error: Error?) in
            if granted == true {
                print("user noti requset success")
            } else {
                print("user noti requset denied")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Prepare Values to Store with UserSetting class
        let pricePickerIndex = pricePicker.selectedRow(inComponent: 0)
        let distancePickerIndex = distancePicker.selectedRow(inComponent: 0)
        let noticeTime = noticeTimePicker.date
        
        let price = priceNumArray[pricePickerIndex]
        let distance = distanceNumArray[distancePickerIndex]
        
        // 檢查UserSetting是否已存在UserDefaults中
        if myDefaults.object(forKey: "UserSetting") == nil {
            myUserSetting = UserSetting(noticeTime: noticeTime, price: price, styleSelected: styleSelected, restrictedKm: distance)
        } else {
            if let savedUserSettingData = myDefaults.object(forKey: "UserSetting") as? Data {
                myUserSetting = NSKeyedUnarchiver.unarchiveObject(with: savedUserSettingData) as? UserSetting
                
                myUserSetting?.noticeTime = noticeTime
                myUserSetting?.price = price
                myUserSetting?.styleSelected = styleSelected
                myUserSetting?.restrictedKm = distance
            }
        }
        
        let archivedUserSetting = NSKeyedArchiver.archivedData(withRootObject: myUserSetting!)
        
        myDefaults.setValue(archivedUserSetting, forKey: "UserSetting")
        
        // 建立＆發送通知
        scheduleLocal(noticeTime: noticeTime)
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
    
    func scheduleLocal(noticeTime: Date) {
        //schedule a notification, which is three things: content (what to show), a trigger (when to show it), and a request (the combination of content and trigger.)
        //can add new request with the same identifier to update a notification.
        
        let content = UNMutableNotificationContent()
        content.title = "Lunttery~"
        content.body = "又到了午餐時間囉！趕快打開Lunttery吧！"
        content.sound = UNNotificationSound.default()
        
        let dateComponent = myCalendar.dateComponents([.hour, .minute], from: noticeTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        let request = UNNotificationRequest(identifier: "noticeTime", content: content, trigger: trigger)
        
        myNotiCenter.add(request, withCompletionHandler: nil)
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
