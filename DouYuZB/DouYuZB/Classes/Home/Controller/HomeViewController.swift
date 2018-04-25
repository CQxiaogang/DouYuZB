//
//  HomeViewController.swift
//  DouYuZB
//
//  Created by apple on 2018/4/25.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置UI界面
        setupUI()
    }
    
}
//MARK:-设置UI界面
extension HomeViewController{
    private func setupUI(){
       // 1.设置导航栏
        setupNavigationBar()
    }
    // 导航栏设置
    private func setupNavigationBar(){
        
        //1.设置左侧的Itme
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        //2.设置右侧的Itme
        let  size = CGSize(width: 40, height: 40)
        
        let historyItme = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        
        let searchItme = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        
        let qrcodeItme = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        
        navigationItem.rightBarButtonItems = [historyItme,searchItme,qrcodeItme]
        
        
    }
}
