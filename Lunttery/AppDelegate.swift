//
//  AppDelegate.swift
//  Lunttery
//
//  Created by Ollie on 2016/11/5.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit
import CoreLocation
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var myDefaults = UserDefaults.standard
    var myLocation: CLLocation?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 修改整個App導覽列文字的顏色，字型
        //let textForegroundColor = UIColor(red: 255.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        //let textFont = UIFont.systemFont(ofSize: 28, weight: UIFontWeightSemibold)
        //let textFont = UIFont(name: ".PingFangTC-Semibold", size: 28)
        //let textArttribute = [NSForegroundColorAttributeName: textForegroundColor, NSFontAttributeName: textFont]
        
        //UINavigationBar.appearance().titleTextAttributes = textArttribute
        
        //變更狀態欄樣式
        //1.IOS允許開發者覆寫preferredStatusStyle方法來控制任一viewController的狀態欄樣式
        //2.也可以從UIApplication的statusBarStyle屬性做全面設定
        //  ->要關閉預設啟用的「View controller-based status bar appearance」: 
        //    專案 -> target -> Info -> 新增Key:View controller-based status bar appearance,Value:NO
        //UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        // 記錄是否第一次開啟App
        if myDefaults.object(forKey: "isFirstLaunch") == nil {
            let isFirstLaunch: Bool = true
            myDefaults.set(isFirstLaunch, forKey: "isFirstLaunch")
        }
        // 記錄是否第一次按下“一鍵查找”
        if myDefaults.object(forKey: "isFirstQuery") == nil {
            let isFirstQuery: Bool = true
            myDefaults.set(isFirstQuery, forKey: "isFirstQuery")
        }
        // 記錄使用者登入Server取得的token
        if myDefaults.object(forKey: "user_Auth") == nil {
            let user_Auth = ["user_id": 0, "auth_token": ""] as [String : Any]
            myDefaults.set(user_Auth, forKey: "user_Auth")
        }
        // 記錄使用者的歷程記錄
        if myDefaults.object(forKey: "UserRecord") == nil {
            let record = [[String:Any]]()
            myDefaults.set(record, forKey: "UserRecord")
        }
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return handled
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

