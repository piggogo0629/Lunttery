//
//  MenuController.swift
//  Lunttery
//
//  Created by Ollie on 2016/11/16.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class MenuController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //MARK:- Variables
    var menuDataArray: [JSON]!
    
    //MARK:- @IBOutlet
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var menuTableView: UITableView!
    
    //MARK:- @IBAction
    @IBAction func share(_ sender: UIButton) {
        
    }

    //MARK:- Self func
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("===menuDataArray\(menuDataArray)")
        
        let newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back(sender:)))
        newBackButton.image = UIImage(named: "reply")
        self.navigationItem.leftBarButtonItem = newBackButton
        
        // 設定分享按鈕的Border
        shareButton.layer.borderWidth = 1.5
        shareButton.layer.borderColor = UIColor(red: 255.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1.0).cgColor
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        // 設定TableView背景色
        menuTableView.backgroundColor = UIColor(red: 236.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
        // 設定TableView的footer來隱藏多於分隔線
        menuTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Self Sizing cells height
        menuTableView.estimatedRowHeight = (self.view.frame.size.height * 115/667)
        menuTableView.rowHeight = UITableViewAutomaticDimension
        menuTableView.sectionHeaderHeight = UITableViewAutomaticDimension
        
        //Register the Nib
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        menuTableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - User Defined Method
    func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // Go back to the previous ViewController
        let mealController = navigationController?.childViewControllers[1] as! MealController
        let _ = self.navigationController?.popToViewController(mealController, animated: true)
    }

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK:- UITableViewDataSource, UITableViewDelegate protocols
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuViewCell = tableView.dequeueReusableCell(withIdentifier: "MenuViewCell", for: indexPath) as! MenuViewCell
        let menuData = menuDataArray[indexPath.row]
        
        let mealName = menuData["name"].stringValue
        let price = menuData["price"].intValue
        let likeCount = menuData["liked_counts"].intValue
        let isLike = menuData["liked"].boolValue
        
        menuViewCell.mealNameLabel.text = mealName
        menuViewCell.priceLabel.text = "\(price) 元"
        menuViewCell.likeCountLabel.text = String(likeCount)
        
        if isLike == true {
            menuViewCell.likeButton.setImage(UIImage(named: "like"), for: UIControlState.normal)
        } else {
            menuViewCell.likeButton.setImage(UIImage(named: "dislike"), for: UIControlState.normal)
        }
        
        // 圖片顯示
        let BasedUrl = "http://103.3.61.129"
        let defaultImage = (UIImage(named: "defaultImage"))!
        
        if let imageUrlArray = menuData["photos_urls"].array {
            if imageUrlArray.count > 0 {
                let fullUrlString = BasedUrl + imageUrlArray[0].stringValue
                let fullUrl = URL(string: fullUrlString)
                
                menuViewCell.mealImageView.sd_setImage(with: fullUrl, placeholderImage: defaultImage)
            } else {
                menuViewCell.mealImageView.image = defaultImage
            }
        }
        
        // disable the UITableView highlighting
        menuViewCell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return menuViewCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Dequeue with the reuse identifier
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader")
        let header = cell as! TableSectionHeader
        header.titleLabel.text = "主餐"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.frame.size.height * (40 / 667)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // recast your view as a UITableViewHeaderFooterView
        let header = (view as! UITableViewHeaderFooterView) as! TableSectionHeader
        // make the background color
        header.contentView.backgroundColor = UIColor(red: 124.0/255.0, green: 124.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        // make the text color
        header.titleLabel.textColor = UIColor.white
        // make the header transparent
        //header.alpha = 0.5
    }
    
    //MARK: User Defined Method
}
