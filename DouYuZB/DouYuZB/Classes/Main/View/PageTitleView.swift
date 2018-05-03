//
//  PageTitleView.swift
//  DouYuZB
//
//  Created by apple on 2018/4/25.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

//MARK: -定义协议
protocol PageTitleViewDelegate: class {
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int)
}

//MARK: -定义常量
private let KScrollLineH: CGFloat = 2
private let kNomalColor: (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor: (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

//MARK: -定义PageTitleView类
class PageTitleView: UIView {
    //MARK:-定义属性
    private var titles: [String]
    private var currentIndex: Int = 0
    weak var deletage: PageTitleViewDelegate?
    
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
            lable.textColor = UIColor(r: kNomalColor.0, g: kNomalColor.1, b: kNomalColor.2)
            lable.textAlignment = .center
            
            //3.设置lable的frame
            let lableX: CGFloat = lableW * CGFloat(index)
            lable.frame = CGRect(x: lableX, y: lableY, width: lableW, height: lableH)
            
            //4.将lable添加到scrollView中
            scrollView.addSubview(lable)
            titleLables .append(lable)
            
            //5.给lable添加手势
            lable.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLableClik(tapGes:)))
            lable.addGestureRecognizer(tapGes)
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
        firstLable.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        //2.2设置scrollLine的属性
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLable.frame.origin.x, y: frame.height - KScrollLineH, width: firstLable.frame.width, height: KScrollLineH)
    }
    
}
//MARK: - 监听lable的点击
extension PageTitleView{
    @objc private func titleLableClik(tapGes: UITapGestureRecognizer){ 
        //1.获取当前的lable
        guard let currentLable = tapGes.view as? UILabel else {return}
        
        //2.获取之前的lable
        let oldLable = titleLables[currentIndex]
        
        //3.改变当前点击的lable的颜色
        currentLable.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLable.textColor = UIColor(r: kNomalColor.0, g: kNomalColor.1, b: kNomalColor.2)
        
        //4.保存最新lable的tag值
        currentIndex = currentLable.tag
        
        //5.滚动条的位置改变
        let scorllLineX = CGFloat(currentLable.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scorllLineX
        }
        
        //6.通知代理
        deletage?.pageTitleView(titleView: self, selectedIndex: currentIndex)
    }
}

//MARK: -对外暴露方法
extension PageTitleView{
    func setTitleWithProgess(progess: CGFloat, sourceIndex: Int, targetInde: Int){
        //1.取出sourceLable和targetLable
        let sourceLable = titleLables[sourceIndex]
        let targetLable = titleLables[targetInde]
        
        //2.处理滑块的逻辑
        let moveTotalX = targetLable.frame.origin.x - sourceLable.frame.origin.x
        let moveX = moveTotalX * progess
        scrollLine.frame.origin.x = sourceLable.frame.origin.x + moveX
        
        //3.颜色的渐变(复杂)
        //3.1取出变化的范围
        let colorDelta = (kSelectColor.0 - kNomalColor.0, kSelectColor.1 - kNomalColor.1, kSelectColor.2 - kNomalColor.2)
        
        //3.2变化sourceLable
        sourceLable.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progess, g: kSelectColor.1 - colorDelta.1 * progess, b: kSelectColor.2 - colorDelta.2 * progess)
        //3.3变化targetLable
        targetLable.textColor = UIColor(r: kNomalColor.0 + colorDelta.0 * progess, g: kNomalColor.1 + colorDelta.1 * progess, b: kNomalColor.2 + colorDelta.2 * progess)
        
        //4.记录最新的index
        currentIndex = targetInde
    }
}





