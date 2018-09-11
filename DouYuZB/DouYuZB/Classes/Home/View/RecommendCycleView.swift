//
//  RecommendCycleView.swift
//  DouYuZB
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit
private let kCycleCellID = "kCycleCellID"

class RecommendCycleView: UIView {
    
    //MARK:- 定义属性
    var cycleModels : [CycleModel]? {
        didSet{
            // 1.刷新collectionView
            collectionView.reloadData()
            
            // 2.设置pageControl个数
            pageControl.numberOfPages = cycleModels?.count ?? 0
        }
    }
    
    //MARK:- 控件属性
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK:- 系统回调函数
    override func awakeFromNib() {
        //设置该控件不随着父控件的拉伸而拉伸
        autoresizingMask = UIViewAutoresizing()
        
        //注册cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCycleCellID)
    }
    
    override func layoutSubviews() {
        //设置collectionViewdelayout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
    }
    
}
//MARK:- 提供一个快速创建Viewde方法
extension RecommendCycleView{
    class func recommendCycleView() -> RecommendCycleView {
        return Bundle.main.loadNibNamed("RecommendCycleView", owner: nil, options: nil)?.first as! RecommendCycleView
    }
}
//MARK:- 遵守UICollection数据源协议
extension RecommendCycleView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cycleModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath)
        let cycleModel = cycleModels![indexPath.item]
        
        cell.backgroundColor = UIColor.red
        
        return cell
        
    }
    
    
}
