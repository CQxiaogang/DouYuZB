//
//  AnchorGroup.swift
//  DouYuZB
//
//  Created by apple on 2018/5/31.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

class AnchorGroup: NSObject {
    /// 该组中对应的房间信息
    @objc var room_list : [[String : NSObject]]? {
        didSet {
            guard let room_list = room_list else { return }
            for dict in room_list {
                anchors.append(AnchorModel(dict: dict))
            }
        }
    }
    ///组显示标题
    @objc var tag_name : String = ""
    ///组显示的图标
    @objc var icon_name : String = "home_header_normal"
    ///定义主播模型对象数组
    @objc lazy var anchors : [AnchorModel] = [AnchorModel]()
    
    init(dic : [String:NSObject]) {
        super.init()
        setValuesForKeys(dic)
    }
    override init() {
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
