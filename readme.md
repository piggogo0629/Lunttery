#AC Final Project - Lunttery

![Imgur](http://i.imgur.com/JxVAE6Bl.png)  
![Imgur](http://i.imgur.com/rYbSvQxl.png)


###記錄一些在製作這個App時遇到的需求或問題 & 參考的資料/解決方法

## sidebar menu
- author github：[https://github.com/John-Lluch/SWRevealViewController/blob/master/README.md](https://github.com/John-Lluch/SWRevealViewController/blob/master/README.md)
- 參考1：[http://www.appcoda.com/sidebar-menu-swift/](http://www.appcoda.com/sidebar-menu-swift/)
- 參考2：[http://samwize.com/2015/03/25/setting-up-swrevealviewcontroller/](http://samwize.com/2015/03/25/setting-up-swrevealviewcontroller/)
- 參考3：[http://www.ebc.cat/2015/03/07/customize-your-swrevealviewcontroller-slide-out-menu/](http://www.ebc.cat/2015/03/07/customize-your-swrevealviewcontroller-slide-out-menu/)

####簡易操作步驟
step1. 拉一個空的view controller到storyboard上，設定其class為SWRevealViewController

step2. 從這個SWRevealViewController拉一條藍線到Menu view controller，segue selection選擇“reveal view controller set segue”

step3. 將segue identifier設為“sw_rear” ( By setting the identifier, you tell SWRevealViewController that the menu view controller is the rear view controller.)

step4. 重複第二步：從SWRevealViewController拉一條藍線到news view controller的navigation controller. 一樣選擇“reveal view controller set segue”

step5. 將segue identifier設為“sw_front”. ( This tells the SWRevealViewController that the navigation controller is the front view controller. )

step6. 在 news view controller 的 viewDidLoad裡面寫上：

```
 if self.revealViewController() != nil {
 	menuButton.target = self.revealViewController()
 	menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
 	self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
 }
```
 
step7. 從menu view controller拉藍線到其他對應的view controller上 ( e.g. map view controller, photo view controller )，segue selection選擇“reveal view controller push controller”

step8. 在 每個有對應的 view controller 的 viewDidLoad裡面寫上：

```
 if self.revealViewController() != nil {
 menuButton.target = self.revealViewController()
 menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
 self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
 }
```

step9. 大功告成囉！

Note1. 設定menu contoller 寬度<br/>
- left menu -> self.revealViewController().rearViewRevealWidth = 150<br/>
- right menu -> self.revealViewController().rightViewRevealWidth = 150


Note2. 如何改成從右邊出來？<br/>
step1. segue identifier: "sw_rear" 改成 "sw_right"<br/>
step2. menuButton 的 action 改成 rightRevealToggle

## Customizing UITableView Section Header/Footer
- 參考1：[http://samwize.com/2015/11/06/guide-to-customizing-uitableview-section-header-footer/](http://samwize.com/2015/11/06/guide-to-customizing-uitableview-section-header-footer/)
- 參考2：[http://www.elicere.com/mobile/swift-blog-2-uitableview-section-header-color/](http://www.elicere.com/mobile/swift-blog-2-uitableview-section-header-color/)
- Note. 最後要記得 implement -> func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {  return  }

## UI元件相關
- 調整EdgeInsets，讓button呈現圖片在上文字在下的效果
	- 參考1：[http://stackoverflow.com/questions/2451223/uibutton-how-to-center-an-image-and-a-text-using-imageedgeinsets-and-titleedgei/7199529#7199529](http://stackoverflow.com/questions/2451223/uibutton-how-to-center-an-image-and-a-text-using-imageedgeinsets-and-titleedgei/7199529#7199529)
	- 參考2：[http://www.jianshu.com/p/2f5c7c3dcaeb](http://www.jianshu.com/p/2f5c7c3dcaeb)

- Customizing UIActivityindicatorview
	- 參考：[http://sourcefreeze.com/uiactivityindicatorview-example-using-swift-in-ios/](http://sourcefreeze.com/uiactivityindicatorview-example-using-swift-in-ios/)

- UITextView With Placeholder Text
	- 參考：[https://grokswift.com/uitextview-placeholder/](https://grokswift.com/uitextview-placeholder/)

- Add icon/image in UITextField
	- 參考：[http://stackoverflow.com/questions/27903500/swift-add-icon-image-in-uitextfield](http://stackoverflow.com/questions/27903500/swift-add-icon-image-in-uitextfield)

- 點擊空白區域時，鍵盤自動隱藏 
	- 參考：[http://devonios.com/ios-hide-keykeyboard.html](http://devonios.com/ios-hide-keykeyboard.html)

-  UIPickerview hide the selection indicator(separator line)
	- 參考：[http://stackoverflow.com/questions/20612279/ios7-uipickerview-how-to-hide-the-selection-indicator/22011641#22011641](http://stackoverflow.com/questions/20612279/ios7-uipickerview-how-to-hide-the-selection-indicator/22011641#22011641)

## QRCode Reader
- 參考：[http://www.appcoda.com.tw/qr-code-reader-swift/
](http://www.appcoda.com.tw/qr-code-reader-swift/)


## iOS Map Kit 
- 參考1. [https://www.raywenderlich.com/110054/routing-mapkit-core-location](https://www.raywenderlich.com/110054/routing-mapkit-core-location)
- 參考2. [https://www.ioscreator.com/tutorials/draw-route-mapkit-tutorial](https://www.ioscreator.com/tutorials/draw-route-mapkit-tutorial)
- 參考3. [http://www.appcoda.com.tw/geo-targeting-ios/](http://www.appcoda.com.tw/geo-targeting-ios/)

## FB Login SDK

###簡易操作說明

step1. 將 SDK 加入專案：cocoapods安裝 FBSDKCoreKit, FBSDKLoginKit

step2. 專案的Info.plist檔案加入：

```
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fb{your-app-id}</string>
    </array>
  </dict>
</array>
<key>FacebookAppID</key>
<string>{your-app-id}</string>
<key>FacebookDisplayName</key>
<string>{your-app-name}</string>
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>fbapi</string>
  <string>fb-messenger-api</string>
  <string>fbauth2</string>
  <string>fbshareextension</string>
</array>
``` 

step3. 在AppDelegate.Swift中，將 AppDelegate 類別連接至 FBSDKApplicationDelegate 物件

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
	
	FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
	
	return true
}

func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
	
	let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
	
	return handled
}

```

step4. 在view controller中：create FBSDKLoginButton & 實作 FBSDKLoginButtonDelegate Protocol

- 參考1：[https://developers.facebook.com/docs/ios/getting-started](https://developers.facebook.com/docs/ios/getting-started)
- 參考2：[https://cg2010studio.com/2015/10/09/ios-facebook-sdk-%E5%8F%96%E5%BE%97%E5%B8%B3%E8%99%9F%E8%B3%87%E6%96%99/](https://cg2010studio.com/2015/10/09/ios-facebook-sdk-%E5%8F%96%E5%BE%97%E5%B8%B3%E8%99%9F%E8%B3%87%E6%96%99/)


## 其他
- Array 的 shuffle
	- 參考1：[https://read01.com/NNADP.html](https://read01.com/NNADP.html)
	- 參考2：[http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift/24029847#24029847](http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift/24029847#24029847)





 