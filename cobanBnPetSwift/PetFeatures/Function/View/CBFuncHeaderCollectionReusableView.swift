//
//  CBFuncHeaderCollectionReusableView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/4/15.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBFuncHeaderCollectionReusableView: UICollectionReusableView {
    
    lazy var titleLb:UILabel = {
        let lb = UILabel(text: "常见功能")
        return lb
    }()
    private lazy var mainView:UIView = {
        let mainV = UIView.init()
        mainV.backgroundColor = .white
        return mainV
    }()
    private lazy var line:UIView = {
        let line = CBPetUtilsCreate.createLineView()
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        self.backgroundColor = RGB(r: 237, g: 237, b: 237)
        self.addSubview(self.mainView)
        self.mainView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(12.5*KFitHeightRate)
        }
        self.mainView.addSubview(self.titleLb)
        self.titleLb.snp_makeConstraints { (make) in
            make.left.equalTo(self.mainView.snp_left).offset(12.5*KFitWidthRate)
            make.bottom.top.equalTo(self.mainView)
            make.right.equalTo(self.mainView.snp_right).offset(-12.5*KFitWidthRate)
        }
        self.addSubview(self.line)
        self.line.snp_makeConstraints { (make) in
            make.left.equalTo(self.mainView.snp_left).offset(12.5*KFitWidthRate)
            make.right.equalTo(self.mainView.snp_right).offset(-12.5*KFitWidthRate)
            make.bottom.equalTo(self.mainView)
            make.height.equalTo(0.5)
        }
    }
}
