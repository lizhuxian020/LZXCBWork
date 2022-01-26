//
//  CBPetSetFenceMapVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/6.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetSetFenceMapVC: CBPetBaseViewController,BMKMapViewDelegate,BMKGeoCodeSearchDelegate,GMSMapViewDelegate {

    public lazy var homeViewModel:CBPetHomeViewModel = {
        let viewMd = CBPetHomeViewModel.init()
        return viewMd
    }()
    public lazy var baiduMapView:BMKMapView = {
        let BMKMap = BMKMapView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        BMKMap.zoomLevel = 16
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
    public var avtarImg:UIImage?// UIImage.init(named: "默认宝贝头像")
    
    public lazy var polygonCoordinate:[CBPetCoordinateObject] = {
        let arr = [CBPetCoordinateObject]()
        return arr
    }()
    public lazy var selectedCoordinate:CBPetCoordinateObject = {
        let arr = CBPetCoordinateObject()
        return arr
    }()

    var circleRadius:Float?
    
    var baiduCircleFenceView:BMKCircle?
    var googleCircle:GMSCircle?
    
    //var circleCoordinate:CLLocationCoordinate2D?
    
    var selectCoordBlock:(() -> Void)?
    
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
    
    func didEndDragAnnotation(coordinate:CLLocationCoordinate2D, radius:Double) {
        
    }
    
    func mapView(_ mapView: BMKMapView!, annotationView view: BMKAnnotationView!, didChangeDragState newState: UInt, fromOldState oldState: UInt) {
        let coordinateModel = self.polygonCoordinate[0]
        let coord = CLLocationCoordinate2DMake(Double(coordinateModel.coordinate?.latitude ?? 0), Double(coordinateModel.coordinate?.longitude ?? 0))
        switch newState {
        case 1:
            CBLog(message: "--lzx: 开始拖拽")
            break
        case 2:
            let loca = view.center
            let coo = self.baiduMapView.convert(loca, toCoordinateFrom: self.baiduMapView)
            let distance : CLLocationDistance = BMKMetersBetweenMapPoints(BMKMapPointForCoordinate(coo), BMKMapPointForCoordinate(coord))
            if self.homeViewModel.petHomeSetFenceBlock != nil {
                self.homeViewModel.petHomeSetFenceBlock!("DragValue",distance)
            }
            CBLog(message: "--lzx: 拖拽中: \(loca) + distance: \(distance)")
            break
        case 4:
            let loca = view.center
            let coo = self.baiduMapView.convert(loca, toCoordinateFrom: self.baiduMapView)
            let distance : CLLocationDistance = BMKMetersBetweenMapPoints(BMKMapPointForCoordinate(coo), BMKMapPointForCoordinate(coord))
            self.didEndDragAnnotation(coordinate: coordinateModel.coordinate!, radius: distance)
            CBLog(message: "--lzx: 拖拽结束")
            break
        default:
            break
        }
    }
    
    // MARK: - BMKMapViewDelegate
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if annotation is CBPetNormalAnnotation {
            let cbAnnotation = annotation as! CBPetNormalAnnotation
            if (cbAnnotation.isFenceCircleMark) {
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "fenceAV")
                if annotationView == nil {
                    annotationView = BMKAnnotationView.init(annotation: cbAnnotation, reuseIdentifier: "fenceAV")
                }
                annotationView!.image = UIImage.init(named: "pet_fence_annotation")!
                
                annotationView?.isDraggable = true
                return annotationView
            }
            let annotationView = CBAvatarAnnotionView.annotationViewCopyMapView(mapView: mapView, annotation: annotation)
            annotationView.updateIconImage(iconImage: self.avtarImg ?? UIImage.init(named: "pet_mapAvatar_default")!)
            annotationView.updateHomeInfoModel(homeModel: self.homeViewModel.homeInfoModel ?? CBPetHomeInfoModel())
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
            circleView?.fillColor = UIColor.init().colorWithHexString(hexString: "#2DDFAF", alpha: 0.1)
            circleView?.strokeColor = KPetAppColor
            circleView?.lineWidth = 1.0
            return circleView
        }
        return nil
    }
    func mapView(_ mapView: BMKMapView!, click view: BMKAnnotationView!) {
        /// 点击百度地图标注
    }
    func mapView(_ mapView: BMKMapView!, onClickedMapBlank coordinate: CLLocationCoordinate2D) {
        CBLog(message: "点击的坐标:=====\(coordinate.latitude),\(coordinate.longitude)")
        //self.circleCoordinate = coordinate
        self.polygonCoordinate.removeAll()
        
        var coordModel = CBPetCoordinateObject.init()
        coordModel.coordinate = coordinate
        coordModel.radius = self.circleRadius
        self.polygonCoordinate.append(coordModel)
        
        guard self.selectCoordBlock == nil else {
            self.selectCoordBlock!()
            return
        }
    }
    // MARK: - GMSMapViewDelegate
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.polygonCoordinate.removeAll()
        
        var coordModel = CBPetCoordinateObject.init()
        coordModel.coordinate = coordinate
        coordModel.radius = self.circleRadius
        self.polygonCoordinate.append(coordModel)
        
        guard self.selectCoordBlock == nil else {
            self.selectCoordBlock!()
            return
        }
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
