//
//  PageContentView.swift
//  DouYuZB
//
//  Created by apple on 2018/4/26.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

private let ContentCellID = "ContentCellID"
protocol PageContentViewDelegate: class{
    func pageContentView(contentView: PageContentView, progrss: CGFloat, sourceIndex: Int, targetIndex: Int)
}

class PageContentView: UIView {
    //MARK: -定义属性
    private var childVcs: [UIViewController]
    private weak var parentViewController: UIViewController?
    private var startOffetX: CGFloat = 0
    private var isForbidScrollDelegate: Bool = false
    weak var delegate: PageContentViewDelegate?
    
    //MARK: -懒加载属性，UICollectionView
    private lazy var collectionView: UICollectionView = {[weak self] in
        //1.创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        //2.创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false;
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        return collectionView
    }()
    
    //MARK: -自定义构造函数
    init(frame: CGRect, childVcs: [UIViewController], parentViewController: UIViewController?) {
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        super.init(frame: frame)
        
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -设置UI界面
extension PageContentView{
    private func setupUI(){
        //1.将所有的子控制器添加到父控制中
        for childVc in childVcs{
            parentViewController?.addChildViewController(childVc)
        }
        
        //2.添加UICollectionView,用于在Cell中存放控制器的View
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

//MARK: -遵守UICollectionViewDataSource
extension PageContentView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        //2.给cell设置内容
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

//MARK: -遵守UICollectionViewDelegate
extension PageContentView: UICollectionViewDelegate{
    
    //开始拖动，这个方法只会调一次
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startOffetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //0.判断是否是点击事件
        if isForbidScrollDelegate{return}
        
        //1.定义需要获取的数据
        var progress: CGFloat = 0
        var sourceIndex: Int = 0
        var targetIndex: Int = 0
        
        //2.判断左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffetX { //左滑
            //1.计算progress
            //floor取整
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            //2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            //3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count{
                targetIndex = childVcs.count - 1
            }
            
            //4.当视图完全划过
            if currentOffsetX - startOffetX == scrollViewW{
                progress = 1
                targetIndex = sourceIndex
            }
        }else{//右滑
            //1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            //2.计算progress
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            //3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count{
                sourceIndex = childVcs.count - 1
            }
            
        }
        
        //4.把progress/targetIndex/sourceIndex传给titleView
        delegate?.pageContentView(contentView: self, progrss: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

//MARK: -对外暴露的方面，要让外面为自己设置一些东西，就要对外设置一些方法
extension PageContentView{
    func setCuttentIndex(currentIndex: Int) {
        //1.记录需要禁止执行代理方法
        isForbidScrollDelegate = true
        
        //2.滚动正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
        
    }
}
