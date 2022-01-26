//
//  CBPetSetFenceViewController.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/6.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import CoreLocation

class CBPetSetFenceViewController: CBPetSetFenceMapVC {

    private lazy var setFenceView:CBPetSetFenceView = {
        let vv = CBPetSetFenceView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 120*KFitHeightRate))
        return vv
    }()
    
    private var fenceAnnotation:CBPetFenceAnnotation?
    
    private lazy var avatarMarkView:CBPetAvatarMarkView = {
        let markView = CBPetAvatarMarkView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        return markView
    }()
    private lazy var fencMarkView:CBPetFenceMarkView = {
        let markView = CBPetFenceMarkView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        return markView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* view的 y 从 导航栏以下算起*/
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.setupView()
        self.updateDataSource()
    }
    private func setupView() {
        initBarWith(title: "虚拟电子围栏".localizedStr, isBack: true)
        initBarRight(title: "确定".localizedStr, action: #selector(comfirmMethod))
        self.rightBtn.setTitleColor(KPetAppColor, for: .normal)
        self.rightBtn.setTitleColor(KPetAppColor, for: .highlighted)
        self.rightBtn.titleLabel?.font = UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)
    
        self.view.addSubview(self.setFenceView)
        self.setFenceView.setupViewModel(viewModel: self.homeViewModel)
    }
    // MARK: - 数据源刷新
    private func updateDataSource() {
        let data = NSData.init(contentsOf: NSURL.init(string: (self.homeViewModel.homeInfoModel?.pet.photo ?? ""))! as URL)
        let originalImage = UIImage.init(data: (data as Data? ?? Data.init()))
        var thuImage = UIImage.imageByScalingAndCroppingForSourceImage(sourceImage: originalImage ?? UIImage.init(), targetSize: CGSize(width: 92, height: 92))
        thuImage = thuImage.imageConvertRoundCorner(radius: thuImage.size.height, borderWidth: 1.5, borderColor: UIColor.white)
        self.avtarImg = thuImage
        
        self.cleanBaiduMap()
        
        self.polygonCoordinate = self.getModelArr(dataString: self.homeViewModel.homeInfoModel?.fence.data ?? "")
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute:{
            ///延时操作才能加载出来，相当于网络请求
            self.addMapMarker(lat: Double(self.homeViewModel.homeInfoModel?.pet.device.location.lat ?? "0")!, lng: Double(self.homeViewModel.homeInfoModel?.pet.device.location.lng ?? "0")!)
            self.addMapFenceMarker()
            self.addMapCircle()
        })
        
        self.homeViewModel.petHomeSetFenceBlock = { [weak self] (type:String,objc:Any) -> Void in
            /* 滑杆滑动刷新围栏半径*/
            if type == "slideValue" {
                self?.circleRadius = Float(objc as! String)!
                guard AppDelegate.shareInstance.IsShowGoogleMap == true else {
                    self?.baiduCircleFenceView?.radius = CLLocationDistance(objc as! String)!
                    return
                }
                self?.googleCircle?.radius = CLLocationDistance(objc as! String)!
            } else if type == "setFenceReload" {
                MBProgressHUD.showMessage(Msg: "设置成功".localizedStr, Deleay: 1.5)
                self?.navigationController?.popViewController(animated: true)
            } else if type == "DragValue" {
                if objc is CLLocationDistance {
                    let distance : Int = Int(objc as! CLLocationDistance)
                    self?.circleRadius = Float(objc as! CLLocationDistance)
                    self?.setFenceView.inputRadiusView.inputTF.text = "\(distance)"
                    self?.baiduCircleFenceView?.radius = objc as! CLLocationDistance
                }
            }
        }
        self.selectCoordBlock = { [weak self] () -> Void in
            /* 点中地图上某个点*/
            self?.polygonCoordinate[0].radius = self?.circleRadius
            
            self?.cleanBaiduMap()
            
            self?.addMapMarker(lat: Double(self?.homeViewModel.homeInfoModel?.pet.device.location.lat ?? "0")!, lng: Double(self?.homeViewModel.homeInfoModel?.pet.device.location.lng ?? "0")!)
            self?.addMapFenceMarker()
            self?.addMapCircle()
        }
    }
    private func cleanBaiduMap() {
        self.baiduMapView.removeOverlays(self.baiduMapView.overlays)
        self.baiduMapView.removeAnnotations(self.baiduMapView.annotations)
        self.googleMapView.clear()
    }
    //MARK: - 确认更改
    @objc private func comfirmMethod() {
        if self.polygonCoordinate.count <= 0 {
            MBProgressHUD.showMessage(Msg: "请设置围栏".localizedStr, Deleay: 1.5)
            return
        }
        let coordDataArray = ["\(self.polygonCoordinate[0].coordinate?.latitude ?? 0)","\(self.polygonCoordinate[0].coordinate?.longitude ?? 0)",String.init(format: "%.0f", self.circleRadius ?? 0)]
        let coordDataStr = coordDataArray.joined(separator: ",")
        self.homeViewModel.updateCircleFenceReuqest(coordDataStrs: coordDataStr, id: self.homeViewModel.homeInfoModel?.fence.id ?? "")
    }
    
    // MARK: - BMKGeoCodeSearchDelegate
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeSearchResult!, errorCode error: BMKSearchErrorCode) {
        switch error {
        case BMK_SEARCH_NO_ERROR:
            ///result.address
            self.setFenceView.addressLb.text = result.address
            break
        default:
            ///
            CBLog(message: "未找地理位置")
            self.setFenceView.addressLb.text = "未知".localizedStr
            break
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
    
    override func didEndDragAnnotation(coordinate: CLLocationCoordinate2D, radius: Double) {
        let circlePoint = BMKMapPointForCoordinate(coordinate)
        let pointRadius = radius/0.61
        let fitRect = BMKMapRectMake(circlePoint.x - pointRadius, circlePoint.y - pointRadius, pointRadius*2, pointRadius*2)
        self.baiduMapView.setVisibleMapRect(fitRect, animated: true)
        self.baiduMapView.setCenter(coordinate, animated: true)
    }
    
}
extension CBPetSetFenceViewController {
    private func getModelArr(dataString:String) -> [CBPetCoordinateObject] {
        let dataArr = dataString.components(separatedBy: ",")
        var modelArr = Array<CBPetCoordinateObject>()
        for index in 0..<dataArr.count {
            var model = CBPetCoordinateObject.init()
            if index + 2 < dataArr.count {
                var coordinate = CLLocationCoordinate2DMake(Double(dataArr[index])!,Double(dataArr[index+1])!)
                if 0 > Double(dataArr[index+1])! || Double(dataArr[index+1])!  > 90 {
                    /* 若纬经 变成了经纬，则调换位置*/
                    coordinate.latitude = Double(dataArr[index])!
                    coordinate.longitude = Double(dataArr[index+1])!
                }
                model.coordinate = coordinate
                model.radius = Float(dataArr[index+2])
                self.circleRadius = Float(dataArr[index+2])
                modelArr.append(model)
            }
        }
        return modelArr
    }
    private func addMapMarker(lat:Double,lng:Double) {
        guard AppDelegate.shareInstance.IsShowGoogleMap == true else {
            let normalAnnotation = CBPetNormalAnnotation.init()
            normalAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lng)
            normalAnnotation.title = nil
            self.baiduMapView.addAnnotation(normalAnnotation)
            self.baiduMapView.setCenter(CLLocationCoordinate2DMake(lat, lng) , animated: true)
            return
        }
        let marker = GMSMarker.init()
        marker.position = CLLocationCoordinate2DMake(lat, lng)
        marker.iconView = self.avatarMarkView
        marker.map = self.googleMapView
        self.avatarMarkView.updateIconImage(iconImage: self.avtarImg ?? UIImage.init(named: "pet_mapAvatar_default")!)
        self.googleMapView.camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 15)
    }
    private func addFenceMark(_ coordinate : CLLocationCoordinate2D) {
        guard AppDelegate.shareInstance.IsShowGoogleMap == true else {
            let normalAnnotation = CBPetNormalAnnotation.init()
            normalAnnotation.isFenceCircleMark = true
            normalAnnotation.coordinate = coordinate
            normalAnnotation.title = nil
            self.baiduMapView.addAnnotation(normalAnnotation)
            return
        }
    }
    private func addMapFenceMarker() {
        if self.polygonCoordinate.count > 0 {
            let coordinateModel = self.polygonCoordinate[0]
            let coord = CLLocationCoordinate2DMake(Double(coordinateModel.coordinate?.latitude ?? 0), Double(coordinateModel.coordinate?.longitude ?? 0))
            guard AppDelegate.shareInstance.IsShowGoogleMap == true else {
                self.fenceAnnotation = CBPetFenceAnnotation.init()
                self.fenceAnnotation?.coordinate = coord
                self.fenceAnnotation?.title = nil
                self.baiduMapView.addAnnotation(fenceAnnotation)
                return
            }
            let marker = GMSMarker.init()
            marker.position = coord
            marker.iconView = self.fencMarkView
            marker.map = self.googleMapView
        }
    }
    private func addMapCircle() {
        if self.polygonCoordinate.count > 0 {
            let coordinateModel = self.polygonCoordinate[0]
            let coord = CLLocationCoordinate2DMake(Double(coordinateModel.coordinate?.latitude ?? 0), Double(coordinateModel.coordinate?.longitude ?? 0))
            let radius = CLLocationDistance(coordinateModel.radius ?? 100)
            guard AppDelegate.shareInstance.IsShowGoogleMap == true else {
                self.baiduCircleFenceView = BMKCircle.init(center: coord, radius: radius)
                self.baiduMapView.add(self.baiduCircleFenceView)
                self.addBaiduMapFitCircleFence(model: coordinateModel, radius: radius)
                
                let mapRect = self.baiduCircleFenceView!.boundingMapRect
                
                let fencePoint : CLLocationCoordinate2D = BMKCoordinateForMapPoint(BMKMapPointMake(BMKMapRectGetMaxX(mapRect), mapRect.origin.y+mapRect.size.height/2.0))
                self.addFenceMark(fencePoint)
                let reverseGeoCodeOpetion = BMKReverseGeoCodeSearchOption.init()
                reverseGeoCodeOpetion.location = coord
                self.searcher.delegate = self
                let flag = self.searcher.reverseGeoCode(reverseGeoCodeOpetion)
                if flag == true {
                    CBLog(message: "反geo检索发送成功")
                } else {
                    CBLog(message: "反geo检索发送失败")
                }
                return
            }
            
            self.googleCircle = GMSCircle(position: coord, radius: radius)
            self.googleCircle?.fillColor = UIColor.init().colorWithHexString(hexString: "#2DDFAF", alpha: 0.1)
            self.googleCircle?.strokeColor = KPetAppColor

            //circle.map = self.googleMapView
            if 0 < coord.latitude && coord.latitude  <= 90 {
                self.googleCircle?.map = self.googleMapView
            }
    
            var bounds = GMSCoordinateBounds.init()
            bounds = bounds.includingCoordinate(coord)
            self.googleMapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30))//30.0
            let zoomLevel = GMSCameraPosition.zoom(at: coord, forMeters: radius, perPoints: 50)//50.0
            self.googleMapView.animate(toZoom: zoomLevel)
            
//            /* 显示地理位置*/
//            guard AppDelegate.shareInstance.IsShowGoogleMap == true else {
//                        // 显示百度地图
//                let reverseGeoCodeOpetion = BMKReverseGeoCodeSearchOption.init()
//                reverseGeoCodeOpetion.location = coord
//                self.searcher.delegate = self
//                let flag = self.searcher.reverseGeoCode(reverseGeoCodeOpetion)
//                if flag == true {
//                    CBLog(message: "反geo检索发送成功")
//                } else {
//                    CBLog(message: "反geo检索发送失败")
//                }
//                return
//            }
            let geocoder = GMSGeocoder.init()
            geocoder.reverseGeocodeCoordinate(coord) { (reverseGeocodeResponse, error) in
                if reverseGeocodeResponse?.results()?.count ?? 0 > 0 {
                    let address = reverseGeocodeResponse?.results()?[0]
                    let addressStr = "\(address?.country ?? "")" + "\(address?.administrativeArea ?? "")" + "\(address?.locality ?? "")" + "\(address?.subLocality ?? "")" + "\(address?.thoroughfare ?? "")"
                    self.setFenceView.addressLb.text = addressStr
                } else {
                    self.setFenceView.addressLb.text = "未知".localizedStr
                }
            }
        }
    }
    private func addBaiduMapFitCircleFence(model:CBPetCoordinateObject,radius:Double) {
        // 一个点的长度是0.870096
        let circlePoint = BMKMapPointForCoordinate(model.coordinate ?? CLLocationCoordinate2DMake(Double(0), Double(0)))
        let pointRadius = radius/0.6
        let fitRect = BMKMapRectMake(circlePoint.x - pointRadius, circlePoint.y - pointRadius, pointRadius*2, pointRadius*2)
        self.baiduMapView.setVisibleMapRect(fitRect, animated: true)
        self.baiduMapView.setCenter(model.coordinate ?? CLLocationCoordinate2DMake(Double(0), Double(0)), animated: true)
    }
}
