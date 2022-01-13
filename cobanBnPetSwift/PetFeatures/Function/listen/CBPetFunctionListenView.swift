//
//  CBPetFunctionListenView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/27.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFunctionListenView: CBPetBaseView,CBPetCutmoSlideViewDelegate {

    private lazy var bgmView:UIView = {
        let bgmV = UIView.init()
        bgmV.backgroundColor = UIColor.white
        bgmV.layer.masksToBounds = true
        bgmV.layer.cornerRadius = 16*KFitHeightRate
        return bgmV
    }()
    private lazy var cornerMaxView:UIView = {
        let vv = UIView.init()
        vv.layer.cornerRadius = 60*KFitWidthRate
        return vv
    }()
    private lazy var cornerMaxGradientLayer:CAGradientLayer = {
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 120*KFitHeightRate, height: 120*KFitHeightRate)
        gradientLayer.cornerRadius = 60*KFitHeightRate
        /* 渐变颜色*/
        gradientLayer.colors = [UIColor.init().colorWithHexString(hexString: "#53EEC4", alpha: 0.1).cgColor,UIColor.init().colorWithHexString(hexString: "#2DDFAF", alpha: 0.1).cgColor]

        /* 渐变起始位置*/
        let gradientLocations:[NSNumber] = [0.0,1.0]
        gradientLayer.locations = gradientLocations
        
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 1)
        return gradientLayer
    }()
    private lazy var cornerMinView:UIView = {
        let vv = UIView.init()
        vv.layer.cornerRadius = 50*KFitHeightRate
        return vv
    }()
    private lazy var cornerMinGradientLayer:CAGradientLayer = {
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 100*KFitHeightRate, height: 100*KFitHeightRate)
        gradientLayer.cornerRadius = 50*KFitHeightRate
        /* 渐变颜色*/
        gradientLayer.colors = [UIColor.init().colorWithHexString(hexString: "#53EEC4", alpha: 0.1).cgColor,UIColor.init().colorWithHexString(hexString: "#2DDFAF", alpha: 0.1).cgColor]

        /* 渐变起始位置*/
        let gradientLocations:[NSNumber] = [0.0,1.0]
        gradientLayer.locations = gradientLocations
        
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 1)
        return gradientLayer
    }()
    private lazy var avtarImageView:UIImageView = {
        let imageV = UIImageView.init()
        imageV.layer.masksToBounds = true
        imageV.layer.cornerRadius = 40*KFitHeightRate
        imageV.backgroundColor = UIColor.gray
        return imageV
    }()
    private lazy var titleLb:UILabel = {
        let lb = UILabel.init()
        lb.text = "是否听听念念的声音".localizedStr
        lb.textAlignment = .center
        lb.textColor = KPetTextColor
        lb.font = UIFont.init(name: CBPingFang_SC_Bold, size: 14*KFitHeightRate)
        return lb
    }()
    internal lazy var inputTimeView:CBPetFuncInputView = {
        let inputV = CBPetFuncInputView.init()
        return inputV
    }()
    public lazy var sliderView:CBPetCustomSlideView = {
        let slideV = CBPetCustomSlideView.init()
        slideV.slideDeleate = self
        return slideV
    }()
    private lazy var closeBtn:UIButton = {
        let btn = UIButton(imageName: "pet_function_shout_cancel")
        return btn
    }()
    private lazy var comfirmBtn:UIButton = {
        let btn = UIButton(imageName: "pet_function_shout_comfirm")
        return btn
    }()
    private var paramtersModel:CBPetHomeParamtersModel?
    
    var setListenBlock:((_ filePath:String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.cornerMaxView.layer.addSublayer(self.cornerMaxGradientLayer)
        self.cornerMinView.layer.addSublayer(self.cornerMinGradientLayer)
    }
    private func setupView() {
        self.backgroundColor = UIColor.init().colorWithHexString(hexString: "#222222", alpha: 0.85)
        
        self.addSubview(self.bgmView)
        self.bgmView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 270*KFitWidthRate, height: 330*KFitHeightRate))
        }
        
        self.bgmView.addSubview(self.cornerMaxView)
        self.cornerMaxView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.bgmView.snp_centerX)
            make.top.equalTo(self.bgmView.snp_top).offset(24*KFitHeightRate)
            make.size.equalTo(CGSize(width: 120*KFitHeightRate, height: 120*KFitHeightRate))
        }
        
        self.bgmView.addSubview(self.cornerMinView)
        self.cornerMinView.snp_makeConstraints { (make) in
            make.center.equalTo(self.cornerMaxView)
            make.size.equalTo(CGSize(width: 100*KFitHeightRate, height: 100*KFitHeightRate))
        }
        self.bgmView.addSubview(self.avtarImageView)
        self.avtarImageView.snp_makeConstraints { (make) in
            make.center.equalTo(self.cornerMaxView)
            make.size.equalTo(CGSize(width: 80*KFitHeightRate, height: 80*KFitHeightRate))
        }
        
        self.bgmView.addSubview(self.titleLb)
        self.titleLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.cornerMaxView.snp_bottom).offset(20*KFitHeightRate)
            make.centerX.equalTo(self.bgmView.snp_centerX)
            make.height.equalTo(15*KFitHeightRate)
        }
        
        self.bgmView.addSubview(self.inputTimeView)
        self.inputTimeView.snp_makeConstraints { (make) in
            make.top.equalTo(self.titleLb.snp_bottom).offset(15*KFitHeightRate)
            make.left.right.equalTo(self.bgmView)
            make.height.equalTo(15*KFitHeightRate)
        }
        
        self.bgmView.addSubview(self.sliderView)
        self.sliderView.snp_makeConstraints { (make) in
            make.top.equalTo(self.inputTimeView.snp_bottom).offset(10*KFitHeightRate)
            make.left.equalTo(self.bgmView.snp_left).offset(20*KFitWidthRate)
            make.right.equalTo(self.bgmView.snp_right).offset(-20*KFitWidthRate)
            make.height.equalTo(35*KFitHeightRate)
        }
        //self.sliderView.setSlideDataSource(dataSourse: ["5","10","15","20","25","30"],hideTargetIndex: [])
        
        self.bgmView.addSubview(self.closeBtn)
        let closeImage = UIImage.init(named: "pet_function_shout_cancel")!
        self.closeBtn.snp_makeConstraints { (make) in
            make.bottom.equalTo(-20*KFitHeightRate)
            make.right.equalTo(self.bgmView.snp_centerX).offset(-16*KFitWidthRate)
            make.size.equalTo(CGSize(width: closeImage.size.width, height: closeImage.size.height))
        }
        self.closeBtn.addTarget(self, action: #selector(dissmiss), for: .touchUpInside)
        
        self.bgmView.addSubview(self.comfirmBtn)
        let comfirmImage = UIImage.init(named: "pet_function_shout_comfirm")!
        self.comfirmBtn.snp_makeConstraints { (make) in
            make.bottom.equalTo(-20*KFitHeightRate)
            make.left.equalTo(self.bgmView.snp_centerX).offset(16*KFitWidthRate)
            make.size.equalTo(CGSize(width: comfirmImage.size.width, height: comfirmImage.size.height))
        }
        self.comfirmBtn.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
    }
    func updateListenData(model:CBPetHomeParamtersModel) {
        self.paramtersModel = model
        self.titleLb.text = "是否听听".localizedStr + " \"" + (CBPetHomeInfoTool.getHomeInfo().pet.name ?? "") + "\" " + "的声音".localizedStr
        self.inputTimeView.inputTF.text = model.listenTime
        self.avtarImageView.sd_setImage(with: URL.init(string: CBPetHomeInfoTool.getHomeInfo().pet.photo ?? ""), placeholderImage: UIImage(named: "pet_psnal_petDefaultAvatar"), options: [])
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute:{
            self.sliderView.setSliderValue(value: Float((model.listenTime ?? "5") as String)!)
        })
    }
    public func popView() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    @objc private func confirmClick() {
        guard self.setListenBlock == nil else {
            self.setListenBlock!(self.inputTimeView.inputTF.text ?? "")
            self.updateListenData(model: self.paramtersModel ?? CBPetHomeParamtersModel())
            self.removeFromSuperview()
            return
        }
        self.updateListenData(model: self.paramtersModel ?? CBPetHomeParamtersModel())
        self.removeFromSuperview()
    }
    @objc private func dissmiss() {
        self.updateListenData(model: self.paramtersModel ?? CBPetHomeParamtersModel())
        self.removeFromSuperview()
    }
    //MARK: - 听听滑动设置时间代理
    func returnSlideValue(slideValue: String) {
        self.inputTimeView.inputTF.text = slideValue
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
