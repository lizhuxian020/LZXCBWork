//
//  CBPetMsgCterOperateTabCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/4.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetMsgCterOperateTabCell: CBPetBaseTableViewCell {

    private lazy var timeLb:UILabel = {
        let lb = UILabel(text: "09:12".localizedStr, textColor: KPet999999Color, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!,textAlignment: .center)
        return lb
    }()
    private lazy var bgmView:UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        return view
    }()
    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "申请绑定设备提醒".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFang_SC_Bold, size: 14*KFitHeightRate)!,textAlignment: .left)
        return lb
    }()
    private lazy var textLb:UILabel = {
        let lb = UILabel(text: "用户”小明“正向您申请绑定设备宠物”念念“".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!,textAlignment: .left)
        /* label中文与数字混合导致换行 设置text后设置*/
        //lb.lineBreakMode = .byCharWrapping
        return lb
    }()
    private lazy var lineView:UIView = {
        let view = UIView.init()
        view.backgroundColor = KPetLineColor
        return view
    }()
    private lazy var refuseBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "拒绝".localizedStr, titleColor: KPet999999Color, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, borderWidth: 0.8*KFitHeightRate, borderColor: KPet999999Color, cornerRadius: 10*KFitHeightRate)
        return btn
    }()
    private lazy var agreenBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "同意".localizedStr, titleColor: KPetAppColor, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, borderWidth: 0.8*KFitHeightRate, borderColor: KPetAppColor, cornerRadius: 10*KFitHeightRate)
        return btn
    }()
    var dealWithBlock:((_ state:String) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.bgmView.layer.masksToBounds = true
        self.bgmView.layer.cornerRadius = 12*KFitWidthRate
    }
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = KPetBgmColor
    
        self.contentView.addSubview(self.timeLb)
        self.contentView.addSubview(self.bgmView)
        self.bgmView.addSubview(self.titleLb)
        self.bgmView.addSubview(self.lineView)
        self.bgmView.addSubview(self.textLb)
        self.bgmView.addSubview(self.agreenBtn)
        self.bgmView.addSubview(self.refuseBtn)
        
        self.timeLb.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(20*KFitHeightRate)
        }

        self.bgmView.snp_makeConstraints { (make) in
            make.top.equalTo(self.timeLb.snp_bottom).offset(10*KFitHeightRate)
            make.right.equalTo(-20*KFitHeightRate)
            make.left.equalTo(20*KFitHeightRate)
            make.bottom.equalTo(0)
        }
        self.titleLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.bgmView.snp_top).offset(15*KFitHeightRate)
            make.left.equalTo(self.bgmView.snp_left).offset(15*KFitWidthRate)
        }
        self.textLb.snp_makeConstraints { (make) in
            make.top.equalTo(self.titleLb.snp_bottom).offset(12*KFitHeightRate)
            make.left.equalTo(self.bgmView.snp_left).offset(15*KFitWidthRate)
            make.right.equalTo(self.bgmView.snp_right).offset(-15*KFitWidthRate)
            make.height.equalTo(15)
        }
        self.lineView.snp_makeConstraints { (make) in
            make.top.equalTo(self.textLb.snp_bottom).offset(15*KFitHeightRate)
            make.left.equalTo(self.bgmView.snp_left).offset(0)
            make.right.equalTo(self.bgmView.snp_right).offset(0)
            make.height.equalTo(1)
        }
        self.agreenBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.lineView.snp_bottom).offset(8*KFitHeightRate)
            make.right.equalTo(self.bgmView.snp_right).offset(-15*KFitWidthRate)
            make.size.equalTo(CGSize(width: 50*KFitWidthRate, height: 20*KFitHeightRate))
            make.bottom.equalTo(self.bgmView.snp_bottom).offset(-8*KFitHeightRate)
        }
        self.agreenBtn.addTarget(self, action: #selector(dealWithMsgAction), for: .touchUpInside)
        self.refuseBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.agreenBtn)
            make.right.equalTo(self.agreenBtn.snp_left).offset(-12*KFitWidthRate)
            make.size.equalTo(CGSize(width: 50*KFitWidthRate, height: 20*KFitHeightRate))
        }
        self.refuseBtn.addTarget(self, action: #selector(dealWithMsgAction), for: .touchUpInside)
    }
    
    var msgCterSystemOpModel = CBPetMsgCterModel() {
        didSet {
            self.timeLb.text = ""
            if let vaule = self.msgCterSystemOpModel.addTime {
                self.timeLb.text = CBPetUtils.convertTimestampToDateStr(timestamp: vaule.valueStr, formateStr: "yyyy-MM-dd HH:mm:ss")
            }
            titleLb.text = self.msgCterSystemOpModel.title//"申请绑定设备提醒"
            textLb.text = self.msgCterSystemOpModel.text
            
            textLb.setRowSpace(rowSpace: 5*KFitWidthRate)
            /* label中文与数字混合导致换行 设置text后设置*/
            textLb.lineBreakMode = .byCharWrapping
            
            let expectSize = self.textLb.sizeThatFits(CGSize(width: SCREEN_WIDTH - 70*KFitWidthRate, height: SCREEN_HEIGHT*3))
            self.textLb.snp_updateConstraints { (make) in
                make.top.equalTo(self.titleLb.snp_bottom).offset(12*KFitHeightRate)
                make.left.equalTo(self.bgmView.snp_left).offset(15*KFitWidthRate)
                make.right.equalTo(self.bgmView.snp_right).offset(-15*KFitWidthRate)
                make.height.equalTo(expectSize.height)
            }
            switch msgCterSystemOpModel.isAuth {
            case "0":
                /* 已同意*/
                self.setupAgreenBtnIsEnable(isEnable: false)
                self.setupAgreenBtn(title: "已同意".localizedStr)
                let titleWidth = "已同意".getWidthText(text: "已同意".localizedStr, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, height: 22*KFitHeightRate)
                self.agreenBtn.snp_updateConstraints { (make) in
                    make.top.equalTo(self.lineView.snp_bottom).offset(8*KFitHeightRate)
                    make.bottom.equalTo(self.bgmView.snp_bottom).offset(-8*KFitHeightRate)
                    make.right.equalTo(self.bgmView.snp_right).offset(-15*KFitWidthRate)
                    make.size.equalTo(CGSize(width: titleWidth + 20*KFitWidthRate, height: 22*KFitHeightRate))
                }
                self.refuseBtn.snp_updateConstraints { (make) in
                    make.centerY.equalTo(self.agreenBtn)
                    make.right.equalTo(self.agreenBtn.snp_left).offset(-12*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 0*KFitWidthRate, height: 0*KFitHeightRate))
                }
                break
            case "1":
                /* 等待处理 */
                self.setupAgreenBtnIsEnable(isEnable: true)
                self.setupAgreenBtn(title: "同意".localizedStr)
                let titleWidth = "同意".getWidthText(text: "同意".localizedStr, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, height: 22*KFitHeightRate)
                self.agreenBtn.snp_updateConstraints { (make) in
                    make.top.equalTo(self.lineView.snp_bottom).offset(8*KFitHeightRate)
                    make.bottom.equalTo(self.bgmView.snp_bottom).offset(-8*KFitHeightRate)
                    make.right.equalTo(self.bgmView.snp_right).offset(-15*KFitWidthRate)
                    make.size.equalTo(CGSize(width: titleWidth + 20*KFitWidthRate, height: 22*KFitHeightRate))
                }
                self.refuseBtn.snp_updateConstraints { (make) in
                    make.centerY.equalTo(self.agreenBtn)
                    make.right.equalTo(self.agreenBtn.snp_left).offset(-12*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 50*KFitWidthRate, height: 20*KFitHeightRate))
                }
                break
            case "2":
                /* 已拒绝 */
                self.setupAgreenBtnIsEnable(isEnable: false)
                self.setupAgreenBtn(title: "已拒绝".localizedStr)
                let titleWidth = "已拒绝".getWidthText(text: "已拒绝".localizedStr, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, height: 22*KFitHeightRate)
                self.agreenBtn.snp_updateConstraints { (make) in
                    make.top.equalTo(self.lineView.snp_bottom).offset(8*KFitHeightRate)
                    make.bottom.equalTo(self.bgmView.snp_bottom).offset(-8*KFitHeightRate)
                    make.right.equalTo(self.bgmView.snp_right).offset(-15*KFitWidthRate)
                    make.size.equalTo(CGSize(width: titleWidth + 20*KFitWidthRate, height: 22*KFitHeightRate))
                }
                self.refuseBtn.snp_updateConstraints { (make) in
                    make.centerY.equalTo(self.agreenBtn)
                    make.right.equalTo(self.agreenBtn.snp_left).offset(-12*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 0*KFitWidthRate, height: 0*KFitHeightRate))
                }
                break
            default:
                /* 等待处理 */
                self.setupAgreenBtnIsEnable(isEnable: true)
                self.setupAgreenBtn(title: "同意".localizedStr)
                let titleWidth = "同意".getWidthText(text: "同意".localizedStr, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, height: 22*KFitHeightRate)
                self.agreenBtn.snp_updateConstraints { (make) in
                    make.top.equalTo(self.lineView.snp_bottom).offset(8*KFitHeightRate)
                    make.bottom.equalTo(self.bgmView.snp_bottom).offset(-8*KFitHeightRate)
                    make.right.equalTo(self.bgmView.snp_right).offset(-15*KFitWidthRate)
                    make.size.equalTo(CGSize(width: titleWidth + 20*KFitWidthRate, height: 22*KFitHeightRate))
                }
                self.refuseBtn.snp_updateConstraints { (make) in
                    make.centerY.equalTo(self.agreenBtn)
                    make.right.equalTo(self.agreenBtn.snp_left).offset(-12*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 50*KFitWidthRate, height: 20*KFitHeightRate))
                }
                break
            }
        }
    }
    private func setupAgreenBtn(title:String) {
        self.agreenBtn.setTitle(title, for: .normal)
        self.agreenBtn.setTitle(title, for: .highlighted)
    }
    private func setupAgreenBtnIsEnable(isEnable:Bool) {
        if isEnable == false {
            self.agreenBtn.isEnabled = false
            self.agreenBtn.setTitleColor(KPetTextColor, for: .normal)
            self.agreenBtn.setTitleColor(KPetTextColor, for: .highlighted)
            self.agreenBtn.backgroundColor = KPetLineColor
            self.agreenBtn.layer.borderWidth = 0
            self.agreenBtn.layer.borderColor = KPetAppColor.cgColor
        } else {
            self.agreenBtn.isEnabled = true
            self.agreenBtn.setTitleColor(KPetAppColor, for: .normal)
            self.agreenBtn.setTitleColor(KPetAppColor, for: .highlighted)
            self.agreenBtn.backgroundColor = UIColor.white
            self.agreenBtn.layer.borderWidth = 0.8*KFitHeightRate
            self.agreenBtn.layer.borderColor = KPetAppColor.cgColor
        }
    }
    @objc private func dealWithMsgAction(sender:CBPetBaseButton) {
        if sender == self.agreenBtn {
            guard self.dealWithBlock == nil else {
                self.dealWithBlock!("0")
                return
            }
        } else if sender == self.refuseBtn {
            guard self.dealWithBlock == nil else {
                self.dealWithBlock!("2")
                return
            }
        }
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
