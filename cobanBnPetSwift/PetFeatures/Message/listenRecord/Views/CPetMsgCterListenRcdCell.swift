//
//  CPetMsgCterListenRcdCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/5.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

//let bgm_width = SCREEN_WIDTH - (20 + 36 + 10 + 10)*KFitWidthRate

class CPetMsgCterListenRcdCell: CBPetBaseTableViewCell {

    private lazy var timeLb:UILabel = {
        let lb = UILabel(text: "2020/5/5 09:12".localizedStr, textColor: KPet999999Color, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!,textAlignment: .center)
        return lb
    }()
    private lazy var avatarImageView:UIImageView = {
        let imgV = UIImageView.init()
        imgV.image = UIImage(named: "pet_psnal_petDefaultAvatar")
        imgV.layer.masksToBounds = true
        imgV.layer.cornerRadius = 18*KFitHeightRate
        imgV.backgroundColor = UIColor.white//KPetAppColor
        return imgV
    }()
    private lazy var nameLb:UILabel = {
        let lb = UILabel(text: "围栏警告".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!,textAlignment: .left)
        return lb
    }()
    private lazy var bgmView:UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(playAction))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    private lazy var playBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(imageName: "pet_func_record_play")
        btn.setImage(UIImage(named: "pet_func_record_pause"), for: .selected)
        btn.isUserInteractionEnabled = false
        return btn
    }()
    private lazy var voiceTimeLb:UILabel = {
        let lb = UILabel(text: "20”".localizedStr, textColor: KPetC8C8C8Color, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        return lb
    }()
    private lazy var redCornerView:UIView = {
        let vv = UIView()
        vv.isHidden = true
        vv.backgroundColor = UIColor.init().colorWithHexString(hexString: "#F8563B")
        return vv
    }()
    private var bgm_width:CGFloat = SCREEN_WIDTH - (20 + 36 + 10 + 10)*KFitWidthRate
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.redCornerView.layer.masksToBounds = true
        self.redCornerView.layer.cornerRadius = 3*KFitHeightRate
        
        let maskPath = UIBezierPath.init(roundedRect: self.bgmView.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.topRight.rawValue | UIRectCorner.bottomLeft.rawValue | UIRectCorner.bottomRight.rawValue), cornerRadii: CGSize(width: 18*KFitHeightRate, height: 18*KFitHeightRate))
        let maskLayer = CAShapeLayer.init()
        /* 设置大小*/
        maskLayer.frame = self.bgmView.bounds
        /* 设置图形样子*/
        maskLayer.path = maskPath.cgPath
        self.bgmView.layer.mask = maskLayer
    }
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = KPetBgmColor
    
        self.contentView.addSubview(self.timeLb)
        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.nameLb)
        self.contentView.addSubview(self.bgmView)
        self.bgmView.addSubview(self.playBtn)
        self.bgmView.addSubview(self.voiceTimeLb)
        self.contentView.addSubview(self.redCornerView)
        
        self.timeLb.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(30*KFitHeightRate)
        }
        self.avatarImageView.snp_makeConstraints { (make) in
            make.top.equalTo(self.timeLb.snp_bottom).offset(10*KFitHeightRate)
            make.left.equalTo(20*KFitHeightRate)
            make.size.equalTo(CGSize(width: 36*KFitHeightRate, height: 36*KFitHeightRate))
        }
        self.nameLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.avatarImageView.snp_top)
            make.left.equalTo(self.avatarImageView.snp_right).offset(9*KFitWidthRate)
        }
        self.bgmView.snp_makeConstraints { (make) in
            make.top.equalTo(self.nameLb.snp_bottom).offset(5*KFitHeightRate)
            make.left.equalTo(self.avatarImageView.snp_right).offset(9*KFitWidthRate)
            make.height.equalTo(36*KFitHeightRate)
            make.width.equalTo(150*KFitWidthRate)
            make.bottom.equalTo(-5)
        }
        self.playBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.bgmView)
            make.left.equalTo(self.bgmView.snp_left).offset(12*KFitWidthRate)
        }
        //self.playBtn.addTarget(self, action: #selector(playAction), for: .touchUpInside)
        self.voiceTimeLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.bgmView)
            make.right.equalTo(self.bgmView.snp_right).offset(-15*KFitWidthRate)
        }
        self.voiceTimeLb.text = "30'"
        self.redCornerView.snp_makeConstraints { (make) in
            make.top.equalTo(self.bgmView.snp_top)
            make.left.equalTo(self.bgmView.snp_right)
            make.size.equalTo(CGSize(width: 6*KFitHeightRate, height: 6*KFitHeightRate))
        }
        
    }
    
    var msgCterListenModel = CBPetMsgCterModel() {
        didSet {
            
            NotificationCenter.default.removeObserver(self)
            
            self.timeLb.text = ""
            if let value = self.msgCterListenModel.updateTime {
                //self.timeLb.text = CBPetUtils.convertTimestampToDateStr(timestamp: vaule.valueStr, formateStr: "yyyy-MM-dd HH:mm:ss")
                if let valueTimeZone = CBPetHomeParamtersModel.getHomeParamters().timeZone {
                    self.timeLb.text = CBPetUtils.convertTimestampToDateStr(timestamp: value.valueStr, formateStr: "yyyy-MM-dd HH:mm:ss",timeZone: Int(valueTimeZone) ?? 0)
                }
            }
            nameLb.text = self.msgCterListenModel.title
            self.avatarImageView.sd_setImage(with: URL.init(string: msgCterListenModel.petHead ?? "pet_psnal_defaultAvatar"), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
            
            self.voiceTimeLb.text = (self.msgCterListenModel.voiceTime ?? "") + "\'"
            let voiceTime:Double = Double(self.msgCterListenModel.voiceTime ?? "0")!
            let time_width:CGFloat = CGFloat(voiceTime/30.0)
            
            self.bgmView.snp_updateConstraints { (make) in
                make.top.equalTo(self.nameLb.snp_bottom).offset(5*KFitHeightRate)
                make.left.equalTo(self.avatarImageView.snp_right).offset(9*KFitWidthRate)
                make.height.equalTo(36*KFitHeightRate)
                 //(20 + 36 + 10 + 10)*KFitWidthRate
                make.width.equalTo(self.bgm_width*time_width)
                make.bottom.equalTo(-5)
            }
            
            self.redCornerView.isHidden = self.msgCterListenModel.isRead == "1" ? true : false
            if self.msgCterListenModel.isRead == nil {
                self.redCornerView.isHidden = true
            }
            if voiceTime == 0 {
                self.redCornerView.isHidden = true
            }
            
            NotificationCenter.default.addObserver(self, selector: #selector(begin), name: NSNotification.Name.init(String.init(format: "%@_begin",msgCterListenModel.addTime ?? "")), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(stop), name: NSNotification.Name.init(String.init(format: "%@_stop",msgCterListenModel.addTime ?? "")), object: nil)
        }
    }
    @objc private func playAction(sender:UIGestureRecognizer) {
        if self.viewModel is CBPetMsgCterViewModel {
            guard (self.viewModel as! CBPetMsgCterViewModel).listenRcdPlayUIBlock == nil else {
                (self.viewModel as! CBPetMsgCterViewModel).listenRcdPlayUIBlock!(self.msgCterListenModel)
                return
            }
        }
    }
    @objc private func begin() {
        self.playBtn.isSelected = true
    }
    @objc private func stop() {
        self.playBtn.isSelected = false
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
