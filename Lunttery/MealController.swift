//
//  MealController.swift
//  Lunttery
//
//  Created by Ollie on 2016/11/14.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class MealController: UIViewController {
    
    //MARK:- Variables
    var queryResult: JSON?
    var resultArray: [JSON]?
    
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
        
        // 資料處理
        if let data = queryResult?["data"].array {
            resultArray = data
        }
        // 畫面載入時顯示第一筆
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - User Defined Method
    func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // Go back to the previous ViewController
        let frontViewController = navigationController?.childViewControllers[0] as! FrontViewController
        frontViewController.resetViewDisplay()
        let _ = self.navigationController?.popToViewController(frontViewController, animated: true)
    }

    func viewDisplay(data: JSON?) {
        let BasedUrl = "http://103.3.61.129"
        //let imageUrl
        if let mealName = data?.dictionaryValue["name"]?.string {
            
        }
        if let price = data?.dictionaryValue["price"]?.int {
            
        }
        if let kcal = data?.dictionaryValue["carories"]?.int {
            
        }
        if let liked_count = data?.dictionaryValue["liked_counts"]?.int {
            
        }
        // 餐廳資訊
        let dinner = data?.dictionaryValue["dinner"]?.dictionaryValue
        if let dinnerName = dinner?["name"]?.string {
            
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
