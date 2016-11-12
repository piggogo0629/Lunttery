//
//  UserSetting.swift
//  Lunttery
//
//  Created by Ollie on 2016/11/12.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import Foundation

//noticeTime,price,style_id,distance
class UserSetting: NSObject, NSCoding {
    var noticeTime: Date
    var price: Int
    var styleSelected:[Int: Bool]
    var restrictedKm: Double
    
    init(noticeTime: Date, price: Int, styleSelected: [Int: Bool], restrictedKm: Double) {
        self.noticeTime = noticeTime
        self.price = price
        self.styleSelected = styleSelected
        self.restrictedKm = restrictedKm
    }
    
    required init?(coder aDecoder: NSCoder) {
        noticeTime = aDecoder.decodeObject(forKey: "noticeTime") as! Date
        price = aDecoder.decodeInteger(forKey: "price")
        styleSelected = aDecoder.decodeObject(forKey: "styleSelected") as! [Int: Bool]
        restrictedKm = aDecoder.decodeDouble(forKey: "restrictedKm")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.noticeTime, forKey: "noticeTime")
        aCoder.encode(self.price, forKey: "price")
        aCoder.encode(self.styleSelected, forKey: "styleSelected")
        aCoder.encode(self.restrictedKm, forKey: "restrictedKm")
    }
}
