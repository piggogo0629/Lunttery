//
//  UserRecordController.swift
//  Lunttery
//
//  Created by Ollie on 2016/11/16.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit

class UserRecordController: UIViewController {

    //MARK:- @IBOutlet
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //MARK:- @IBAction
    @IBAction func close(_ sender: UIButton) {
        if self.revealViewController() != nil {
            self.revealViewController().performSegue(withIdentifier: "sw_front", sender: nil)
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
