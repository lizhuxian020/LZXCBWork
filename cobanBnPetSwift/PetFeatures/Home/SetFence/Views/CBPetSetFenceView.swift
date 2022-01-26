//
//  CBPetSetFenceView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/6.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetSetFenceView: CBPetBaseView, CBPetCutmoSlideViewDelegate {

    private lazy var shadowBgmView:UIView = {
        let bgmV = UIView(backgroundColor: UIColor.white, cornerRadius: 16*KFitHeightRate, shadowColor: KPetC8C8C8Color, shadowOpacity: 0.85, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 8)
        return bgmV
    }()
    private lazy var bgmView:UIView = {
        let bgmV = UIView.init()
        bgmV.backgroundColor = UIColor.white
        return bgmV
    }()
    public lazy var addressLb:UILabel = {
        ///广东省深圳市南山区关口二路5号
        let lb = UILabel(text: "".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)!)
        return lb
    }()
    internal lazy var inputRadiusView:CBPetSetFenceInputView = {
        let inputV = CBPetSetFenceInputView.init()
        return inputV
    }()
//    private lazy var sliderView:CBPetCustomSlideView = {
//        let slideV = CBPetCustomSlideView.init()
//        slideV.slideDeleate = self
//        return slideV
//    }()
    private var homeInfoModel:CBPetHomeInfoModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let maskPath = UIBezierPath.init(roundedRect: self.bgmView.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.bottomLeft.rawValue | UIRectCorner.bottomRight.rawValue), cornerRadii: CGSize(width: 16*KFitHeightRate, height: 16*KFitHeightRate))
        let maskLayer = CAShapeLayer.init()
        /* 设置大小*/
        maskLayer.frame = self.bgmView.bounds
        /* 设置图形样子*/
        maskLayer.path = maskPath.cgPath
        self.bgmView.layer.mask = maskLayer
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
        if self.viewModel is CBPetHomeViewModel {
            let vvModel = self.viewModel as! CBPetHomeViewModel
            self.homeInfoModel = vvModel.homeInfoModel
            if let value = self.homeInfoModel?.fence.data?.components(separatedBy: ",") {
                if value.count >= 3 {
                    self.inputRadiusView.inputTF.text = value[2]
//                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute:{
//                        self.sliderView.setSliderValue(value: Float(value[2] as String)! < 100 ? 100 : Float(value[2] as String)!)
//                    })
                }
            }
        }
    }
    private func setupView() {
        self.backgroundColor = UIColor.init().colorWithHexString(hexString: "#222222", alpha: 0.00)
        self.addSubview(self.shadowBgmView)
        self.shadowBgmView.snp_makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self)
        }
        self.addSubview(self.bgmView)
        self.bgmView.snp_makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self)
        }
        
        self.addSubview(self.addressLb)
        self.addressLb.snp_makeConstraints { (make) in
            make.top.equalTo(20*KFitHeightRate)
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo(-20*KFitWidthRate)
        }
        
        let line = CBPetUtilsCreate.createLineView()
        line.backgroundColor = KPetLineColor
        self.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo(-20*KFitWidthRate)
            make.top.equalTo(self.addressLb.snp_bottom).offset(20*KFitHeightRate)
            make.height.equalTo(1)
        }
        
        self.addSubview(self.inputRadiusView)
        self.inputRadiusView.snp_makeConstraints { (make) in
            make.top.equalTo(line.snp_bottom).offset(15*KFitHeightRate)
            make.left.right.equalTo(self)
            make.height.equalTo(15*KFitHeightRate)
        }
        
//        self.addSubview(self.sliderView)
//        self.sliderView.snp_makeConstraints { (make) in
//            make.top.equalTo(self.inputRadiusView.snp_bottom).offset(10*KFitHeightRate)
//            make.left.equalTo(self.snp_left).offset(20*KFitWidthRate)
//            make.right.equalTo(self.snp_right).offset(-20*KFitWidthRate)
//            make.height.equalTo(35*KFitHeightRate)
//        }
//        self.sliderView.setSlideDataSource(dataSourse: ["100","200","300","400","500","600","700","800","900","1000"], hideTargetIndex: [2,4,6,8])
    }
    //MARK: - 滑动代理
    func returnSlideValue(slideValue: String) {
        self.inputRadiusView.inputTF.text = slideValue
        if self.viewModel is CBPetHomeViewModel {
            let vvModel = self.viewModel as! CBPetHomeViewModel
            guard vvModel.petHomeSetFenceBlock == nil else {
                vvModel.petHomeSetFenceBlock!("slideValue",slideValue)
                return
            }
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
