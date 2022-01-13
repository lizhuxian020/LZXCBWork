//
//  CBPetSwitchPetPopView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/26.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CBPetSwitchPetPopView: CBPetBaseView,UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    /// 点击完成按钮的回调
    private var selectBlock:((_ petModel:CBPetPsnalCterPetModel) -> Void)?
    ///单例
    static let share:CBPetSwitchPetPopView = {
        let view = CBPetSwitchPetPopView.init()
        return view
    }()
    private lazy var bgmView:UIView = {
        let bgmV = UIView.init()
        bgmV.backgroundColor = UIColor.init().colorWithHexString(hexString: "#222222", alpha: 0.85)
        return bgmV
    }()
    private lazy var devicebListView:UIView = {
        let devicebListView = UIView.init(frame: CGRect.init(x: 0, y: CGFloat(NavigationBarHeigt), width: SCREEN_WIDTH, height: 115*KFitHeightRate))
        devicebListView.backgroundColor = UIColor.white
        return devicebListView
    }()
    private lazy var collectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CBPetSwitchPetCollectionVCell.self, forCellWithReuseIdentifier: "CBPetSwitchPetCollectionVCell")
        return collectionView
    }()
    private lazy var dataSourceArray:[CBPetPsnalCterPetModel] = {
        let arr = [CBPetPsnalCterPetModel]()
        return arr
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setuBgmpView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maskPath = UIBezierPath.init(roundedRect: self.devicebListView.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.bottomLeft.rawValue | UIRectCorner.bottomRight.rawValue), cornerRadii: CGSize(width: 16*KFitHeightRate, height: 16*KFitHeightRate))
        let maskLayer = CAShapeLayer.init()
        /* 设置大小*/
        maskLayer.frame = self.devicebListView.bounds
        /* 设置图形样子*/
        maskLayer.path = maskPath.cgPath
        self.devicebListView.layer.mask = maskLayer
    }
    private func setuBgmpView() {
        self.backgroundColor = UIColor.clear
        self.frame = UIScreen.main.bounds
        
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(keyboardHide))
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = false;
        tapGestureRecognizer.delegate = self;
        //将触摸事件添加到当前view
        self.addGestureRecognizer(tapGestureRecognizer)
        
        self.addSubview(self.bgmView)
        self.bgmView.snp_makeConstraints { (make) in
            make.top.equalTo(NavigationBarHeigt + 30)
            make.left.right.bottom.equalTo(0)
        }
        setupView()
    }
    private func setupView() {
        self.addSubview(self.devicebListView)
        
        self.devicebListView.addSubview(self.collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.devicebListView)
        }
    }
    public func showPopView(selectBlock:@escaping(_ petModel:CBPetPsnalCterPetModel) -> Void) {
        UIApplication.shared.keyWindow!.subviews.forEach { (vv) in
           if vv is CBPetSwitchPetPopView {
               return
           }
        }
        
        UIApplication.shared.keyWindow!.addSubview(self)
        self.selectBlock = selectBlock
        self.alpha = 0
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
           self.alpha = 1
           self.isUserInteractionEnabled = true
        }
        
        getAllDeviceRequest()
    }
    //MARK: - 获取当前用户的宠物列表
    private func getAllDeviceRequest() {
        guard CBPetLoginModelTool.getUser()?.uid != nil else {
            return
        }
        self.dataSourceArray.removeAll()
        var paramters:Dictionary<String,Any> = Dictionary()
        if let value = CBPetLoginModelTool.getUser()?.uid {
            paramters["uid"] = value.valueStr
        }
        MBProgressHUD.showAdded(to: self.devicebListView, animated: true)
        CBPetNetworkingManager.share.getAllDeviceRequest(paramters: paramters, successBlock: { [weak self] (successModel) in
            MBProgressHUD.hide(for: self?.devicebListView ?? UIView.init(), animated: true)
            /* 返回错误信息*/
            guard successModel.status == "0" else {
                MBProgressHUD.showMessage(Msg: successModel.resmsg ?? "请求超时".localizedStr, Deleay: 2.0)
                self!.getAddButtonData()
                return;
            }
            let ddJson = JSON.init(successModel.data as Any)
            let petListModelObject = JSONDeserializer<CBPetPsnalCterPetAllModel>.deserializeFrom(dict: ddJson.dictionaryObject)
            if let value = petListModelObject?.allPet {
                self?.dataSourceArray = value
            }
            
            self!.getAddButtonData()
            
        }) { [weak self] (failureModel) in
            MBProgressHUD.hide(for: self?.devicebListView ?? UIView.init(), animated: true)
            self!.getAddButtonData()
        }
    }
    private func getAddButtonData() {
        var addModel = CBPetPsnalCterPetModel.init()
        addModel.title = "添加".localizedStr
        addModel.icon = "pet_psnal_petDefaultAvatar"
        self.dataSourceArray.append(addModel)
        self.collectionView.reloadData()
    }
    @objc private func keyboardHide(tap:UITapGestureRecognizer) {
        self.dissmiss()
    }
    public func dissmiss() {
        self.dataSourceArray.removeAll()
        self.collectionView.reloadData()
        self.removeFromSuperview()
    }
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        /* 判断该区域是否包含某个指定的区域 */
        if self.devicebListView.frame.contains(gestureRecognizer.location(in: self)) {
            return false
        }
        return true
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellID = "CBPetSwitchPetCollectionVCell"
        let cell:CBPetSwitchPetCollectionVCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CBPetSwitchPetCollectionVCell
        if self.dataSourceArray.count > indexPath.row {
            let petModel = self.dataSourceArray[indexPath.row]
            cell.psnalCterPetModel = petModel
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.dataSourceArray.count > indexPath.row {
            let petModel = self.dataSourceArray[indexPath.row]
            guard self.selectBlock == nil else {
                self.selectBlock!(petModel)
                self.dissmiss()
                return
            }
        }
    }
    /* flowlayoutDelegate */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize.init(width: (SCREEN_WIDTH - 10)/4, height: 90*KFitHeightRate)
        return CGSize.init(width: SCREEN_WIDTH/5, height: 115*KFitHeightRate)
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
