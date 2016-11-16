//
//  MenuController.swift
//  Lunttery
//
//  Created by Ollie on 2016/11/16.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit

class MenuController: UIViewController {
    
    //MARK:- Variables
    var test:Int?
    
    //MARK:- @IBOutlet
    @IBOutlet weak var shareButton: UIButton!
    
    //MARK:- @IBAction
    @IBAction func share(_ sender: UIButton) {
        
    }

    //MARK:- Self func
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("test:\(test)")

        let newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back(sender:)))
        newBackButton.image = UIImage(named: "reply")
        self.navigationItem.leftBarButtonItem = newBackButton
        
        // 設定分享按鈕的Border
        shareButton.layer.borderWidth = 1.5
        shareButton.layer.borderColor = UIColor(red: 255.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1.0).cgColor
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

}
