//
//  RecommendViewModel.swift
//  DouYuZB
//
//  Created by apple on 2018/5/242
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

class RecommendViewModel{
    // MARK: 懒加载属性
    lazy var anchorGroups : [AnchorGroup] = [AnchorGroup]()
    lazy var cycleModels : [CycleModel] = [CycleModel]()
    private lazy var bigDataGroup : AnchorGroup = AnchorGroup()
    private lazy var prettyGroup : AnchorGroup = AnchorGroup()
}

//MRAK: 发送网络请求
extension RecommendViewModel{
    //请求推荐数据
    func requestData(finishCallback: @escaping () -> ()){
        //1.定义参数
        let parameters = ["limit":4, "offset":0, "time":NSDate.getCurrentTime()] as [String : Any]
        //2.创建Group
        let dGroup = DispatchGroup()
        /******************************请求第一部分推荐数据*******************************/
        dGroup.enter()
        NetworkTools.requestData(.get, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time" : NSDate.getCurrentTime()]) { (result) in
            
            // 1.将result转成字典类型
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2.根据data该key,获取数组
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
    
            // 3.遍历字典,并且转成模型对象
            // 3.1.设置组的属性
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"

            // 3.2.获取主播数据
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.bigDataGroup.anchors.append(anchor)
            }
            //4 离开组
            dGroup.leave()
        }
        
        /******************************请求第二部分的颜值数据*******************************/
        dGroup.enter()
        NetworkTools.requestData(.get, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters) { (result) in
            //1.将result转为字典类型
            guard let resultDict = result as? [String:NSObject] else {return}
            
            //2.根据data的key，获得数组
            guard let dataArray = resultDict["data"] as? [[String:NSObject]] else {return}
            
            //3 便利数组转成模型对象
            //3.1 设置组的属性
            self.prettyGroup.tag_name = "颜值"
            self.prettyGroup.icon_name = "home_header_phone"
            
            //3.2 获取主播数据
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.prettyGroup.anchors.append(anchor)
            }
            //4 离开组
            dGroup.leave()
        }
        /******************************请求后面部分的游戏数据*******************************/
        dGroup.enter()
        NetworkTools.requestData(.get, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters:parameters) { (result) in
            //1.将result转为字典类型
            guard let resultDict = result as? [String:NSObject] else {return}
            
            //2.根据data的key，获得数组
            guard let dataArray = resultDict["data"] as? [[String:NSObject]] else {return}
            
            //3.便利数组，获得字典，并且把字典转成模型对象
            for dict in dataArray{
                let group = AnchorGroup(dic: dict)
                
                self.anchorGroups.append(group)
            }
            //4 离开组
            dGroup.leave()
        }
        dGroup.notify(queue: DispatchQueue.main) {
            self.anchorGroups.insert(self.prettyGroup, at: 0)
            self.anchorGroups.insert(self.bigDataGroup, at: 0)
            
            finishCallback()
        }
    }
    
    //请求无限轮播的数据
    func requestCycleData(finishCallback: @escaping () -> ()){
        NetworkTools.requestData(.get, URLString: "http://www.douyutv.com/api/v1/slide/6", parameters: ["version" : "2.300"]) { (result) in
            // 1.获取整体字典数据
            guard let resultDict = result as? [String : NSObject] else {return}
            
            // 2.根据data的key获取数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else {return}
            
            // 3.字典转模型对象
            for dict in dataArray{
                self.cycleModels.append(CycleModel(dict: dict))
            }
            finishCallback()
        }
    }
}
