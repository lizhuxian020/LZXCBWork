//
//  CBPetFuncLeftCvstionCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/1.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFuncLeftCvstionCell: CBPetBaseTableViewCell {

    private lazy var avatarImageView:UIImageView = {
        let imgV = UIImageView.init()
        imgV.layer.masksToBounds = true
        imgV.layer.cornerRadius = 6*KFitHeightRate
        imgV.backgroundColor = KPetAppColor
        return imgV
    }()
    private lazy var timeLb:UILabel = {
        let lb = UILabel(text: "20:24".localizedStr, textColor: KPet999999Color, font: UIFont(name: CBPingFang_SC, size: 12*KFitHeightRate)!,textAlignment:.center)
        return lb
    }()
    private lazy var bgmView:UIView = {
        let vv = UIView()
        vv.backgroundColor = UIColor.white
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(playVoicClick))
        vv.addGestureRecognizer(tapGesture)
        return vv
    }()
    private lazy var msgLb:UILabel = {
        let lb = UILabel(text: "有时间吗？一起去遛狗？".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        lb.numberOfLines = 0
        return lb
    }()
    private lazy var voiceTimeLb:UILabel = {
        let lb = UILabel(text: "20".localizedStr, textColor: KPet999999Color, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!)
        lb.isHidden = true
        return lb
    }()
    private lazy var playBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(imageName: "pet_func_record_play")
        btn.setImage(UIImage(named: "pet_func_record_pause"), for: .selected)
        btn.isHidden = true
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let maskPath = UIBezierPath.init(roundedRect: self.bgmView.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.topRight.rawValue | UIRectCorner.bottomLeft.rawValue | UIRectCorner.bottomRight.rawValue), cornerRadii: CGSize(width: 18*KFitHeightRate, height: 18*KFitHeightRate))
        let maskLayer = CAShapeLayer.init()
        /* 设置大小*/
        maskLayer.frame = self.bgmView.bounds
        /* 设置图形样子*/
        maskLayer.path = maskPath.cgPath
        self.bgmView.layer.mask = maskLayer
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
    }
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = KPetBgmColor
        
        self.addSubview(self.timeLb)
        self.timeLb.snp_makeConstraints { (make) in
            make.top.equalTo(15*KFitHeightRate)
            make.centerX.equalTo(self)
        }
        
        self.addSubview(self.avatarImageView)
        self.avatarImageView.snp_makeConstraints { (make) in
            make.top.equalTo(self.timeLb.snp_bottom).offset(12*KFitHeightRate)
            make.left.equalTo(20*KFitWidthRate)
            make.size.equalTo(CGSize(width: 36*KFitHeightRate, height: 36*KFitHeightRate))
        }
        
        self.addSubview(self.bgmView)
        self.bgmView.snp_makeConstraints { (make) in
            make.top.equalTo(self.avatarImageView.snp_top).offset(0*KFitHeightRate)
            make.left.equalTo(self.avatarImageView.snp_right).offset(8*KFitWidthRate)
            make.width.equalTo(15*KFitHeightRate)
            make.bottom.equalTo(-15*KFitHeightRate)
            make.height.equalTo(36*KFitHeightRate)
        }
        
        self.bgmView.addSubview(self.msgLb)
        self.msgLb.snp_makeConstraints { (make) in
            make.left.top.equalTo(self.bgmView).offset(12)
            make.right.bottom.equalTo(self.bgmView).offset(-12)
        }
        
        self.bgmView.addSubview(self.voiceTimeLb)
        self.voiceTimeLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.bgmView)
            make.right.equalTo(self.bgmView.snp_right).offset(-13*KFitWidthRate)
        }
        
        self.bgmView.addSubview(self.playBtn)
        self.playBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.bgmView)
            make.left.equalTo(self.bgmView.snp_left).offset(13*KFitWidthRate)
        }
    }
    var petFriendMsgModel:CBPetFuncPetFriendsMsgModel = CBPetFuncPetFriendsMsgModel() {
        didSet {
            self.avatarImageView.sd_setImage(with: URL.init(string: petFriendMsgModel.photo ?? ""), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
        }
    }
    var cvstionModel:CBPetFuncCvstionModel = CBPetFuncCvstionModel() {
        didSet {
            
            NotificationCenter.default.removeObserver(self)
            
            self.timeLb.text = CBPetUtils.convertTimestampToDateStr(timestamp: cvstionModel.add_time ?? "0", formateStr: "yyyy-MM-dd HH:mm:ss")
            //self.avatarImageView.sd_setImage(with: URL.init(string: cvstionModel.photo ?? ""), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
            self.voiceTimeLb.text = "'\(cvstionModel.voiceTime ?? "")'"
            /// 解码
            //self.cvstionModel.message_text = self.cvstionModel.message_text?.removingPercentEncoding
            
            self.msgLb.text = self.cvstionModel.message_text
            /* label中文与数字混合导致换行 设置text后设置*/
            self.msgLb.lineBreakMode = .byCharWrapping
            
            NotificationCenter.default.addObserver(self, selector: #selector(begin), name: NSNotification.Name.init(String.init(format: "%@_begin",cvstionModel.add_time ?? "")), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(stop), name: NSNotification.Name.init(String.init(format: "%@_stop",cvstionModel.add_time ?? "")), object: nil)
            if self.cvstionModel.message_text == nil || self.cvstionModel.message_text?.isEmpty == true {
                /* 语音*/
                self.showText(status: false)
                var expectSize = self.msgLb.sizeThatFits(CGSize(width: SCREEN_WIDTH-128*KFitWidthRate-24, height: SCREEN_HEIGHT))
                if expectSize.width < 120*KFitWidthRate {
                    expectSize.width = 120*KFitWidthRate
                }
                if expectSize.height < 36*KFitHeightRate {
                    expectSize.height = 36*KFitHeightRate
                }
                self.bgmView.snp_updateConstraints { (make) in
                    make.top.equalTo(self.avatarImageView.snp_top).offset(0*KFitHeightRate)
                    make.left.equalTo(self.avatarImageView.snp_right).offset(8*KFitWidthRate)
                    make.width.equalTo(expectSize.width + 24)
                    make.bottom.equalTo(-15*KFitHeightRate)
                    make.height.equalTo(expectSize.height)
                }
            } else {
                /* 文本*/
                var expectSize = self.msgLb.sizeThatFits(CGSize(width: SCREEN_WIDTH-128*KFitWidthRate-24, height: SCREEN_HEIGHT))
                if expectSize.width < 40*KFitWidthRate {
                    expectSize.width = 40*KFitWidthRate
                }
                if expectSize.height < 36*KFitHeightRate {
                    expectSize.height = 36*KFitHeightRate
                }
                let heights = "".getHeightText(text: self.cvstionModel.message_text ?? "", font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, width: SCREEN_WIDTH-74*KFitWidthRate*2)
                self.bgmView.snp_updateConstraints { (make) in
                    make.top.equalTo(self.avatarImageView.snp_top).offset(0*KFitHeightRate)
                    make.left.equalTo(self.avatarImageView.snp_right).offset(8*KFitWidthRate)
                    make.width.equalTo(expectSize.width + 24)
                    make.bottom.equalTo(-15*KFitHeightRate)
                    make.height.equalTo(heights+24)
                }
            }
        }
    }
    private func showText(status:Bool) {
        self.playBtn.isHidden = status
        self.voiceTimeLb.isHidden = status
        self.msgLb.isHidden = !status
    }
    @objc private func playVoicClick() {
        if self.viewModel is CBPetFuncChatViewModel {
            let vvModel = self.viewModel as! CBPetFuncChatViewModel
            guard vvModel.petfriendCvstionChatBlock == nil else {
                vvModel.petfriendCvstionChatBlock!(self.cvstionModel,"2",0)
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
