
//
//  NSDate_Extension.swift
//  DouYuZB
//
//  Created by apple on 2018/5/31.
//  Copyright © 2018年 apple. All rights reserved.
//

import Foundation

extension NSDate{
    class func getCurrentTime() -> String{
        let nowDate = NSDate()
        let interval = Int(nowDate.timeIntervalSince1970)
        return "\(interval)"
    }
}
