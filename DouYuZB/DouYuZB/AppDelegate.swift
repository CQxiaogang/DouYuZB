//
//  AppDelegate.swift
//  DouYuZB
//
//  Created by apple on 2018/4/25.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //在AppDelegate中对TabBar进行全局修改颜色
        UITabBar.appearance().tintColor = UIColor.orange
        
        return true
    }

}

