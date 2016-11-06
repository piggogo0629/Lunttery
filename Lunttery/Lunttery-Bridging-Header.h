//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import "SWRevealViewController.h"


/* Introduction:
 SWRevealViewController library provides a built-in support for Storyboard.
 
 When implementing a sidebar menu using, all you need to do is associate the SWRevealViewController with a front
 and a rear view controller using segues.
 
 The front view controller is the main controller for displaying content.
 
 In our storyboard, it’s the navigation controller which associates with a view controller for presenting news.
 
 The rear view controller is the controller that shows the navigation menu. Here it is the Sidebar View
 Controller.
*/


//原文參考：http://www.appcoda.com/sidebar-menu-swift/

//簡易操作步驟
// step1. 拉一個空的view controller到storyboard上，設定其class為SWRevealViewController

// step2. 從這個SWRevealViewController拉一條藍線到Menu view controller，segue selection選擇“reveal view controller set segue”

// step3. 將segue identifier設為“sw_rear” ( By setting the identifier, you tell SWRevealViewController that the menu view controller is the rear view controller.)

// step4. 重複第二步：從SWRevealViewController拉一條藍線到news view controller的navigation controller. 一樣選擇“reveal view controller set segue”

// step5. 將segue identifier設為“sw_front”. ( This tells the SWRevealViewController that the navigation controller is the front view controller. )

// step6. 在 news view controller 的 viewDidLoad裡面寫上：
/*
 if self.revealViewController() != nil {
 menuButton.target = self.revealViewController()
 menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
 self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
 }
 */

// step7. 從menu view controller拉藍線到其他對應的view controller上 ( e.g. map view controller, photo view controller )，segue selection選擇“reveal view controller push controller”

// step8. 在 每個有對應的 view controller 的 viewDidLoad裡面寫上：
/*
 if self.revealViewController() != nil {
 menuButton.target = self.revealViewController()
 menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
 self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
 }
 */

// step9. 大功告成囉！


// [Note]設定menu contoller 寬度
// left menu -> self.revealViewController().rearViewRevealWidth = 150
// right menu -> self.revealViewController().rightViewRevealWidth = 150


// [note]如何改成從右邊出來？
// 1. segue identifier: "sw_rear" 改成 "sw_right"
// 2. menuButton 的 action 改成 rightRevealToggle
