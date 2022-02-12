//
//  CBPetHomeMapVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/29.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetHomeMapVC: CBPetBaseViewController, BMKMapViewDelegate,BMKGeoCodeSearchDelegate,GMSMapViewDelegate {
    
    public var showPaoView : Bool = false
    public var isClickAnnotation : Bool = false
    public var isClear : Bool = false //因为clear会调deselect，打乱showPao的判断
    public var currentShowPaoView : UIView?
    
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
            //PS: 这里是为了给annotationView撑开，否则点击不了
            annotationView.image = UIImage.init(named: "pet_mapAvatar_default")!
            
            let model = annotation as! CBPetNormalAnnotation;
            let imgUrl = model.avatarImgUrl() ?? ""
            annotationView.updateAvatarByImageUrl(imageUrl: imgUrl)
            annotationView.updatePetModel(petModel: model.petModel!)
            let imageDefault = UIImage.init(named: "pet_mapAvatar_default")!
            annotationView.centerOffset = CGPoint(x: 0, y: -(imageDefault.size.height)/2)
            annotationView.hideNameLbl()
            
            
            if (model.petModel?.imei == self.homeViewModel.homeInfoModel?.pet.device.imei) && self.showPaoView != true {
                annotationView.showNameLbl()
            }
            
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
        guard let v = view as? CBAvatarAnnotionView else {
            return
        }
    }
    func mapView(_ mapView: BMKMapView!, didDeselect view: BMKAnnotationView!) {
        CBLog(message: "--lzx didDeSelect : \(view.description)")
        guard let v = view as? CBAvatarAnnotionView else {
            return
        }
        if self.currentShowPaoView != nil {
            v.showNameLbl()
            self.currentShowPaoView?.removeFromSuperview()
            self.removePaoView(annotationView: v)
            self.currentShowPaoView = nil
        }
//        //如果是切换设备，则不管showPao
//        if self.isClickAnnotation == false {
//            self.showPaoView = false
//        }
    }
    func mapView(_ mapView: BMKMapView!, click view: BMKAnnotationView!) {
        // 点击标注事件
        CBLog(message: "--lzx didClick : \(view.description)")
        
        guard let anno = view.annotation as? CBPetNormalAnnotation, let v = view as? CBAvatarAnnotionView else {
            return
        }
        
        if anno.petModel?.imei == self.homeViewModel.homeInfoModel?.devUser.imei {
            if self.currentShowPaoView == nil {
                v.hideNameLbl()
                self.createPaoView(model: anno, annotationView: v)
                mapView.selectAnnotation(view.annotation, animated: false)
                self.currentShowPaoView = v.paopaoView
            } else {
                mapView.deselectAnnotation(view.annotation, animated: false)
            }
        } else {
            self.isClickAnnotation = true
            self.showPaoView = self.currentShowPaoView != nil
            self.didClickAnnotaionView(view: view)
        }
        
        
       
//        print("百度地图点击了标注")
//        let locationVC = CBLocationViewController.init()
//        self.navigationController?.pushViewController(locationVC, animated: true)
    }
    public func createPaoView(model: CBPetNormalAnnotation, annotationView: BMKAnnotationView) {
        let paoView = CBPetAvatarPaoView.init()
        paoView.petModel = model.petModel
        paoView.fenceModel = self.homeViewModel.paramtersObject ?? CBPetHomeParamtersModel.init()
        paoView.layoutIfNeeded()
        paoView.setupViewModel(viewModel: self.homeViewModel)
        let p = BMKActionPaopaoView.init(customView: paoView)
        annotationView.paopaoView = p
        if self.isClickAnnotation == false && self.isClear == false {
            self.showPaoView = true
        }
    }
    private func removePaoView(annotationView: BMKAnnotationView) {
        annotationView.paopaoView = nil
        if self.isClickAnnotation == false && self.isClear == false {
            self.showPaoView = false
        }
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
    func mapView(_ mapView: BMKMapView!, onClickedMapBlank coordinate: CLLocationCoordinate2D) {
        CBLog(message: "--lzx: onClickedMapBlank")
        self.didClickBlankAreaOfMap()
    }
    
    func didClickAnnotaionView(view: BMKAnnotationView!) {
        
    }
    // MARK: - Google 地图
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        /*在标记即将被选中时调用，并提供一个可选的自定义信息窗口来 如果此方法返回UIView，则用于该标记。*/
        if let cbMarker = marker as? CBPetGMSMarker, gmsPaoView.superview != nil {
            tappedMarker = cbMarker
            gmsPaoView.petModel = cbMarker.petModel
        }
        return UIView.init()
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        CBLog(message: "---lzx: GMS didTapInfoWindows")
        self.didClickGMSInfoWindow()
    }
    
    var gmsPaoView : CBPetAvatarPaoView = CBPetAvatarPaoView.init()
    var tappedMarker : CBPetGMSMarker?
    var markers : [CBPetGMSMarker] = []
    //点击大头针时调用
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let cbMarker = marker as? CBPetGMSMarker else {
            return false
        }
        
        if cbMarker.petModel?.imei == self.homeViewModel.homeInfoModel?.pet.device.imei {
            let markerView = cbMarker.iconView as! CBPetAvatarMarkView
            if gmsPaoView.superview != nil {
                gmsPaoView.removeFromSuperview()
                markerView.showNameLbl()
            } else {
                markerView.hideNameLbl()
                self.generatePaoView(mapView: mapView, cbMarker: cbMarker)
            }
        } else {
//            gmsPaoView.removeFromSuperview()
            self.didClickGMSMarker(marker: marker) {[weak self] in
                
                //PS:切换了设备之后，这里marker已不是原来的marker，但这个block最后才执行，在这之前，可以在addMark_GMS里，把生成猴的marker赋值给mapView.selectedMarker，进而到这里拿到正确marker
                if self?.gmsPaoView.superview != nil {
                    self?.generatePaoView(mapView: mapView, cbMarker: cbMarker)
                }
            }
        }
        
        return false
    }
    
    func didClickGMSMarker(marker: GMSMarker, _ finishBlk : @escaping ()->Void) {
        CBLog(message: "--lzx: didClickMArk")
    }
    
    func didClickGMSInfoWindow() {
        
    }
    
    private func generatePaoView(mapView: GMSMapView, cbMarker: CBPetGMSMarker) {
        let location = cbMarker.petModel!.getCoordinate2D()
        tappedMarker = cbMarker
        
        gmsPaoView.removeFromSuperview()
        
        
//        gmsPaoView = CBPetAvatarPaoView.init()
        gmsPaoView.petModel = cbMarker.petModel
        gmsPaoView.fenceModel = self.homeViewModel.paramtersObject ?? CBPetHomeParamtersModel.init()
//        gmsPaoView.layoutIfNeeded()
        gmsPaoView.setupViewModel(viewModel: self.homeViewModel)
        
        let point = mapView.projection.point(for: location)
        self.googleView.addSubview(gmsPaoView)
        let markImg = UIImage.init(named: "pet_fence_annotation")!
        gmsPaoView.snp_makeConstraints({ make in
            make.centerX.equalTo(point.x)
            make.bottom.equalTo(self.view.snp_top).offset(point.y-markImg.size.height*2)
            make.width.equalTo(258)
        })
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.gmsMapDidChangePosition()
    }
    
    func gmsMapDidChangePosition() {
        if tappedMarker != nil && gmsPaoView.superview != nil {
            let location = tappedMarker?.petModel?.getCoordinate2D()
            let point = self.googleMapView.projection.point(for: location!)
            let markImg = UIImage.init(named: "pet_fence_annotation")!
            gmsPaoView.petModel = tappedMarker!.petModel
            gmsPaoView.fenceModel = self.homeViewModel.paramtersObject ?? CBPetHomeParamtersModel.init()
            gmsPaoView.setupViewModel(viewModel: self.homeViewModel)
            gmsPaoView.snp_remakeConstraints({ make in
                make.centerX.equalTo(point.x)
                make.bottom.equalTo(self.view.snp_top).offset(point.y-markImg.size.height*2)
                make.width.equalTo(258)
            })
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        gmsPaoView.removeFromSuperview()
        if let marker = self.getGMSMarker(imei: self.homeViewModel.homeInfoModel?.pet.device.imei) {
            if let iconView = marker.iconView as? CBPetAvatarMarkView {
                iconView.showNameLbl()
            }
        }
        self.didClickBlankAreaOfMap()
    }
    
    func didClickBlankAreaOfMap() {
        
    }
    
    func getGMSMarker(imei: String?) -> CBPetGMSMarker? {
        for marker in self.markers {
            if marker.petModel?.imei == imei {
                return marker
            }
        }
        return nil
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
