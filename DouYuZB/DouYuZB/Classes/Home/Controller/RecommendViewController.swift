//
//  RecommendViewController.swift
//  DouYuZB
//
//  Created by apple on 2018/5/20.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

private let kItemMargin: CGFloat = 10
private let kItemW: CGFloat = (kScreenW - kItemMargin*3)/2
private let kNormalItemH: CGFloat = kItemW * 3/4
private let kPrettyItemH: CGFloat = kItemW * 4/3
private let kHeaderViewH: CGFloat = 50

private let kCycleViewH = kScreenW * 3 / 8

private let kNormalCellID = "kNormalCellID"
private let kPrettyCellID = "kPrettyCellID"
private let kHeaderViewID = "kHeaderViewID"


class RecommendViewController: UIViewController {
    //MARK: 懒加载属性
    private lazy var recommendVM: RecommendViewModel = RecommendViewModel()
    private lazy var collectionView: UICollectionView = { [unowned self] in
        //1.创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        //设置组头
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        //根据父控制而改变尺寸
         collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //注册cell
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        //注册组头
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        return collectionView
    }()
    private lazy var cycleView : RecommendCycleView = {
        let cycleView = RecommendCycleView.recommendCycleView()
        cycleView.frame = CGRect(x: 0, y: -kCycleViewH, width: kScreenW, height: kCycleViewH)
        return cycleView
    }()
    
    //MARK: 系统会调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.purple
        
        //设置UI界面
        setupUI()
        
        //发送网络请求
        loadDate()
    }
}

//MARK: 设置UI界面内容
extension RecommendViewController{
    private func setupUI(){
        //将UICollectionView添加到View中
        view.addSubview(collectionView)
        
        //将cycleView添加到collectionView中
        collectionView .addSubview(cycleView)
        
        //设置collectionView的内边距
        collectionView.contentInset = UIEdgeInsets(top: kCycleViewH, left: 0, bottom: 0, right: 0)
    }
}

//MARK: 请求数据
extension RecommendViewController{
    private func loadDate(){
        // 1.请求推荐数据
        recommendVM.requestData {
            self.collectionView.reloadData()
        }
        
        // 2.请求轮播数据
        recommendVM.requestCycleData {
            self.cycleView.cycleModels = self.recommendVM.cycleModels
        }
    }
}

//MARK: 遵守UICollectionView数据源协议
extension RecommendViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recommendVM.anchorGroups.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let group = recommendVM.anchorGroups[section]
        
        return group.anchors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //0.取出模型
        let group = recommendVM.anchorGroups[indexPath.section]
        let anchor = group.anchors[indexPath.item]
     
        //1.获取Cell
        if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath) as! CollectionPrettyCell
            
            cell.anchor = anchor
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell
            
            cell.anchor = anchor
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 1.取出sextion中的headerView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        // 2.取出模型
        headerView.group = recommendVM.anchorGroups[indexPath.section]
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if indexPath.section == 1{
            return CGSize(width: kItemW, height: kPrettyItemH)
        }
        return CGSize(width: kItemW, height: kNormalItemH)
    }
}
