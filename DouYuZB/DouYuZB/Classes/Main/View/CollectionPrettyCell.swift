//
//  CollectionPrettyCell.swift
//  DouYuZB
//
//  Created by apple on 2018/5/20.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionPrettyCell: UICollectionViewCell {
    //MARK: 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var onlineBtn: UIButton!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var cityBtn: UIButton!
    
    //MARK: 定义模型属性
    var anchor: AnchorModel?{
        didSet{
            //0.校验模型是否有值
            guard let anchor = anchor else { return }
            //1.取出在线人数显示的文字
            var onlineStr: String = ""
            if anchor.online > 10000{
                onlineStr = "\(Int(anchor.online/10000))万人在线"
            }else{
                onlineStr = "\(anchor.online)在线"
            }
            onlineBtn.setTitle(onlineStr, for: .normal)
            
            //2.昵称显示
            nickNameLabel.text = anchor.nickname
            
            //3.所在城市
            cityBtn.setTitle("\(anchor.anchor_city)", for: .normal)
            
            //4.设置封面图片
            guard let iconURL = URL(string: anchor.vertical_src) else { return }
            iconImageView.kf.setImage(with: iconURL)
        }
    }
    
}
