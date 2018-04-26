//
//  PageTitleView.swift
//  DouYuZB
//
//  Created by apple on 2018/4/25.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

private let KScrollLineH: CGFloat = 2

class PageTitleView: UIView {
    //MARK:-定义属性
    private var titles: [String]
    
    //MARK:- 懒加载属性
    private lazy var titleLables: [UILabel] = [UILabel]()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    //MARK:自定义构造函数
    init(frame: CGRect, titles: [String] ) {
        self.titles = titles
        
        super.init(frame: frame)
        
        //设置UI界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK:- 设置UI界面
extension PageTitleView{
    private func setupUI(){
        
        //1.添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        // 2.添加title对应的Lable
        setupTitleLables()
        
        //3.设置底线可滚动的滑块
        setupBottomMenuAndScrollLine()
    }
    
    private func setupTitleLables(){
        
        //  0.确定lable的一些frame的值
        let lableW: CGFloat = frame.width / CGFloat(titles.count)
        let lableH: CGFloat = frame.height - KScrollLineH
        let lableY: CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            //1.创建UILable
            let lable = UILabel()
            //2.设置Lable的属性
            lable.text = title
            lable.tag = index
            lable.font = UIFont.systemFont(ofSize: 16.0)
            lable.textColor = UIColor.darkGray
            lable.textAlignment = .center
            
            //3.设置lable的frame
            let lableX: CGFloat = lableW * CGFloat(index)
            lable.frame = CGRect(x: lableX, y: lableY, width: lableW, height: lableH)
            
            //4.将lable添加到scrollView中
            scrollView.addSubview(lable)
            titleLables .append(lable)
        }
    }
    
    private func setupBottomMenuAndScrollLine(){
        //1/添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH: CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        //2.添加ScrollLine
        //2.1获取第一个Lable
        guard let firstLable = titleLables.first else{return}
        firstLable.textColor = UIColor.orange
        
        //2.2设置scrollLine的属性
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLable.frame.origin.x, y: frame.height - KScrollLineH, width: firstLable.frame.width, height: KScrollLineH)
    }
    
}
