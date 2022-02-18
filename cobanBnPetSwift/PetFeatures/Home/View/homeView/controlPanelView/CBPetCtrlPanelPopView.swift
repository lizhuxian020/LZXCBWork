//
//  CBPetCtrlPanelPopView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/5.
//  Copyright © 2020 coban. All rights reserved.
//
//        //创建一个模糊效果
//        let blurEffect = UIBlurEffect(style: .light)
//        //创建一个承载模糊效果的视图
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.frame = self.frame
//        blurView.alpha = 0.9
//
//        //创建并添加vibrancy视图
//        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
//        let vibrancyView = UIVisualEffectView(effect:vibrancyEffect)
//        vibrancyView.frame = self.bounds
////        let label = UILabel(frame: CGRect(x: 10, y: viewY, width: viewWidth - 20, height: 100))
////        label.text = "bfjnecsjdkcmslc,samosacmsacdfvneaui"
////        label.font = UIFont.boldSystemFont(ofSize: 30)
////        label.numberOfLines = 0
////        label.textAlignment = .center
////        label.textColor = UIColor.white
////        vibrancyView.contentView.addSubview(label)
//        blurView.contentView.addSubview(vibrancyView)
//
//        self.addSubview(blurView)

import UIKit

class CBPetCtrlPanelPopView: CBPetBaseView,UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate {

    private lazy var bgmView:UIView = {
        let bgmV = UIView.init()
        bgmV.backgroundColor = UIColor.white
        bgmV.layer.masksToBounds = true
        bgmV.layer.cornerRadius = 16*KFitHeightRate
        return bgmV
    }()
    private lazy var ctrlPanelTableView:UITableView = {
        let tableV:UITableView = UITableView(frame: CGRect.zero, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = UIColor.white
        tableV.separatorStyle = .none
        tableV.estimatedRowHeight = 53*KFitHeightRate
        tableV.rowHeight = UITableView.automaticDimension
        tableV.register(CBPetCtrlPanelPopSwitchCell.self, forCellReuseIdentifier: "CBPetCtrlPanelPopSwitchCell")
        tableV.register(CBPetCtrlPanelPopCell.self, forCellReuseIdentifier: "CBPetCtrlPanelPopCell")
        return tableV
    }()
    private lazy var arrayDataSource:[CBPetCtrlPanelModel] = {
        let arr = [CBPetCtrlPanelModel]()
        return arr
    }()
    private lazy var footView:UIView = {
       let bgmV = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 53*KFitHeightRate))
       bgmV.backgroundColor = UIColor.white
       return bgmV
    }()
    private lazy var deviceStatusLb:UILabel = {
       let lb = UILabel(text: "设备：已连接", textColor: KPetAppColor, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!)
       return lb
    }()
    private lazy var percentLb:UILabel = {
        let lb = UILabel(text: "75%", textColor: KPetAppColor, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!,textAlignment: .right)
       return lb
    }()
    private lazy var powerImageView:UIImageView = {
        let imageV = UIImageView.init()
        return imageV
    }()
    private lazy var powerBgmView:UIView = {
        let vv = UIView.init()
        vv.backgroundColor = KPetAppColor
        return vv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
        self.ctrlPanelTableView.reloadData()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        
        self.bgmView.snp_updateConstraints { (make) in
            make.center.equalTo(self)
            make.left.equalTo(53*KFitWidthRate)
            make.right.equalTo(-53*KFitWidthRate)
            make.height.equalTo(self.ctrlPanelTableView.contentSize.height)
        }
    }
    private func setupView() {
        self.backgroundColor = UIColor.init().colorWithHexString(hexString: "#222222", alpha: 0.2)
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureMethod))
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = false;
        tapGestureRecognizer.delegate = self;
        //将触摸事件添加到当前view
        self.addGestureRecognizer(tapGestureRecognizer)
        self.addSubview(self.bgmView)
        self.bgmView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.left.equalTo(53*KFitWidthRate)
            make.right.equalTo(-53*KFitWidthRate)
            make.height.equalTo(380*KFitHeightRate)
        }
        
        self.bgmView.addSubview(self.ctrlPanelTableView)
        self.ctrlPanelTableView.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.bgmView)
        }
        
        let arrayTitle = ["电子围栏开启".localizedStr,"挂失开启".localizedStr,
                          "设置回家语音".localizedStr,"设置时区".localizedStr,"定时报告".localizedStr]
        let arrayText = ["电子围栏，当宠物出围栏时app能收到报警并提示主人。注意：开启此功能后会打开设备的GPS，耗电量会增加。".localizedStr,"挂失后，只要设备开机就自动发送位置给APP，请耐心等候。".localizedStr,"录音1".localizedStr,"+12".localizedStr,"定时报告,设备将会每天指定时间上报位置,最多可设置三个时间。注意:开启后设备将超低功耗运行无法通讯,只有到达指定时间才唤醒并工作三分钟".localizedStr]
        for index in 0..<arrayTitle.count {
            var model = CBPetCtrlPanelModel()
            model.title = arrayTitle[index]
            model.text = arrayText[index]
            self.arrayDataSource.append(model)
        }
        
        self.footView.addSubview(self.deviceStatusLb)
        self.deviceStatusLb.snp_makeConstraints { (make) in
            make.top.equalTo(0*KFitHeightRate)
            make.left.equalTo(self.footView.snp_left).offset(25*KFitWidthRate)
        }
        self.footView.addSubview(self.percentLb)
        self.percentLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.deviceStatusLb)
            make.right.equalTo(self.footView.snp_right).offset(-25*KFitWidthRate)
        }
        let powerImage = UIImage(named: "pet_home_power")!
        self.powerImageView.image = powerImage
        self.footView.addSubview(self.powerImageView)
        self.powerImageView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.deviceStatusLb)
            make.right.equalTo(self.percentLb.snp_left).offset(-5*KFitWidthRate)
            make.size.equalTo(CGSize(width: powerImage.size.width, height: powerImage.size.height))
        }
        
        self.powerImageView.addSubview(self.powerBgmView)
        self.powerBgmView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.powerImageView)
            make.height.equalTo(powerImage.size.height-4)
            make.left.equalTo(self.powerImageView.snp_left).offset(2)
            make.width.equalTo((powerImage.size.width-2-4))
        }
    }
    public func popView() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    @objc public func dissmiss() {
        self.removeFromSuperview()
    }
    @objc private func toRecordClick() {
        guard (self.viewModel as! CBPetHomeViewModel).toRecordBlock == nil else {
            (self.viewModel as! CBPetHomeViewModel).toRecordBlock!()
            self.dissmiss()
            return
        }
    }
    @objc private func tapGestureMethod(tap:UITapGestureRecognizer) {
        CBPetCtrlPanelView.share.dismissCtrlViewClick()
        //self.dissmiss()
    }
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        /* 判断该区域是否包含某个指定的区域 */
        if self.bgmView.frame.contains(gestureRecognizer.location(in: self)) {
            return false
        }
        return true
    }
    func getSimCardTypeStr() -> String {
        guard let simCardType = CBPetHomeInfoTool.getHomeInfo().pet.device.simCardType else {return ""}
        if simCardType == "0" {
            return "NB"
        } else if simCardType == "1" {
            return "2g"
        } else {
            return ""
        }
    }
    func updateParamters(model:CBPetHomeParamtersModel) {
        if self.arrayDataSource.count >= 4 {
            self.arrayDataSource[0].fenceSwitch = model.fenceSwitch
            self.arrayDataSource[1].callPosiAction = model.callPosiAction
            self.arrayDataSource[2].fileRecord = model.fileRecord
            self.arrayDataSource[3].timeZone = model.timeZone
            self.arrayDataSource[4].timingSwitch = model.timingSwitch
            self.ctrlPanelTableView.reloadData()
        }
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.online {
            if value.valueStr == "0" {
                self.deviceStatusLb.text = "设备：".localizedStr + getSimCardTypeStr() + "未连接".localizedStr
            } else if value.valueStr == "1" {
                self.deviceStatusLb.text = "设备：".localizedStr + getSimCardTypeStr() + "已连接".localizedStr
            } else {
                self.deviceStatusLb.text = "设备：无".localizedStr
            }
        } else {
            self.deviceStatusLb.text = "设备：无".localizedStr
        }
        if let value = CBPetHomeInfoTool.getHomeInfo().pet.device.location.baterry {
            self.percentLb.text = "\(value.valueStr)%"
            let percentNum = Float(value.valueStr) ?? 0
            if percentNum <= 10 {
                self.powerBgmView.backgroundColor = UIColor.init().colorWithHexString(hexString: "#F8563B")
            } else if percentNum <= 20 && percentNum > 10 {
                self.powerBgmView.backgroundColor = UIColor.yellow
            } else {
                self.powerBgmView.backgroundColor = KPetAppColor
            }
            self.powerBgmView.isHidden = false
            self.powerImageView.isHidden = false
            let powerImage = UIImage(named: "pet_home_power")!
            self.powerBgmView.snp_updateConstraints { (make) in
                make.centerY.equalTo(self.powerImageView)
                make.height.equalTo(powerImage.size.height-4)
                make.left.equalTo(self.powerImageView.snp_left).offset(2)
                make.width.equalTo((powerImage.size.width-2-4)*CGFloat(percentNum)/100)
            }
        } else {
            self.percentLb.text = ""
            self.powerBgmView.isHidden = true
            self.powerImageView.isHidden = true
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let switchCell = tableView.dequeueReusableCell(withIdentifier: "CBPetCtrlPanelPopSwitchCell") as! CBPetCtrlPanelPopSwitchCell
        let normalCell = tableView.dequeueReusableCell(withIdentifier: "CBPetCtrlPanelPopCell") as! CBPetCtrlPanelPopCell
        if self.arrayDataSource.count > indexPath.row {
            if indexPath.row < 2 || self.arrayDataSource[indexPath.row].title == "定时报告".localizedStr {
                let model = self.arrayDataSource[indexPath.row]
                if self.viewModel is CBPetHomeViewModel {
                    switchCell.setupViewModel(viewModel: self.viewModel)
                }
                switchCell.ctrlPnaneSwitchModel = model
                return switchCell
            } else {
                let model = self.arrayDataSource[indexPath.row]
                if self.viewModel is CBPetHomeViewModel {
                    normalCell.setupViewModel(viewModel: self.viewModel)
                }
                normalCell.ctrlPanelModel = model
                return normalCell
            }
        } else {
            return UITableViewCell.init()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= 2 || self.arrayDataSource[indexPath.row].title == "定时报告".localizedStr{
            let model = self.arrayDataSource[indexPath.row]
            if self.viewModel is CBPetHomeViewModel {
                let homeViewModel = self.viewModel as! CBPetHomeViewModel
                guard homeViewModel.ctrlPanelClickBlock == nil else {
                    homeViewModel.ctrlPanelClickBlock!(model.title as Any,false,false)
                    return
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.footView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 53*KFitHeightRate
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
