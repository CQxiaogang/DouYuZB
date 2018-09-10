//
//  RecommendCycleView.swift
//  DouYuZB
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

class RecommendCycleView: UIView {
    override func awakeFromNib() {
        //设置该控件不随着父控件的拉伸而拉伸
        autoresizingMask = UIViewAutoresizing()
    }
    
}
//MARK:- 提供一个快速创建Viewde方法
extension RecommendCycleView{
    class func recommendCycleView() -> RecommendCycleView {
        return Bundle.main.loadNibNamed("RecommendCycleView", owner: nil, options: nil)?.first as! RecommendCycleView
    }
}
