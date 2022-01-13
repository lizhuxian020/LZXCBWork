//
//  CBPetFenceAlarmMapVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/7.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFenceAlarmMapVC: CBPetBaseViewController,BMKMapViewDelegate,BMKGeoCodeSearchDelegate,GMSMapViewDelegate {

    public lazy var homeViewModel:CBPetHomeViewModel = {
        let viewMd = CBPetHomeViewModel.init()
        return viewMd
    }()
    public lazy var baiduMapView:BMKMapView = {
        let BMKMap = BMKMapView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        BMKMap.zoomLevel = 16
        //BMKMap.centerCoordinate = CLLocationCoordinate2DMake(40.056898, 116.307626)
        /* 百度地图全局转（国测局，谷歌等通用）*/
        BMKMapManager.setCoordinateTypeUsedInBaiduMapSDK(BMK_COORD_TYPE.COORDTYPE_COMMON)
        /* 设定地图View能否支持俯仰角*/
        BMKMap.isOverlookEnabled = false
        return BMKMap
    }()
    public lazy var googleMapView:GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 40.056898, longitude: 116.307626, zoom: 18)
        let googleMap = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), camera: camera)
        return googleMap
    }()
    public lazy var baiduView:UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        view.isHidden = AppDelegate.shareInstance.IsShowGoogleMap
        return view
    }()
    public lazy var googleView:UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        view.isHidden = !AppDelegate.shareInstance.IsShowGoogleMap
        return view
    }()
    public lazy var searcher:BMKGeoCodeSearch = {
        let search = BMKGeoCodeSearch.init()
        return search
    }()
    public var avtarImg:UIImage?
    
    var circleRadius:String?
    
    public lazy var polygonCoordinate:[CBPetCoordinateObject] = {
        let arr = [CBPetCoordinateObject]()
        return arr
    }()
    
    /* 围栏报警模型*/
    public var fenceAlarmModel:CBPetMsgCterFenceDynamicModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        baiduMapView.viewWillAppear()
        /* 此处记得不用的时候需要置nil，否则影响内存的释放 */
        baiduMapView.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        baiduMapView.viewWillDisappear()
        /* 不用时，置nil */
        baiduMapView.delegate = nil
    }
    deinit {
        // vc 销毁
        //print("首页CBPetHomeViewController---被释放了")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        /* 判断系统语言展示百度地图或者谷歌地图*/
        let userLanguage:[String] = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        AppDelegate.shareInstance.IsShowGoogleMap = false
        if userLanguage.first?.hasPrefix("en") == true {
            AppDelegate.shareInstance.IsShowGoogleMap = true
        }
        
        self.view.addSubview(self.baiduView)
        self.baiduView.addSubview(self.baiduMapView)
        self.view.addSubview(self.googleView)
        self.googleView.addSubview(self.googleMapView)
        self.googleMapView.delegate = self
    }
//    public func addMapMarker() {
//        guard AppDelegate.shareInstance.IsShowGoogleMap == true else {
//            self.baiduMapView.removeAnnotations(self.baiduMapView.annotations)
//            self.baiduMapView.setCenter(CLLocationCoordinate2DMake(Double(self.fenceAlarmModel?.alarmLat ?? "0")!, Double(self.fenceAlarmModel?.alarmLng ?? "0")!), animated: true)
//            let normalAnnotation = CBPetNormalAnnotation.init()
//            normalAnnotation.coordinate = CLLocationCoordinate2DMake(Double(self.fenceAlarmModel?.alarmLat ?? "0")!, Double(self.fenceAlarmModel?.alarmLng ?? "0")!)
//            normalAnnotation.title = nil
//            self.baiduMapView.addAnnotation(normalAnnotation)
//            return
//        }
//        self.googleMapView.clear()
////        self.googleMapView.camera = GMSCameraPosition.camera(withLatitude: Double(self.homeInfoModel.tbWatchMain.lat ?? "0")!, longitude: Double(self.homeInfoModel.tbWatchMain.lng ?? "0")!, zoom: 18)
//    }
    // MARK: - BMKGeoCodeSearchDelegate
//    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeSearchResult!, errorCode error: BMKSearchErrorCode) {
//        switch error {
//        case BMK_SEARCH_NO_ERROR:
//            //self.homeInfoView.addressLb.text = result.address
//            break
//        default:
//            //self.homeInfoView.addressLb.text = ""
//            CBLog(message: "未找地理位置")
//            break
//        }
//    }
    // MARK: - BMKMapViewDelegate
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if annotation is CBPetNormalAnnotation {
             let annotationView = CBAvatarAnnotionView.annotationViewCopyMapView(mapView: mapView, annotation: annotation)
             annotationView.updateIconImage(iconImage: self.avtarImg ?? UIImage.init(named: "pet_mapAvatar_default")!)
             //annotationView.updateHomeInfoModel(homeModel: self.homeViewModel.homeInfoModel ?? CBPetHomeInfoModel())
             annotationView.defaultImageView.image = UIImage(named: "pet_mapAvatar_default_alarmV2")!
             let imageDefault = UIImage.init(named: "pet_mapAvatar_default")!
             annotationView.centerOffset = CGPoint(x: 0, y: -(imageDefault.size.height)/2)
             annotationView.image = UIImage()
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
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        if overlay is BMKCircle {
            let circleView = BMKCircleView.init(circle: (overlay as! BMKCircle))
            circleView?.fillColor = UIColor.init().colorWithHexString(hexString: "#F8563B", alpha: 0.1)
            circleView?.strokeColor = UIColor.init().colorWithHexString(hexString: "#F8563B")
            circleView?.lineWidth = 1.0
            return circleView
        }
        return nil
    }
    func mapView(_ mapView: BMKMapView!, click view: BMKAnnotationView!) {
        // 点击标注事件
//        print("百度地图点击了标注")
//        let locationVC = CBLocationViewController.init()
//        self.navigationController?.pushViewController(locationVC, animated: true)
    }
    // MARK: - GMSMapViewDelegate
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
