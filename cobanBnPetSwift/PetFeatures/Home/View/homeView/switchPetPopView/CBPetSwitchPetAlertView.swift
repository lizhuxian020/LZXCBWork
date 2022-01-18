//
//  CBPetSwitchPetAlertView.swift
//  cobanBnPetSwift
//
//  Created by lee on 2022/1/18.
//  Copyright © 2022 coban. All rights reserved.
//

import Foundation
import SwiftyJSON
import HandyJSON
import UIKit


class CBPetSwitchPetAlertView : CBPetBaseView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let itemW = SCREEN_WIDTH/5
    let itemH = 100*KFitHeightRate
    let contentH : CGFloat = 300.0
    
    private var bgView : UIView = UIView.init()
    private var contentView : UIView = UIView.init()
    private var activityView : UIActivityIndicatorView = {
        let av = UIActivityIndicatorView.init(style: .gray)
        return av
    }()
    private var collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0;
        let collectionView = UICollectionView.init(frame: CGRect.init(), collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CBPetSwitchPetCollectionVCell.self, forCellWithReuseIdentifier: "CBPetSwitchPetCollectionVCell")
        return collectionView
    }()
    private var dataSource : [CBPetPsnalCterPetModel] = [CBPetPsnalCterPetModel]()
    
    public func showContent() {
        
        UIApplication.shared.keyWindow!.addSubview(self)
        
        self.getAllDeviceRequest()
        
        self.isHidden = false
        self.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
            self.contentView.frame = CGRect.init(x: 0, y: NavigationBarHeigt, width: self.itemW, height: self.contentH)
            self.collectionView.frame = self.contentView.bounds
        } completion: { _ in
            
        }

        self.makeCorner()
    }
    
    @objc public func dismiss() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
            self.contentView.frame = CGRect.init(x: 0, y: NavigationBarHeigt, width: self.itemW, height: 0)
            self.collectionView.frame = self.contentView.bounds
        } completion: { _ in
            self.isHidden = true
            
            self.removeFromSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.backgroundColor = .clear
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(dismiss))
        self.addGestureRecognizer(tapGes)
        
        self.addSubview(bgView)
        bgView.frame = self.bounds
        bgView.backgroundColor = .clear
        
        contentView.backgroundColor = UIColor.init(white: 1, alpha: 0.8)
        self.addSubview(contentView)
        contentView.frame = CGRect.init(x: 0, y: NavigationBarHeigt, width: itemW, height: 0)
        
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        contentView.addSubview(collectionView)
        self.collectionView.frame = self.contentView.bounds
        
        contentView.addSubview(activityView)
        activityView.frame = CGRect.init(x: 0, y: (contentH-itemW)/2.0, width: itemW, height: itemW)
        activityView.isHidden = true
        
        self.isHidden = true
        self.alpha = 0;
    }
    
    private func makeCorner() {
        let maskPath = UIBezierPath.init(roundedRect: self.contentView.bounds, byRoundingCorners: UIRectCorner.bottomRight, cornerRadii: CGSize.init(width: 15, height: 15))
        let maskLayer = CAShapeLayer.init()
        /* 设置大小*/
        maskLayer.frame = self.contentView.bounds
        /* 设置图形样子*/
        maskLayer.path = maskPath.cgPath
        self.contentView.layer.mask = maskLayer
    }
    
    //MARK: - 获取当前用户的宠物列表
    private func getAllDeviceRequest() {
        guard let uid = CBPetLoginModelTool.getUser()?.uid else {
            return
        }
        self.collectionView.isHidden = true
        var param : [String : Any] = Dictionary()
        param["uid"] = uid
//        MBProgressHUD.showAdded(to: self.contentView, animated: true)
        activityView.isHidden = false
        activityView.startAnimating()
        CBPetNetworkingManager.share.getAllDeviceRequest(paramters: param) { [weak self] (successModel) in
            guard self != nil else {return}
            self!.activityView.isHidden = true
            self!.activityView.stopAnimating()
            /* 返回错误信息*/
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                self?.dataSource.removeAll()
                self!.getAddButtonData()
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            let petListModelObject = JSONDeserializer<CBPetPsnalCterPetAllModel>.deserializeFrom(dict: ddJson.dictionaryObject)
            if let value = petListModelObject?.allPet {
                self?.dataSource = value
            }

            self!.getAddButtonData()
        } failureBlock: { [weak self] (erroModel) in
            guard self != nil else {return}
            self!.activityView.isHidden = true
            self!.activityView.stopAnimating()
            self?.dataSource.removeAll()
            self!.getAddButtonData()
        }

    }
    
    private func getAddButtonData() {
        self.collectionView.isHidden = false
        var addModel = CBPetPsnalCterPetModel.init()
        addModel.title = "添加".localizedStr
        addModel.icon = "pet_psnal_petDefaultAvatar"
        self.dataSource.append(addModel)
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CBPetSwitchPetCollectionVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CBPetSwitchPetCollectionVCell", for: indexPath) as! CBPetSwitchPetCollectionVCell
        cell.psnalCterPetModel = self.dataSource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: itemW, height: itemH)
    }
}
