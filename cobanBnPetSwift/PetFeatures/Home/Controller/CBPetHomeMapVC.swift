//
//  CBPetHomeMapVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/29.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetHomeMapVC: CBPetBaseViewController, BMKMapViewDelegate,BMKGeoCodeSearchDelegate,GMSMapViewDelegate {
    
    public lazy var homeViewModel:CBPetHomeViewModel = {
        let viewMd = CBPetHomeViewModel.init()
        return viewMd
    }()
    public lazy var baiduMapView:BMKMapView = {
        let BMKMap = BMKMapView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        BMKMap.zoomLevel = 16
        BMKMap.centerCoordinate = CLLocationCoordinate2DMake(40.056898, 116.307626)
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
        view.isHidden = true//IsShowGoogleMap
        return view
    }()
    public lazy var googleView:UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        view.isHidden = true//!IsShowGoogleMap
        return view
    }()
    public lazy var searcher:BMKGeoCodeSearch = {
        let search = BMKGeoCodeSearch.init()
        return search
    }()
    public var avtarImg:UIImage?

    public lazy var polygonCoordinate:[CBPetCoordinateObject] = {
        let arr = [CBPetCoordinateObject]()
        return arr
    }()
    
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
            annotationView.image = UIImage.init(named: "pet_mapAvatar_default")!
//            annotationView.updateIconImage(iconImage: self.avtarImg ?? UIImage.init(named: "pet_mapAvatar_default")!)
            
            let model = annotation as! CBPetNormalAnnotation;
            let imgUrl = model.avatarImgUrl ?? ""
            annotationView.updateAvatarByImageUrl(imageUrl: imgUrl)
            annotationView.updateHomeInfoModel(homeModel: self.homeViewModel.homeInfoModel ?? CBPetHomeInfoModel())
            let imageDefault = UIImage.init(named: "pet_mapAvatar_default")!
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
    func mapView(_ mapView: BMKMapView!, didSelect view: BMKAnnotationView!) {
        CBLog(message: "--lzx didSelect : \(view.description)")
    }
    func mapView(_ mapView: BMKMapView!, click view: BMKAnnotationView!) {
        // 点击标注事件
        CBLog(message: "--lzx didClick : \(view.description)")
//        print("百度地图点击了标注")
//        let locationVC = CBLocationViewController.init()
//        self.navigationController?.pushViewController(locationVC, animated: true)
    }
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        if overlay is BMKCircle {
            let circleView = BMKCircleView.init(circle: (overlay as! BMKCircle))
            circleView?.fillColor = UIColor.init().colorWithHexString(hexString: "#2DDFAF", alpha: 0.1)
            circleView?.strokeColor = KPetAppColor
            circleView?.lineWidth = 1.0
            return circleView
        }
        return nil
    }
    // MARK: - Google 地图
//    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//        /*在标记即将被选中时调用，并提供一个可选的自定义信息窗口来 如果此方法返回UIView，则用于该标记。*/
//        return nil
//    }
//    //点击大头针时调用
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        return true
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
