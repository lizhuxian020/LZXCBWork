//
//  CBFunctionCollectionViewCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/4/15.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBFunctionCollectionViewCell: UICollectionViewCell {
    
    lazy var imgeView:UIImageView = {
        let imageView = UIImageView.init()
        return imageView
    }()
    lazy var textLb:UILabel = {
        let lb = UILabel(text: "短信")
        lb.numberOfLines = 0
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        self.addSubview(self.imgeView)
        self.imgeView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(12.5*KFitWidthRate)
            make.size.equalTo(CGSize(width: 40*KFitWidthRate, height: 40*KFitWidthRate))
        }
        self.addSubview(self.textLb)
        self.textLb.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(self.imgeView.snp_bottom)
        }
    }
}
