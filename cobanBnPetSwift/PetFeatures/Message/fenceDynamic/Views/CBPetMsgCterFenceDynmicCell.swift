//
//  CBPetMsgCterFenceDynmicCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/5.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetMsgCterFenceDynmicCell: CBPetBaseTableViewCell,BMKMapViewDelegate,BMKGeoCodeSearchDelegate {

    private lazy var timeLb:UILabel = {
        let lb = UILabel(text: "2020/5/5 09:12".localizedStr, textColor: KPet999999Color, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!,textAlignment: .center)
        return lb
    }()
    private lazy var bgmView:UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        return view
    }()
    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "围栏警告".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFang_SC_Bold, size: 14*KFitHeightRate)!,textAlignment: .left)
        return lb
    }()
    private lazy var textLb:UILabel = {
        ///"您的宠物“念念”离开了安全区域"
        let lb = UILabel(text: "".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!,textAlignment: .left)
        /* label中文与数字混合导致换行*/
        lb.lineBreakMode = .byCharWrapping
        return lb
    }()
    private lazy var mapView:UIView = {
        let view = UIView.init()
        view.backgroundColor = KPetAppColor
        return view
    }()
    private lazy var lineView:UIView = {
        let view = UIView.init()
        view.backgroundColor = KPetLineColor
        return view
    }()
    private lazy var showBtn_text:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "点击查看".localizedStr, titleColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!)
        return btn
    }()
    private lazy var showBtn_image:CBPetBaseButton = {
        let btn = CBPetBaseButton(imageName: "pet_psnal_rightArrow")
        return btn
    }()
    
    
    public lazy var baiduMapView:BMKMapView = {
        let BMKMap = BMKMapView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH-70*KFitWidthRate, height: 120*KFitHeightRate))
        BMKMap.zoomLevel = 16
        BMKMap.centerCoordinate = CLLocationCoordinate2DMake(40.056898, 116.307626)
        /* 百度地图全局转（国测局，谷歌等通用）*/
        BMKMapManager.setCoordinateTypeUsedInBaiduMapSDK(BMK_COORD_TYPE.COORDTYPE_COMMON)
        ///设定地图View能否支持用户多点缩放(双指)
//        BMKMap.isZoomEnabled = false
//        ///设定地图View能否支持用户缩放(双击或双指单击)
//        BMKMap.isZoomEnabledWithTap = false
//        ///设定地图View能否支持用户移动地图
//        BMKMap.isScrollEnabled = false
//        ///设定地图View能否支持俯仰角
//        BMKMap.isOverlookEnabled = false
//        ///设定地图View能否支持旋转
//        BMKMap.isRotateEnabled = false
        return BMKMap
    }()
    public lazy var googleMapView:GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 40.056898, longitude: 116.307626, zoom: 18)
        let googleMap = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH-70*KFitWidthRate, height: 120*KFitHeightRate), camera: camera)
        return googleMap
    }()
    public lazy var baiduView:UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH-70*KFitWidthRate, height: 120*KFitHeightRate))
        view.isHidden = AppDelegate.shareInstance.IsShowGoogleMap
        view.isUserInteractionEnabled = false
        return view
    }()
    public lazy var googleView:UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH-70*KFitWidthRate, height: 120*KFitHeightRate))
        view.isHidden = !AppDelegate.shareInstance.IsShowGoogleMap
        view.isUserInteractionEnabled = false
        return view
    }()
    public lazy var searcher:BMKGeoCodeSearch = {
        let search = BMKGeoCodeSearch.init()
        return search
    }()
    public var avtarImg:UIImage?// UIImage.init(named: "默认宝贝头像")
    public lazy var avtarImgView:UIImageView = {
        let avtarImgV = UIImageView.init(frame: CGRect.init(x: 0, y: 5/2, width: 35, height: 35))
        avtarImgV.isUserInteractionEnabled = true
        avtarImgV.backgroundColor = UIColor.white
        avtarImgV.layer.masksToBounds = false;
        avtarImgV.layer.cornerRadius = 35/2;
        avtarImgV.contentMode = .scaleAspectFill//.scaleAspectFit//.scaleAspectFill;
        return avtarImgV
    }()
    public var homeInfoModel:CBPetHomeInfoModel = CBPetHomeInfoModel()
    
    private lazy var avatarMarkView:CBPetAvatarMarkView = {
        let markView = CBPetAvatarMarkView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        return markView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        self.bgmView.layer.masksToBounds = true
        self.bgmView.layer.cornerRadius = 12*KFitHeightRate
        self.mapView.layer.masksToBounds = true
        self.mapView.layer.cornerRadius = 5*KFitHeightRate
    }
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = KPetBgmColor
        
        /* 判断系统语言展示百度地图或者谷歌地图*/
        AppDelegate.shareInstance.IsShowGoogleMap = AppDelegate.isShowGoogle()
    
        self.contentView.addSubview(self.timeLb)
        self.contentView.addSubview(self.bgmView)
        self.bgmView.addSubview(self.titleLb)
        self.bgmView.addSubview(self.mapView)
        
        self.mapView.addSubview(self.baiduView)
        self.baiduView.addSubview(self.baiduMapView)
        self.mapView.addSubview(self.googleView)
        self.googleView.addSubview(self.googleMapView)
        
        self.bgmView.addSubview(self.lineView)
        self.bgmView.addSubview(self.textLb)
        self.bgmView.addSubview(self.showBtn_text)
        self.bgmView.addSubview(self.showBtn_image)
        
        self.timeLb.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(20*KFitHeightRate)
        }
        self.bgmView.snp_makeConstraints { (make) in
            make.top.equalTo(self.timeLb.snp_bottom).offset(10*KFitHeightRate)
            make.right.equalTo(-20*KFitHeightRate)
            make.left.equalTo(20*KFitHeightRate)
            make.bottom.equalTo(0)
        }
        self.titleLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.bgmView.snp_top).offset(15*KFitHeightRate)
            make.left.equalTo(self.bgmView.snp_left).offset(15*KFitWidthRate)
        }
        self.textLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.titleLb.snp_bottom).offset(12*KFitHeightRate)
            make.left.equalTo(self.bgmView.snp_left).offset(15*KFitWidthRate)
            make.right.equalTo(self.bgmView.snp_right).offset(-15*KFitWidthRate)
        }
        self.mapView.snp_makeConstraints { (make) in
            make.top.equalTo(self.textLb.snp_bottom).offset(15*KFitHeightRate)
            make.left.equalTo(self.bgmView.snp_left).offset(15*KFitWidthRate)
            make.right.equalTo(self.bgmView.snp_right).offset(-15*KFitWidthRate)
            make.height.equalTo(120*KFitHeightRate)
        }
        self.lineView.snp_makeConstraints { (make) in
            make.top.equalTo(self.mapView.snp_bottom).offset(15*KFitHeightRate)
            make.left.equalTo(self.bgmView.snp_left).offset(0)
            make.right.equalTo(self.bgmView.snp_right).offset(0)
            make.height.equalTo(1)
        }
        self.showBtn_text.snp_makeConstraints { (make) in
            make.top.equalTo(self.lineView.snp_bottom).offset(12*KFitHeightRate)
            make.left.equalTo(self.bgmView.snp_left).offset(15*KFitWidthRate)
            make.bottom.equalTo(self.bgmView.snp_bottom).offset(-12*KFitHeightRate)
        }
        let showImage = UIImage(named: "pet_msg_hideDetail")!
        self.showBtn_image.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.showBtn_text)
            make.right.equalTo(self.bgmView.snp_right).offset(-15*KFitWidthRate)
            make.size.equalTo(CGSize(width: showImage.size.width, height: showImage.size.height))
        }
        self.showBtn_text.addTarget(self, action: #selector(toDetailAction), for: .touchUpInside)
        self.showBtn_image.addTarget(self, action: #selector(toDetailAction), for: .touchUpInside)
        
        baiduMapView.viewWillAppear()
        /* 此处记得不用的时候需要置nil，否则影响内存的释放 */
        baiduMapView.delegate = self
    }
    deinit {
        baiduMapView.viewWillDisappear()
        /* 不用时，置nil */
        baiduMapView.delegate = nil
    }
    var msgCterFenceModel = CBPetMsgCterFenceDynamicModel() {
        didSet {
            self.timeLb.text = ""
            if let value = self.msgCterFenceModel.addTime {
                //self.timeLb.text = CBPetUtils.convertTimestampToDateStr(timestamp: vaule.valueStr, formateStr: "yyyy-MM-dd HH:mm:ss")
                if let valueTimeZone = CBPetHomeParamtersModel.getHomeParamters().timeZone {
                    self.timeLb.text = CBPetUtils.convertTimestampToDateStr(timestamp: value.valueStr, formateStr: "yyyy-MM-dd HH:mm:ss",timeZone: Int(valueTimeZone) ?? 0)
                }
            }
            self.titleLb.text = "围栏警告".localizedStr
            if self.msgCterFenceModel.fenceAlarmType == "1" {
                self.textLb.text = "您的宠物".localizedStr + " \"\(self.msgCterFenceModel.petName ?? "")\" " + "离开了安全区域".localizedStr
            } else if self.msgCterFenceModel.fenceAlarmType == "2" {
                self.textLb.text = "您的宠物".localizedStr + " \"\(self.msgCterFenceModel.petName ?? "")\" " + "进入了安全区域".localizedStr
            }
            
            let data = NSData.init(contentsOf: NSURL.init(string: (self.msgCterFenceModel.petHead ?? ""))! as URL)
            let originalImage = UIImage.init(data: (data as Data? ?? Data.init()))
            var thuImage = UIImage.imageByScalingAndCroppingForSourceImage(sourceImage: originalImage ?? UIImage.init(), targetSize: CGSize(width: 92, height: 92))
            thuImage = thuImage.imageConvertRoundCorner(radius: thuImage.size.height, borderWidth: 1.5, borderColor: UIColor.white)
            self.avtarImg = thuImage
            
            self.addMapMarker()
        }
    }
    @objc private func toDetailAction(sender:CBPetBaseButton) {
        CBLog(message: "点击查看围栏d警告详情")
        if self.viewModel is CBPetMsgCterViewModel {
            guard (self.viewModel as! CBPetMsgCterViewModel).pushBlock == nil else {
                (self.viewModel as! CBPetMsgCterViewModel).pushBlock!(self.msgCterFenceModel)
                return
            }
        }
    }
    public func addMapMarker() {
        guard AppDelegate.shareInstance.IsShowGoogleMap == true else {
            self.baiduMapView.removeAnnotations(self.baiduMapView.annotations)
            self.baiduMapView.setCenter(CLLocationCoordinate2DMake(Double(self.msgCterFenceModel.alarmLat ?? "0")!, Double(self.msgCterFenceModel.alarmLng ?? "0")!), animated: true)
            let normalAnnotation = CBPetNormalAnnotation.init()
            normalAnnotation.coordinate = CLLocationCoordinate2DMake(Double(self.msgCterFenceModel.alarmLat ?? "0")!, Double(self.msgCterFenceModel.alarmLng ?? "0")!)
            normalAnnotation.title = nil
            self.baiduMapView.addAnnotation(normalAnnotation)
            return
        }
        self.googleMapView.clear()
    //        self.googleMapView.camera = GMSCameraPosition.camera(withLatitude: Double(self.homeInfoModel.tbWatchMain.lat ?? "0")!, longitude: Double(self.homeInfoModel.tbWatchMain.lng ?? "0")!, zoom: 18)
        let marker = GMSMarker.init()
        marker.position = CLLocationCoordinate2DMake(Double(self.msgCterFenceModel.alarmLat ?? "0")!, Double(self.msgCterFenceModel.alarmLng ?? "0")!)
        marker.iconView = self.avatarMarkView
        marker.map = self.googleMapView
        self.avatarMarkView.updateIconImage(iconImage: self.avtarImg ?? UIImage.init(named: "pet_mapAvatar_default")!)
        self.avatarMarkView.defaultImageView.image = UIImage(named: "pet_mapAvatar_default_alarmV2")!
        self.googleMapView.camera = GMSCameraPosition.camera(withLatitude: Double(self.msgCterFenceModel.alarmLat ?? "0")!, longitude: Double(self.msgCterFenceModel.alarmLng ?? "0")!, zoom: 15)
    }
// MARK: - BMKGeoCodeSearchDelegate
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeSearchResult!, errorCode error: BMKSearchErrorCode) {
        switch error {
        case BMK_SEARCH_NO_ERROR:
            //self.homeInfoView.addressLb.text = result.address
            break
        default:
            //self.homeInfoView.addressLb.text = ""
            CBLog(message:"未找地理位置")
            break
        }
    }
    // MARK: - BMKMapViewDelegate
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if annotation is CBPetNormalAnnotation {
            let annotationView = CBAvatarAnnotionView.annotationViewCopyMapView(mapView: mapView, annotation: annotation)
            annotationView.updateIconImage(iconImage: self.avtarImg ?? UIImage.init(named: "pet_mapAvatar_default")!)
            annotationView.defaultImageView.image = UIImage(named: "pet_mapAvatar_default_alarmV2")!
            let imageDefault = UIImage.init(named: "pet_mapAvatar_default")!
            annotationView.image = UIImage()
            annotationView.centerOffset = CGPoint(x: 0, y: -(imageDefault.size.height)/2)
            return annotationView
         } else if annotation is CBPetFenceAnnotation {
            let annotationViewID = "CBPetFenceAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationViewID)
            if annotationView == nil {
                annotationView = CBPetFenceAnnotionView.init(annotation: annotation, reuseIdentifier: annotationViewID)
            }
            annotationView?.image = UIImage()
            return annotationView
        }
    
        return nil
    }
    func mapView(_ mapView: BMKMapView!, click view: BMKAnnotationView!) {
        // 点击标注事件
//        print("百度地图点击了标注")
//        let locationVC = CBLocationViewController.init()
//        self.navigationController?.pushViewController(locationVC, animated: true)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
