//
//  CBPetFenceAlarmPopView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/7/8.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFenceAlarmPopView: CBPetBaseView,BMKMapViewDelegate {

    /// 点击完成按钮的回调
    private var clickComfirmBtnBlock:(() -> Void)?
    /// 点击取消的回调
    private var clickCancelBtnBlock:(() -> Void)?
    ///单例
    static let share:CBPetFenceAlarmPopView = {
        let view = CBPetFenceAlarmPopView.init()
        return view
    }()
    ///背景view
    private lazy var bgView:CBPetBaseView = {
        let bgmV = CBPetBaseView()
        bgmV.layer.cornerRadius = 16*KFitHeightRate
        bgmV.layer.masksToBounds = true
        bgmV.backgroundColor = UIColor.white
        return bgmV
    }()
    ///标题
    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "围栏警告".localizedStr, textColor: UIColor.init().colorWithHexString(hexString: "#F8563B"), font: UIFont(name: CBPingFang_SC_Bold, size: 16*KFitHeightRate)!, textAlignment: .center)
        return lb
    }()
    ///副标题
    private lazy var subtitleLb:UILabel = {
        let lb = UILabel(text: "", textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, textAlignment: .center)
        //您的宠物“念念”离开了安全区域
        return lb
    }()
    public lazy var baiduView:UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 100*KFitHeightRate))
        view.isHidden = AppDelegate.shareInstance.IsShowGoogleMap
        view.isUserInteractionEnabled = false
        return view
    }()
    public lazy var googleView:UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 100*KFitHeightRate))
        view.isHidden = !AppDelegate.shareInstance.IsShowGoogleMap
        view.isUserInteractionEnabled = false
        return view
    }()
    public lazy var baiduMapView:BMKMapView = {
        let BMKMap = BMKMapView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 100*KFitHeightRate))
        BMKMap.zoomLevel = 16
        /* 百度地图全局转（国测局，谷歌等通用）*/
        BMKMapManager.setCoordinateTypeUsedInBaiduMapSDK(BMK_COORD_TYPE.COORDTYPE_COMMON)
        /* 设定地图View能否支持俯仰角*/
        BMKMap.isOverlookEnabled = false
        return BMKMap
    }()
    public lazy var googleMapView:GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 40.056898, longitude: 116.307626, zoom: 18)
        let googleMap = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH-70*KFitWidthRate, height: 100*KFitHeightRate), camera: camera)
        return googleMap
    }()

    public var avtarImg:UIImage?// UIImage.init(named: "默认宝贝头像")
    /// 完成按钮
    private lazy var comfirmBtn:UIButton = {
        let btn = CBPetBaseButton(title: "查看详情".localizedStr, titleColor: UIColor.white, font: UIFont(name: CBPingFangSC_Regular, size: 16*KFitHeightRate)!, backgroundColor: KPetAppColor, cornerRadius: 20*KFitHeightRate)
        btn.addTarget(self, action: #selector(clickComfirmBtn), for: UIControl.Event.touchUpInside)
        return  btn
    }()
    /// 取消按钮
    private lazy var cancelBtn:UIButton = {
        let btn = CBPetBaseButton(title: "稍后处理".localizedStr, titleColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        btn.underline()
        btn.addTarget(self, action: #selector(clickCancelBtn), for: UIControl.Event.touchUpInside)
        return  btn
    }()
    private lazy var avatarMarkView:CBPetAvatarMarkView = {
        let markView = CBPetAvatarMarkView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        return markView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupBgmView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        /// 防止y超过屏幕
        if self.bgView.frame.size.height >= (SCREEN_HEIGHT - NavigationBarHeigt - TabBARHEIGHT - TabPaddingBARHEIGHT) {
            self.bgView.snp_remakeConstraints { (make) in
                make.center.equalTo(self)
                make.width.equalTo(SCREEN_WIDTH-106*KFitWidthRate)
                make.height.equalTo((SCREEN_HEIGHT - NavigationBarHeigt - TabBARHEIGHT - TabPaddingBARHEIGHT))
            }
        }
    }
    /// 无标题显示弹框,前提初始化时候带标题
    public func showAlert(noticeModel:CBPetNoticeModel,completeBtnBlock:@escaping() -> Void,cancelBtnBlock:@escaping() -> Void) {
        UIApplication.shared.keyWindow!.subviews.forEach { (vv) in
           if vv is CBPetFenceAlarmPopView {
               return
           }
        }
        self.setupAlertView()
        if noticeModel.warmType == "1" {
            self.subtitleLb.text = "您的宠物".localizedStr + " \"\(noticeModel.petName ?? "")\" " + "离开了安全区域".localizedStr
        } else if noticeModel.warmType == "2" {
            self.subtitleLb.text = "您的宠物".localizedStr + " \"\(noticeModel.petName ?? "")\" " + "进入了安全区域".localizedStr
        }
        baiduMapView.viewWillAppear()
        /* 此处记得不用的时候需要置nil，否则影响内存的释放 */
        baiduMapView.delegate = self
        
        UIApplication.shared.keyWindow!.addSubview(self)
        self.clickComfirmBtnBlock = completeBtnBlock
        self.clickCancelBtnBlock = cancelBtnBlock
        self.alpha = 0
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
           self.alpha = 1
           self.isUserInteractionEnabled = true
        }
        self.addMapMarker(noticeModel: noticeModel)
    }
    public func setTitleColor(titleColor:UIColor) {
        self.titleLb.textColor = titleColor
    }
    public func setSubTitleColor(subtitleColor:UIColor) {
        self.subtitleLb.textColor = subtitleColor
    }
    //MARK: - 设置view
    private func setupBgmView() {
        self.backgroundColor = UIColor.init().colorWithHexString(hexString: "#222222", alpha: 0.85)
        self.frame = UIScreen.main.bounds
        /// 马上刷新界面  ///self.layoutIfNeeded()        ///强制刷新布局 ///setNeedsLayout
        self.addSubview(self.bgView)
        self.bgView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(SCREEN_WIDTH-106*KFitWidthRate)
        }
    }
    private func setupAlertView() {
        self.bgView.addSubview(self.titleLb)
        self.titleLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.bgView.snp_top).offset(25*KFitHeightRate)
            make.left.equalTo(self.bgView.snp_left).offset(15*KFitWidthRate)
            make.right.equalTo(self.bgView.snp_right).offset(-15*KFitHeightRate)
        }
        self.bgView.addSubview(self.subtitleLb)
        self.subtitleLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.titleLb.snp_bottom).offset(20*KFitHeightRate)
            make.left.equalTo(self.bgView.snp_left).offset(20*KFitWidthRate)
            make.right.equalTo(self.bgView.snp_right).offset(-20*KFitHeightRate)
        }
        self.bgView.addSubview(self.baiduView)
        self.baiduView.snp_makeConstraints { (make) in
            make.top.equalTo(self.subtitleLb.snp_bottom).offset(20*KFitHeightRate)
            make.left.equalTo(self.bgView.snp_left).offset(0)
            make.right.equalTo(self.bgView.snp_right).offset(0)
            make.height.equalTo(100*KFitHeightRate)
        }
        self.baiduView.addSubview(self.baiduMapView)
        
        self.bgView.addSubview(self.googleView)
        self.googleView.snp_makeConstraints { (make) in
            make.top.equalTo(self.subtitleLb.snp_bottom).offset(20*KFitHeightRate)
            make.left.equalTo(self.bgView.snp_left).offset(0)
            make.right.equalTo(self.bgView.snp_right).offset(0)
            make.height.equalTo(100*KFitHeightRate)
        }
        self.googleView.addSubview(self.googleMapView)
        
        self.bgView.addSubview(self.comfirmBtn)
        self.comfirmBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.baiduView.snp_bottom).offset(20*KFitHeightRate)
            make.left.equalTo(self.bgView.snp_left).offset(25*KFitWidthRate)
            make.right.equalTo(self.bgView.snp_right).offset(-25*KFitWidthRate)
            make.height.equalTo(40*KFitHeightRate)
        }
        self.bgView.addSubview(self.cancelBtn)
        self.cancelBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.comfirmBtn.snp_bottom).offset(10*KFitHeightRate)
            make.left.equalTo(self.bgView.snp_left).offset(25*KFitWidthRate)
            make.right.equalTo(self.bgView.snp_right).offset(-25*KFitWidthRate)
            make.height.equalTo(20*KFitHeightRate)
            make.bottom.equalTo(self.bgView.snp_bottom).offset(-23*KFitHeightRate)
        }
    }
    //MARK: - 移除弹框(内部移除)
    /// 移除弹框(内部移除)
    private func removeView() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] (res) in
            /// 关闭时恢复约束
            self?.bgView.snp_remakeConstraints { (make) in
                make.center.equalTo(self!)
                make.width.equalTo(SCREEN_WIDTH-106*KFitWidthRate)
            }
            self?.removeFromSuperview()
        }
        
        self.baiduMapView.removeAnnotations(self.baiduMapView.annotations)
        self.baiduMapView.viewWillDisappear()
        /* 不用时，置nil */
        self.baiduMapView.delegate = nil
        self.googleMapView.clear()
    }
}
extension CBPetFenceAlarmPopView {
    @objc private func clickComfirmBtn() {
        clickComfirmBtnBlock?()
        self.removeView()
    }
    @objc private func clickCancelBtn() {
        clickCancelBtnBlock?()
        self.removeView()
    }
    public func addMapMarker(noticeModel:CBPetNoticeModel) {
        
        let data = NSData.init(contentsOf: NSURL.init(string: (noticeModel.petPhoto ?? ""))! as URL)
        let originalImage = UIImage.init(data: (data as Data? ?? Data.init()))
        var thuImage = UIImage.imageByScalingAndCroppingForSourceImage(sourceImage: originalImage ?? UIImage.init(), targetSize: CGSize(width: 92, height: 92))
        thuImage = thuImage.imageConvertRoundCorner(radius: thuImage.size.height, borderWidth: 1.5, borderColor: UIColor.white)
        self.avtarImg = thuImage
        
        let coord = CLLocationCoordinate2DMake(Double(noticeModel.lat ?? "0")!, Double(noticeModel.lng ?? "0")!)
        guard AppDelegate.shareInstance.IsShowGoogleMap == true else {
            self.baiduMapView.removeAnnotations(self.baiduMapView.annotations)
            self.baiduMapView.setCenter(coord, animated: true)
            let normalAnnotation = CBPetNormalAnnotation.init()
            normalAnnotation.coordinate = coord
            normalAnnotation.title = nil
            self.baiduMapView.addAnnotation(normalAnnotation)
            return
        }
        
        let marker = GMSMarker.init()
        marker.position = coord
        marker.iconView = self.avatarMarkView
        marker.map = self.googleMapView
        self.avatarMarkView.updateIconImage(iconImage: self.avtarImg ?? UIImage.init(named: "pet_mapAvatar_default")!)
        self.googleMapView.camera = GMSCameraPosition.camera(withLatitude: Double(noticeModel.lat ?? "0")!, longitude: Double(noticeModel.lng ?? "0")!, zoom: 15)
    }
    // MARK: - BMKMapViewDelegate
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if annotation is CBPetNormalAnnotation {
            let annotationView = CBAvatarAnnotionView.annotationViewCopyMapView(mapView: mapView, annotation: annotation)
            annotationView.updateIconImage(iconImage: self.avtarImg ?? UIImage.init(named: "pet_mapAvatar_default")!)
            let imageDefault = UIImage.init(named: "pet_mapAvatar_default")!
            annotationView.image = UIImage()
            annotationView.centerOffset = CGPoint(x: 0, y: -(imageDefault.size.height)/2)
            return annotationView
         }
        return nil
    }
}

