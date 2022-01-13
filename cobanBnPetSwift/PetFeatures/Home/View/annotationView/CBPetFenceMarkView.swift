//
//  CBPetFenceMarkView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/8/31.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFenceMarkView: CBPetBaseView {

    private var whiteView:UIView = {
        let vv = UIView()
        vv.backgroundColor = UIColor.white
        return vv
    }()
    private var redView:UIView = {
        let vv = UIView()
        vv.backgroundColor = UIColor.init().colorWithHexString(hexString: "#F8563B")
        return vv
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.whiteView.layer.masksToBounds = true
        self.whiteView.layer.cornerRadius = 6*KFitHeightRate
        
        self.redView.layer.masksToBounds = true
        self.redView.layer.cornerRadius = 4*KFitHeightRate
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        self.bounds = CGRect.init(x: 0, y: 0, width: 12*KFitHeightRate, height: 12*KFitHeightRate)
        self.addSubview(self.whiteView)
        self.whiteView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 12*KFitHeightRate, height: 12*KFitHeightRate))
        }
        self.addSubview(self.redView)
        self.redView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 8*KFitHeightRate, height: 8*KFitHeightRate))
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
}
