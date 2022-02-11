//
//  CBPetChatNearbyPetsView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/30.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import CoreLocation

class CBPetChatNearbyPetsView: CBPetBaseView,BMKMapViewDelegate,BMKGeoCodeSearchDelegate,GMSMapViewDelegate {
    
    public var baiduMapView:BMKMapView = {
        let BMKMap = BMKMapView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        BMKMap.zoomLevel = 16
        //BMKMap.centerCoordinate = CLLocationCoordinate2DMake(40.056898, 116.307626)
        /* 百度地图全局转（国测局，谷歌等通用）*/
        BMKMapManager.setCoordinateTypeUsedInBaiduMapSDK(BMK_COORD_TYPE.COORDTYPE_COMMON)
        /* 设定地图View能否支持俯仰角*/
        BMKMap.isOverlookEnabled = false
        return BMKMap
    }()
    public var googleMapView:GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 40.056898, longitude: 116.307626, zoom: 18)
        let googleMap = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), camera: camera)
        return googleMap
    }()
    public var baiduView:UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        view.isHidden = true//AppDelegate.shareInstance.IsShowGoogleMap
        return view
    }()
    public var googleView:UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        view.isHidden = !AppDelegate.shareInstance.IsShowGoogleMap
        return view
    }()
    public var searcher:BMKGeoCodeSearch = {
        let search = BMKGeoCodeSearch.init()
        return search
    }()
    private lazy var updBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(imageName: "pet_func_updBtn")
        return btn
    }()
    public var avtarImg:UIImage?// UIImage.init(named: "默认宝贝头像")
    public var homeInfoModel:CBPetHomeInfoModel = CBPetHomeInfoModel()
    
    private lazy var avatarMarkView:CBPetAvatarMarkView = {
        let markView = CBPetAvatarMarkView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        return markView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        baiduMapView.viewWillAppear()
        /* 此处记得不用的时候需要置nil，否则影响内存的释放 */
        baiduMapView.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
        if self.viewModel is CBPetFuncChatViewModel {
            let vvModel = self.viewModel as! CBPetFuncChatViewModel
            /* 附近宠物*/
            vvModel.petFriendsUpdNearPetsUIBlock = { [weak self] () -> Void in
                
                self?.baiduMapView.removeOverlays(self?.baiduMapView.overlays)
                self?.baiduMapView.removeAnnotations(self?.baiduMapView.annotations)
                self?.googleMapView.clear()
                
                if vvModel.nearPetsDataSource?.count ?? 0 > 0 {
                    for (_,model) in vvModel.nearPetsDataSource!.enumerated()  {
                        self?.addMapMarker(model: model)
                    }
                }
                if let mypet = vvModel.myPetData {
                    self?.addMapMarker(model: mypet)
                    let locate = CLLocationCoordinate2DMake(Double(mypet.device.location.lat ?? "0")!, Double(mypet.device.location.lng ?? "0")!)
                    self?.locateTo(locate)
                }
                self?.baiduView.isHidden = AppDelegate.shareInstance.IsShowGoogleMap
                self?.googleView.isHidden = !AppDelegate.shareInstance.IsShowGoogleMap
            }
        }
    }
    private func locateTo(_ locate: CLLocationCoordinate2D) {
        if AppDelegate.shareInstance.IsShowGoogleMap != true {
            self.baiduMapView.setCenter(locate , animated: true)
        } else {
            self.googleMapView.camera = GMSCameraPosition.camera(withLatitude: locate.latitude, longitude: locate.longitude, zoom: 15)
        }
    }
    deinit {
        baiduMapView.viewWillDisappear()
        /* 不用时，置nil */
        baiduMapView.delegate = nil
    }
    private func setupView() {
        self.addSubview(self.baiduView)
        self.baiduView.addSubview(self.baiduMapView)
        self.addSubview(self.googleView)
        self.googleView.addSubview(self.googleMapView)
        self.googleMapView.delegate = self
        
        self.addSubview(self.updBtn)
        let updImage = UIImage(named: "pet_func_updBtn")!
        self.updBtn.snp_makeConstraints { (make) in
            make.top.equalTo(25*KFitHeightRate+NavigationBarHeigt)
            make.right.equalTo(20*KFitWidthRate)
            make.size.equalTo(CGSize(width: updImage.size.width, height: updImage.size.height))
        }
        self.updBtn.addTarget(self, action: #selector(updNearPetsRequest), for: .touchUpInside)
    }
    @objc private func updNearPetsRequest() {
        MBProgressHUD.showAdded(to: CBPetUtils.getWindow(), animated: true)
        if self.viewModel is CBPetFuncChatViewModel {
            let vvModel = self.viewModel as! CBPetFuncChatViewModel
            vvModel.searchNearbyPetsRequest()
        }
    }
    // MARK: - BMKGeoCodeSearchDelegate
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeSearchResult!, errorCode error: BMKSearchErrorCode) {
        switch error {
        case BMK_SEARCH_NO_ERROR:
            //self.homeInfoView.addressLb.text = result.address
            break
        default:
            //self.homeInfoView.addressLb.text = ""
            CBLog(message: "未找地理位置")
            break
        }
    }
    // MARK: - BMKMapViewDelegate
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if annotation is CBPetNormalAnnotation {
            let annotationView = CBAvatarAnnotionView.annotationViewCopyMapView(mapView: mapView, annotation: annotation)
            let annotationM = annotation as! CBPetNormalAnnotation
            if let value = annotationM.nearPetsModel {
                annotationView.updateNearPetsInfo(model: value)
            }
            let imageDefault = UIImage.init(named: "pet_mapAvatar_default")
            annotationView.centerOffset = CGPoint(x: 0, y: -(imageDefault?.size.height)!/2)
            return annotationView
        }
        return nil
    }
    func mapView(_ mapView: BMKMapView!, click view: BMKAnnotationView!) {
        /* 点击标注事件 */
        CBLog(message: "百度地图点击了标注")
        if view.annotation is CBPetNormalAnnotation {
            let annotationM = view.annotation as! CBPetNormalAnnotation
            if let value = annotationM.nearPetsModel {
                CBPetNearPetPopView.share.updateNearPetsData(model: value)
                CBPetNearPetPopView.share.showAlert(completeBtnBlock: {
                    /* 确定*/
                    if self.viewModel is CBPetFuncChatViewModel {
                        let vvModel = self.viewModel as! CBPetFuncChatViewModel
                        guard vvModel.clickPushFuncChatBlock == nil else {
                            vvModel.clickPushFuncChatBlock!(CBPetFuncChatClickType.visitPetInfo,value)
                            return
                        }
                    }
                }) {
                    /* 关闭*/
                }
            }
        }
    }
    //MARK: - GoogleMaps
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        /*在标记即将被选中时调用，并提供一个可选的自定义信息窗口来 如果此方法返回UIView，则用于该标记。*/
        return nil
    }
    ///点击大头针时调用
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

       let nearPetModel = marker.userData as! CBPetFuncNearPetModel
       CBPetNearPetPopView.share.updateNearPetsData(model: nearPetModel)
       CBPetNearPetPopView.share.showAlert(completeBtnBlock: {
           /* 确定*/
           if self.viewModel is CBPetFuncChatViewModel {
               let vvModel = self.viewModel as! CBPetFuncChatViewModel
               guard vvModel.clickPushFuncChatBlock == nil else {
                   vvModel.clickPushFuncChatBlock!(CBPetFuncChatClickType.visitPetInfo,nearPetModel)
                   return
               }
           }
       }) {
           /* 关闭*/
       }
 
        
        return true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
extension CBPetChatNearbyPetsView {
    private func addMapMarker(model:CBPetFuncNearPetModel) {
        let coord = CLLocationCoordinate2DMake(Double(model.lat_y ?? "0")!, Double(model.lng_x ?? "0")!)
        let locationModel = CBPetHomeInfoTool.getHomeInfo().pet.device.location
        guard AppDelegate.shareInstance.IsShowGoogleMap == true else {
            let normalAnnotation = CBPetNormalAnnotation.init()
            normalAnnotation.coordinate = coord
            normalAnnotation.title = nil
            normalAnnotation.nearPetsModel = model
            self.baiduMapView.addAnnotation(normalAnnotation)
            
//            self.baiduMapView.setCenter(CLLocationCoordinate2DMake(Double(locationModel.lat ?? "0")!, Double(locationModel.lng ?? "0")!) , animated: true)
            return
        }
        
        let marker = GMSMarker.init()
        marker.position = coord
        let markView = CBPetAvatarMarkView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        marker.iconView = markView
        marker.userData = model
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.groundAnchor = CGPoint.init(x: 0.5, y: 0.5)
        marker.snippet = "Sub title"
        marker.map = self.googleMapView
        
        //self.avatarMarkView.updateNearPetsInfo(model: model)
        markView.updateNearPetsInfo(model: model)
        
        self.googleMapView.camera = GMSCameraPosition.camera(withLatitude: Double(locationModel.lat ?? "0")!, longitude: Double(locationModel.lng ?? "0")!, zoom: 15)
    }
}
