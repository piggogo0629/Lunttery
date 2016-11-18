//
//  MenuViewCell.swift
//  Lunttery
//
//  Created by Ollie on 2016/11/17.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit

class MenuViewCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
