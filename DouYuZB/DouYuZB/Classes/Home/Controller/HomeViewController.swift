//
//  HomeViewController.swift
//  DouYuZB
//
//  Created by apple on 2018/4/25.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

private let KTitleViewH: CGFloat = 40

class HomeViewController: UIViewController {
    
    private lazy var pageTitleView: PageTitleView = {
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: KTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        return titleView
    }()
    
    private lazy var pageContentView: PageContentView = {[weak self] in
        //1.确认内容的frame
        let contentH = kScreenH-kStatusBarH-kNavigationBarH-KTitleViewH
        let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + KTitleViewH, width: kScreenW, height: contentH)

        //2.确认所以的控制器
        var childVcs = [UIViewController]()
        for _ in 0..<4{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(vc)
        }
        
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        
        return contentView
    }()
    
    //系统回掉函数
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置UI界面
        setupUI()
    }
    
}
//MARK:-设置UI界面
extension HomeViewController{
    private func setupUI(){
        // 0.不需要调整UIScrollView的内边距,此行代码加了没起什么作用，于是决定先不用
        automaticallyAdjustsScrollViewInsets = false
        
        // 1.设置导航栏
        setupNavigationBar()
        
        //2.添加TitleView
        view.addSubview(pageTitleView)
        
        //3.设置ContenView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.purple
        
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
