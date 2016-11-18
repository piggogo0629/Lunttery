//
//  TableSectionHeader.swift
//  Lunttery
//
//  Created by Ollie on 2016/11/18.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import Foundation
import UIKit

// Ref. Guide to Customizing UITableView Section Header/Footer
// http://samwize.com/2015/11/06/guide-to-customizing-uitableview-section-header-footer/
// http://www.elicere.com/mobile/swift-blog-2-uitableview-section-header-color/

// note: 要 implement -> func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {  return  }


class TableSectionHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
}

