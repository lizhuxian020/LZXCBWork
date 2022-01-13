//
//  CBPetNoDataView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/2/27.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SnapKit

class CBPetNoDataView: UIView {

    ///背景view
    private lazy var bgView:CBPetBaseView = {
        let bgmV = CBPetBaseView()
        bgmV.backgroundColor = UIColor.white
        return bgmV
    }()
    private lazy var noDataImageView:UIImageView = {
        let bgmV = UIImageView()
        bgmV.backgroundColor = UIColor.white
        return bgmV
    }()
    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "暂无相关数据".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, textAlignment: .center)
        lb.backgroundColor = UIColor.white
        return lb
    }()
    //var imgView:UIImageView = UIImageView()
    //var titleLb:UILabel = UILabel()
//    lazy var imageView_logo:UIImageView = {
//
//    }()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func initWithGrail() {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "ic_empty")
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp_center)
            make.size.equalTo(CGSize.init(width: 50, height: 50))
        }
        noDataImageView = imageView

        let titleLabel = UILabel()
        titleLabel.text = "无数据"
        titleLabel.textColor = UIColor.init().colorWithHexString(hexString: "#b1b1b1")
        titleLabel.font = UIFont.init(name: CBPingFangSC_Regular, size: 14)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(imageView.snp_bottom).offset(15)
        }
        titleLb = titleLabel
    }
    
    func initWithMy() {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "ic_empty")
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 80, height: 80))
        }
        noDataImageView = imageView

        let titleLabel = UILabel()
        titleLabel.text = "无数据"
        titleLabel.textColor = UIColor.init().colorWithHexString(hexString: "#b1b1b1")
        titleLabel.font = UIFont.init(name: CBPingFangSC_Regular, size: 14)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(imageView.snp_bottom).offset(15)
        }
        titleLb = titleLabel
    }
    
    func initWithpp() {
        let titleLabel = UILabel()
        titleLabel.text = "无数据"
        titleLabel.textColor = UIColor.init().colorWithHexString(hexString: "#b1b1b1")
        titleLabel.font = UIFont.init(name: CBPingFangSC_Regular, size: 14)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp_center)
        }
        titleLb = titleLabel
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupBgmView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    //MARK: - 设置view
    private func setupBgmView() {
        self.backgroundColor = UIColor.white
        /// 马上刷新界面  ///self.layoutIfNeeded()        ///强制刷新布局 ///setNeedsLayout
        self.addSubview(self.bgView)
        self.bgView.snp_makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self)
        }
        setupNoDataView()
    }
    private func setupNoDataView() {
        let networkImage = UIImage(named: "pet_noData_icon")!
        self.bgView.addSubview(self.noDataImageView)
        self.bgView.addSubview(self.titleLb)
        self.noDataImageView.image = networkImage
        self.noDataImageView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.bgView)
            make.top.equalTo(self.bgView.snp_top).offset(120*KFitHeightRate+NavigationBarHeigt)
            make.size.equalTo(CGSize(width: networkImage.size.width, height: networkImage.size.height))
        }
        self.titleLb.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.bgView)
            make.top.equalTo(self.noDataImageView.snp_bottom).offset(25*KFitHeightRate)
        }
        
    }
}
