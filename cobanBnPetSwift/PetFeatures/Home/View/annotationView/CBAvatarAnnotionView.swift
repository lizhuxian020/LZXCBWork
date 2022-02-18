//
//  CBAvatarAnnotionView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/4/23.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBAvatarAnnotionView: BMKAnnotationView {

    public var defaultImageView:UIImageView = {
        let img = UIImage.init(named: "pet_mapAvatar_default")!
        let imgV = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: img.size.width, height: img.size.height))
        imgV.isUserInteractionEnabled = false
        imgV.image = img
        return imgV
    }()
    private var avtarImgView:UIImageView = {
        let img = UIImage.init(named: "pet_mapAvatar_default")!
        let imgV = UIImageView.init()
        imgV.isUserInteractionEnabled = true;
        imgV.layer.masksToBounds = true;
        imgV.layer.cornerRadius = (img.size.width - 12)/2;
        imgV.contentMode = .scaleAspectFill;
        return imgV
    }()
    private var statusBtn:UIButton = {
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 80, height: 36))
        btn.setTitle("状态正常", for: .normal)
        btn.setImage(UIImage.init(named: "arrow-右边-白"), for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 18.0
        btn.backgroundColor = RGB(r: 26, g: 151, b: 251)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.isHidden = true
        //btn.horizontalCenterTitleAndImage(space: 10)
        btn.layoutBtn(status: .CBHorizontalCenterTitleAndImage, space: 10)
        btn.adjustsImageWhenHighlighted = false
        btn.addTarget(self, action: #selector(annotationClick), for: .touchUpOutside)
        return btn
    }()
    var avtarClickBlock:(() -> Void)?
    
    private var nameLbl : UILabel = {
        let lbl = UILabel.init(text: "", textColor: KPet666666Color, font: UIFont(name: CBPingFang_SC_Bold, size: 14*KFitHeightRate)!, textAlignment: NSTextAlignment.center)
        lbl.backgroundColor = .white
        lbl.isHidden = true
        return lbl
    }()

    class func annotationViewCopyMapView(mapView:BMKMapView,annotation:BMKAnnotation) -> CBAvatarAnnotionView {
        let annotationViewID = "NormalAnnationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationViewID)
        if annotationView == nil {
            annotationView = CBAvatarAnnotionView.init(annotation: annotation, reuseIdentifier: annotationViewID)
        }
        return annotationView as! CBAvatarAnnotionView
    }
    override init!(annotation: BMKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
//        self.addSubview(self.statusBtn)
        let img = UIImage.init(named: "pet_mapAvatar_default")!
        self.addSubview(self.defaultImageView)
        self.defaultImageView.addSubview(self.avtarImgView)
        self.avtarImgView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.defaultImageView.snp_centerX)
            make.top.equalTo(self.defaultImageView.snp_top).offset(6)
            make.size.equalTo(CGSize.init(width: img.size.width-12, height: img.size.width-12))
        }
        self.addSubview(self.nameLbl)
        self.nameLbl.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.defaultImageView.snp_centerX)
            make.bottom.equalTo(self.avtarImgView.snp_top).offset(-5)
            make.width.equalTo(img.size.width+12)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func updateIconImage(iconImage:UIImage) {
        self.avtarImgView.image = iconImage
    }
    func updateAvatarByImageUrl(imageUrl:String) {
//        self.defaultImageView.image = UIImage(named: "pet_mapAvatar_default")!
        self.avtarImgView.sd_setImage(with: URL.init(string: imageUrl), placeholderImage: UIImage.init(), options: [])
    }
    func updateHomeInfoModel(homeModel:CBPetHomeInfoModel) {
        switch homeModel.pet.device.online {
        case "0":
            self.defaultImageView.image = UIImage(named: "pet_mapAvatar_default_offlineV2")!
            break
        case "1":
            self.defaultImageView.image = UIImage(named: "pet_mapAvatar_defaultV2")!
            break
        case "2":
            self.defaultImageView.image = UIImage(named: "pet_mapAvatar_default_alarmV2")!
            break
        default:
            break
        }
    }
    func updatePetModel(petModel:CBPetPsnalCterPetModel) {
        self.nameLbl.text = petModel.pet.name
        switch petModel.pet.device.online {
        case "0":
            self.defaultImageView.image = UIImage(named: "pet_mapAvatar_default_offlineV2")!
            break
        case "1":
            self.defaultImageView.image = UIImage(named: "pet_mapAvatar_defaultV2")!
            break
        case "2":
            self.defaultImageView.image = UIImage(named: "pet_mapAvatar_default_alarmV2")!
            break
        default:
            break
        }
    }
    func updateNearPetsInfo(model:CBPetFuncNearPetModel) {
        self.avtarImgView.sd_setImage(with: URL.init(string: model.photo ?? ""), placeholderImage: UIImage(named: ""), options: [])
        self.defaultImageView.image = UIImage(named: "pet_mapAvatar_default")!
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.imei {
            if value.valueStr == model.device.imei {
                self.defaultImageView.image = UIImage(named: "pet_mapAvatar_defaultV2")!
            } else {
                self.defaultImageView.image = UIImage(named: "pet_mapAvatar_nearby")!
            }
        }
    }
    func updateStatusStr(statusStr:String) {
        if statusStr.count > 0 {
            self.statusBtn.isHidden = false
            if statusStr.contains("1") || statusStr.contains("2") ||
                statusStr.contains("4") || statusStr.contains("5") ||
                statusStr.contains("6") || statusStr.contains("7") {
                self.statusBtn.backgroundColor = .red
                self.statusBtn.setTitle(statusStr as String, for: .normal)
            } else {
                self.statusBtn.backgroundColor = RGB(r: 26, g: 151, b: 251)
                self.statusBtn.setTitle("状态正常".localizedStr, for: .normal)
            }
            let imageDefault = UIImage.init(named: "宝贝定位头像-空")
            var width = statusStr.getWidthText(text: statusStr, font: UIFont.systemFont(ofSize: 17), height: 36)
            if width <= 80.0 {
                width = 80+30
            } else {
                width = width + 30
            }
            self.statusBtn.frame = CGRect(x: 0, y: 0, width: width, height: 36)
            self.statusBtn.layoutBtn(status: .CBHorizontalCenterTitleAndImage, space: 10)
            self.bounds = CGRect(x: 0, y: 0, width: width, height: 41 + (imageDefault?.size.height)!)
            self.defaultImageView.frame = CGRect(x: (width - (imageDefault?.size.width)!)/2, y: 41, width: (imageDefault?.size.width)!, height: (imageDefault?.size.height)!)
        } else {
            self.statusBtn.isHidden = true
        }
    }
    @objc private func annotationClick() {
        guard self.avtarClickBlock == nil else {
            self.avtarClickBlock!()
            return
        }
    }
    
    public func hideNameLbl() {
        self.nameLbl.isHidden = true
    }
    
    public func showNameLbl() {
        self.nameLbl.isHidden = false
    }
}
