//
//  GameViewController.swift
//  DouYuZB
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

private let kEdgeMargin : CGFloat = 10
private let kItemW : CGFloat = (kScreenW - 2 * kEdgeMargin) / 3
private let kItemH : CGFloat = kItemW * 6 / 5

class GameViewController: UIViewController {
    
    //MARk: 懒加载
    fileprivate lazy var collectionView: UICollectionView = {[unowned self] in
        // 1.创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        // 2. 创建collectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        
//        collectionView.register(UINib(nibName: "", bundle: nil), forSupplementaryViewOfKind: <#T##String#>, withReuseIdentifier: <#T##String#>)
        
        return collectionView
    }()
    
    
    //MARk: 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
