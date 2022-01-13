//
//  CBPetFunctionPopView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/26.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFunctionPopView: CBPetBaseView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    private lazy var shadowBgmView:UIView = {
        let bgmV = UIView(backgroundColor: UIColor.white, cornerRadius: 16*KFitHeightRate, shadowColor: KPetC8C8C8Color, shadowOpacity: 0.85, shadowOffset: CGSize(width: 4, height: 0), shadowRadius: 8)
        return bgmV
    }()
    private lazy var functionView:UIView = {
        let functionView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        functionView.backgroundColor = UIColor.white
        return functionView
    }()
    private var titleLb:UILabel = {
        let lb = UILabel(text: "我的工具".localizedStr, textColor: KPetTextColor, font: UIFont.init(name: CBPingFangSC_Regular, size: 13*KFitHeightRate)!)
        return lb
    }()
    private var tapButton:CBPetBaseButton = {
        let btn = CBPetBaseButton.init()
        btn.layer.cornerRadius = 2*KFitHeightRate
        btn.backgroundColor = KPetC8C8C8Color
        btn.addTarget(self, action: #selector(showOrHiddenClick), for: .touchUpInside)
        return btn
    }()
    private lazy var dataSourceImage:[Any] = {
        let arr = self.titleArray_normal
        return arr
    }()
    private lazy var dataSourceTitle:[Any] = {
        let arr = self.imageArray_normal
        return arr
    }()
    private lazy var imageArray_normal:[Any] = {
        let arr = [Any]()
        return arr
    }()
    private lazy var titleArray_normal:[Any] = {
        let arr = [Any]()
        return arr
    }()
    private lazy var imageArray_admin:[Any] = {
        let arr = [Any]()
        return arr
    }()
    private lazy var titleArray_admin:[Any] = {
        let arr = [Any]()
        return arr
    }()
    private var collectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CBPetFunctionCollectionCell.self, forCellWithReuseIdentifier: "CBPetFunctionCollectionCell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let maskPath = UIBezierPath.init(roundedRect: self.functionView.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue), cornerRadii: CGSize(width: 16*KFitHeightRate, height: 16*KFitHeightRate))
        let maskLayer = CAShapeLayer.init()
        /* 设置大小*/
        maskLayer.frame = self.functionView.bounds
        /* 设置图形样子*/
        maskLayer.path = maskPath.cgPath
        self.functionView.layer.mask = maskLayer
    }
    private func setupView() {
        self.backgroundColor = UIColor.init().colorWithHexString(hexString: "#222222", alpha: 0.00)//UIColor.white
        
        self.addSubview(self.shadowBgmView)
        self.shadowBgmView.snp_makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        }
        self.addSubview(self.functionView)
        self.functionView.addSubview(self.titleLb)
        self.titleLb.snp_makeConstraints { (make) in
            make.top.equalTo(12*KFitHeightRate)
            make.left.equalTo(20*KFitWidthRate)
        }
        
        self.functionView.addSubview(self.tapButton)
        self.tapButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.functionView.snp_centerX)
            make.centerY.equalTo(self.titleLb.snp_centerY)
            make.size.equalTo(CGSize(width: 36*KFitWidthRate, height: 3*KFitHeightRate))
        }

        self.functionView.addSubview(self.collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.functionView)
            make.top.equalTo(50*KFitHeightRate)
            make.height.equalTo(150*KFitHeightRate)
        }
    }
    @objc public func showOrHiddenClick (sender:CBPetBaseButton) {
        sender.isSelected = !sender.isSelected
        self.titleLb.isHidden = sender.isSelected
        guard (self.viewModel as! CBPetHomeViewModel).functionViewBlock == nil else {
            (self.viewModel as! CBPetHomeViewModel).functionViewBlock!(sender.isSelected,"")
            return
        }
    }
    func updateFunctionDataSource() {
        
        if let value = CBPetHomeInfoTool.getHomeInfo().devUser.isAdmin {
            // pet_function_wakeup
            if value.valueStr == "1" {
                /* 管理员*/
                let arrImage_normal = ["pet_function_shout","pet_function_listen","pet_function_gohome","pet_function_punishment","pet_function_locate","pet_function_chat","pet_function_userManagement"]
                let arrTitle_normal = ["喊话".localizedStr,"听听".localizedStr,"回家".localizedStr,"惩罚".localizedStr,"定位".localizedStr,"微聊".localizedStr,"用户管理".localizedStr]
                let arrImage_normal_2g = ["pet_function_shout","pet_function_listen","pet_function_gohome","pet_function_punishment","pet_function_locate","pet_function_chat","pet_function_userManagement","pet_function_wakeup"]
                let arrTitle_normal_2g = ["喊话".localizedStr,"听听".localizedStr,"回家".localizedStr,"惩罚".localizedStr,"定位".localizedStr,"微聊".localizedStr,"用户管理".localizedStr,"唤醒".localizedStr]
                guard let simCardType = CBPetHomeInfoTool.getHomeInfo().pet.device.simCardType else {
                    self.dataSourceTitle = arrTitle_normal
                    self.dataSourceImage = arrImage_normal
                    self.collectionView.reloadData()
                    return
                }
                if simCardType == "1" {
                    self.dataSourceTitle = arrTitle_normal_2g
                    self.dataSourceImage = arrImage_normal_2g
                    self.collectionView.reloadData()
                } else {
                    self.dataSourceTitle = arrTitle_normal
                    self.dataSourceImage = arrImage_normal
                    self.collectionView.reloadData()
                }
            } else {
                /* 0或无为非管理员 */
                let arrImage_normal = ["pet_function_shout","pet_function_listen","pet_function_gohome","pet_function_punishment","pet_function_locate"]
                let arrTitle_normal = ["喊话".localizedStr,"听听".localizedStr,"回家".localizedStr,"惩罚".localizedStr,"定位".localizedStr]
                let arrImage_normal_2g = ["pet_function_shout","pet_function_listen","pet_function_gohome","pet_function_punishment","pet_function_locate","pet_function_wakeup"]
                let arrTitle_normal_2g = ["喊话".localizedStr,"听听".localizedStr,"回家".localizedStr,"惩罚".localizedStr,"定位".localizedStr,"唤醒".localizedStr]
                guard let simCardType = CBPetHomeInfoTool.getHomeInfo().pet.device.simCardType else {
                    self.dataSourceTitle = arrTitle_normal
                    self.dataSourceImage = arrImage_normal
                    self.collectionView.reloadData()
                    return
                }
                if simCardType == "1" {
                    self.dataSourceTitle = arrTitle_normal_2g
                    self.dataSourceImage = arrImage_normal_2g
                    self.collectionView.reloadData()
                } else {
                    self.dataSourceTitle = arrTitle_normal
                    self.dataSourceImage = arrImage_normal
                    self.collectionView.reloadData()
                }
            }
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSourceTitle.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellID = "CBPetFunctionCollectionCell"
        let cell:CBPetFunctionCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CBPetFunctionCollectionCell
        if self.dataSourceTitle.count > indexPath.row {
            cell.textLb.text = "\(self.dataSourceTitle[indexPath.row])"
            cell.iconImgeView.image = UIImage.init(named: "\(self.dataSourceImage[indexPath.row])")
            return cell
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.dataSourceTitle.count > indexPath.row {
            let titleStr = self.dataSourceTitle[indexPath.row]
            guard (self.viewModel as! CBPetHomeViewModel).functionViewBlock == nil else {
                (self.viewModel as! CBPetHomeViewModel).functionViewBlock!(false,titleStr as! String)
                return
            }
        }
    }
    /* flowlayoutDelegate */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: SCREEN_WIDTH/4, height: 75*KFitHeightRate)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    //        if section == 0 {
    //            return CGSize.init(width: SCREEN_WIDTH, height: 0)
    //        }
    //        return CGSize.init(width: SCREEN_WIDTH, height: 52.5*KFitWidthRate)
    //    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
