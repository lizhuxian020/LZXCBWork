//
//  CBPetFenceAlarmViewController.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/7.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFenceAlarmViewController: CBPetFenceAlarmMapVC {

    private lazy var setFenceViewModel:CBPetHomeViewModel = {
        let vv = CBPetHomeViewModel.init()
        return vv
    }()
    private lazy var fenceAlarmView:CBPetFenceAlarmView = {
        let vv = CBPetFenceAlarmView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 120*KFitHeightRate))
        return vv
    }()
    private lazy var avatarMarkView:CBPetAvatarMarkView = {
        let markView = CBPetAvatarMarkView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        return markView
    }()
    private lazy var fencMarkView:CBPetFenceMarkView = {
        let markView = CBPetFenceMarkView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        return markView
    }()
    private lazy var remindView:UIView = {
        let vv = UIView(backgroundColor: UIColor.white, cornerRadius: 4*KFitHeightRate, shadowColor: KPetC8C8C8Color, shadowOpacity: 0.85, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 8)
        return vv
    }()
    private lazy var remindLb:UILabel = {
        //"您的宠物“念念”离开了安全区域 "
        let lb = UILabel(text: "", textColor: UIColor.init().colorWithHexString(hexString: "#F8563B"), font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, textAlignment: .center)
        return lb
    }()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.remindView.setViewShadow(backgroundColor: UIColor.white, cornerRadius: 4*KFitHeightRate, shadowColor: KPetC8C8C8Color, shadowOpacity: 0.85, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 8)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /* view的 y 从 导航栏以下算起*/
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.setupView()
        
        self.updateDataSource()
    }
    private func setupView() {
        initBarWith(title: "围栏警告".localizedStr, isBack: true)
        self.view.addSubview(self.fenceAlarmView)
        
        self.view.addSubview(self.remindView)
        self.remindView.snp_makeConstraints { (make) in
            make.top.equalTo(self.fenceAlarmView.snp_bottom).offset(25*KFitHeightRate)
            make.centerX.equalTo(self.view)
            make.width.equalTo(SCREEN_WIDTH - 40*KFitWidthRate)
        }
        self.remindView.addSubview(self.remindLb)
        self.remindLb.snp_makeConstraints { (make) in
            make.left.equalTo(self.remindView.snp_left).offset(15*KFitWidthRate)
            make.right.equalTo(self.remindView.snp_right).offset(-15*KFitWidthRate)
            make.top.equalTo(self.remindView.snp_top).offset(10*KFitHeightRate)
            make.bottom.equalTo(self.remindView.snp_bottom).offset(-10*KFitHeightRate)
            
        }
    }
    // MARK: - 数据源刷新
    private func updateDataSource() {
        let data = NSData.init(contentsOf: NSURL.init(string: (self.fenceAlarmModel?.petHead ?? ""))! as URL)
        let originalImage = UIImage.init(data: (data as Data? ?? Data.init()))
        var thuImage = UIImage.imageByScalingAndCroppingForSourceImage(sourceImage: originalImage ?? UIImage.init(), targetSize: CGSize(width: 92, height: 92))
        thuImage = thuImage.imageConvertRoundCorner(radius: thuImage.size.height, borderWidth: 1.5, borderColor: UIColor.white)
        self.avtarImg = thuImage
        
        self.cleanBaiduMap()
        
        self.polygonCoordinate = self.getModelArr(dataString: self.fenceAlarmModel?.fenDate ?? "")
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute:{
            ///延时操作才能加载出来，相当于网络请求
            self.addMapMarker(lat: Double(self.fenceAlarmModel?.alarmLat ?? "0")!, lng: Double(self.fenceAlarmModel?.alarmLng ?? "0")!)
            self.addMapFenceMarker()
            self.addMapCircle()
        })
        
        if self.fenceAlarmModel?.fenceAlarmType == "1" {
            self.remindLb.text = "您的宠物".localizedStr + " \"\(self.fenceAlarmModel?.petName ?? "")\" " + "离开了安全区域".localizedStr
        } else if self.fenceAlarmModel?.fenceAlarmType == "2" {
            self.remindLb.text = "您的宠物".localizedStr + " \"\(self.fenceAlarmModel?.petName ?? "")\" " + "进入了安全区域".localizedStr
        }
        
        if self.polygonCoordinate.count > 0 {
            if let value = self.polygonCoordinate[0].radius {
                self.circleRadius = "\(value)"
            } else {
                self.circleRadius = "0"
            }
        }
        
        guard AppDelegate.shareInstance.IsShowGoogleMap == true else {
                    // 显示百度地图
            let reverseGeoCodeOpetion = BMKReverseGeoCodeSearchOption.init()
            reverseGeoCodeOpetion.location = CLLocationCoordinate2DMake(Double(self.fenceAlarmModel?.alarmLat ?? "0")!, Double(self.fenceAlarmModel?.alarmLng ?? "0")!)
            self.searcher.delegate = self
            let flag = self.searcher.reverseGeoCode(reverseGeoCodeOpetion)
            if flag == true {
                CBLog(message: "反geo检索发送成功")
            } else {
                CBLog(message: "反geo检索发送失败")
            }
            return
        }
        let geocoder = GMSGeocoder.init()
        geocoder.reverseGeocodeCoordinate(CLLocationCoordinate2DMake(Double(self.fenceAlarmModel?.alarmLat ?? "0")!, Double(self.fenceAlarmModel?.alarmLng ?? "0")!)) { (reverseGeocodeResponse, error) in
            if reverseGeocodeResponse?.results()?.count ?? 0 > 0 {
                let address = reverseGeocodeResponse?.results()?[0]
                let addressStr = "\(address?.country ?? "")" + "\(address?.administrativeArea ?? "")" + "\(address?.locality ?? "")" + "\(address?.subLocality ?? "")" + "\(address?.thoroughfare ?? "")"
                self.fenceAlarmView.updateAlarmViewData(address:addressStr,radius:self.circleRadius ?? "")
            } else {
                self.fenceAlarmView.updateAlarmViewData(address:"未知".localizedStr,radius:self.circleRadius ?? "")
            }
        }
    }
    private func cleanBaiduMap() {
        self.baiduMapView.removeOverlays(self.baiduMapView.overlays)
        self.baiduMapView.removeAnnotations(self.baiduMapView.annotations)
        self.googleMapView.clear()
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
extension CBPetFenceAlarmViewController {
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
        self.avatarMarkView.defaultImageView.image = UIImage(named: "pet_mapAvatar_default_alarmV2")!
        self.googleMapView.camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 15)
    }
    private func addMapFenceMarker() {
        if self.polygonCoordinate.count > 0 {
            let coordinateModel = self.polygonCoordinate[0]
            let coord = CLLocationCoordinate2DMake(Double(coordinateModel.coordinate?.latitude ?? 0), Double(coordinateModel.coordinate?.longitude ?? 0))
            guard AppDelegate.shareInstance.IsShowGoogleMap == true else {
                let fenceAnnotation = CBPetFenceAnnotation.init()
                fenceAnnotation.coordinate = coord
                fenceAnnotation.title = nil
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
            guard AppDelegate.shareInstance.IsShowGoogleMap == true else {
                let baiduCircleFenceView = BMKCircle.init(center: coord, radius: CLLocationDistance(coordinateModel.radius ?? 100))
                self.baiduMapView.add(baiduCircleFenceView)
                self.addBaiduMapFitCircleFence(model: coordinateModel, radius: Double(coordinateModel.radius ?? 100))
                return
            }
            
            let circle = GMSCircle(position: coord, radius: Double(coordinateModel.radius ?? 100))
            circle.fillColor = UIColor.init().colorWithHexString(hexString: "#2DDFAF", alpha: 0.1)
            circle.strokeColor = KPetAppColor

            //circle.map = self.googleMapView
            if 0 < coord.latitude && coord.latitude  <= 90 {
                circle.map = self.googleMapView
            }
    
            var bounds = GMSCoordinateBounds.init()
            bounds = bounds.includingCoordinate(coord)
            self.googleMapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30))//30.0
            let zoomLevel = GMSCameraPosition.zoom(at: coord, forMeters: Double(coordinateModel.radius ?? 100), perPoints: 50)//50.0
            self.googleMapView.animate(toZoom: zoomLevel)
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
    // MARK: - BMKGeoCodeSearchDelegate
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeSearchResult!, errorCode error: BMKSearchErrorCode) {
        switch error {
        case BMK_SEARCH_NO_ERROR:
            ///result.address
            self.fenceAlarmView.updateAlarmViewData(address:result.address,radius:self.circleRadius ?? "")
            break
        default:
            ///
            self.fenceAlarmView.updateAlarmViewData(address:"",radius:self.circleRadius ?? "")
            CBLog(message: "未找地理位置")
            break
        }
    }
}
