//
//  CBPetMsgCterLocationRcdCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/16.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetMsgCterLocationRcdCell: CBPetBaseTableViewCell,BMKGeoCodeSearchDelegate {

    private lazy var timeLb:UILabel = {
        let lb = UILabel(text: "2020/5/5 09:12".localizedStr, textColor: KPet999999Color, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!,textAlignment: .center)
        return lb
    }()
    private lazy var bgmView:UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        return view
    }()
    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "更新资料".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .left)
        return lb
    }()
    private lazy var textLb:UILabel = { //用户”小明“正向您申请绑定设备宠物”念念“
        let lb = UILabel(text: "".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!,textAlignment: .left)
        /* label中文与数字混合导致换行*/
        lb.lineBreakMode = .byCharWrapping
        return lb
    }()
    private lazy var lineView:UIView = {
        let view = UIView.init()
        view.backgroundColor = KPetLineColor
        return view
    }()
    private lazy var showBtn_text:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "展开".localizedStr, titleColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!)
        btn.setTitle("收起".localizedStr, for: .selected)
        return btn
    }()
    private lazy var showBtn_image:CBPetBaseButton = {
        let btn = CBPetBaseButton(imageName: "pet_msg_showDetail")
        btn.setImage(UIImage(named: "pet_msg_hideDetail"), for: .selected)
        return btn
    }()
    public lazy var searcher:BMKGeoCodeSearch = {
        let search = BMKGeoCodeSearch.init()
        return search
    }()
    
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
        self.bgmView.addSubview(self.showBtn_text)
        self.bgmView.addSubview(self.showBtn_image)
        
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
        }
        self.lineView.snp_makeConstraints { (make) in
            make.top.equalTo(self.textLb.snp_bottom).offset(15*KFitHeightRate)
            make.left.equalTo(self.bgmView.snp_left).offset(0)
            make.right.equalTo(self.bgmView.snp_right).offset(0)
            make.height.equalTo(1)
        }
        self.showBtn_text.snp_makeConstraints { (make) in
            make.top.equalTo(self.lineView.snp_bottom).offset(12*KFitHeightRate)
            make.left.equalTo(self.bgmView.snp_left).offset(15*KFitWidthRate)
            make.size.equalTo(CGSize(width: 44*KFitWidthRate, height: 20*KFitHeightRate))
            make.bottom.equalTo(self.bgmView.snp_bottom).offset(-12*KFitHeightRate)
        }
        let showImage = UIImage(named: "pet_msg_hideDetail")!
        self.showBtn_image.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.showBtn_text)
            make.right.equalTo(self.bgmView.snp_right).offset(-15*KFitWidthRate)
            make.size.equalTo(CGSize(width: showImage.size.width, height: showImage.size.height))
        }
        self.showBtn_text.addTarget(self, action: #selector(showOrHideAction), for: .touchUpInside)
        self.showBtn_image.addTarget(self, action: #selector(showOrHideAction), for: .touchUpInside)
    }
    public var msgModel:CBPetMsgCterModel?
    var msgCterLocationRcdModel = CBPetMsgCterModel() {
        didSet {
            self.timeLb.text = ""
            if let vaule = self.msgCterLocationRcdModel.add_time {
                self.timeLb.text = CBPetUtils.convertTimestampToDateStr(timestamp: vaule.valueStr, formateStr: "yyyy-MM-dd HH:mm:ss")
            }
            self.titleLb.text = self.msgCterLocationRcdModel.title

//            self.textLb.text = self.msgCterLocationRcdModel.text
//            self.updateTextLayout(textStr: self.msgCterLocationRcdModel.text)
//            self.showBtn_text.isSelected = self.msgCterLocationRcdModel.isShow ?? false
//            self.showBtn_image.isSelected = self.msgCterLocationRcdModel.isShow ?? false
            
//            DispatchQueue.global().async {
//                DispatchQueue.main.async(execute: {
//                    self.getAddress()
//                })
//            }

            self.getAddress()
        }
    }
    
    private func updateTextLayout(textStr:String) {
        self.textLb.setRowSpace(rowSpace: 5*KFitHeightRate)
        let expectSize = self.textLb.sizeThatFits(CGSize(width: SCREEN_WIDTH - 70*KFitWidthRate, height: SCREEN_HEIGHT*3))
        
        let textHeightdddd = "".getHeightText(text: textStr, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, width: expectSize.width)
        if (expectSize.height/textHeightdddd) > 1 {/// 存在换行 self.textLb.font.lineHeight
            setUpHidden(isHidden: false)
            /* 有展示更多的操作*/
            if self.msgCterLocationRcdModel.isShow {
                /* 展示*/
                self.textLb.snp_remakeConstraints { (make) in
                    make.top.equalTo(self.titleLb.snp_bottom).offset(12*KFitHeightRate)
                    make.left.equalTo(self.bgmView.snp_left).offset(15*KFitWidthRate)
                    make.right.equalTo(self.bgmView.snp_right).offset(-15*KFitWidthRate)
                    make.height.equalTo(expectSize.height)
                }
            } else {
                self.textLb.snp_remakeConstraints { (make) in
                    make.top.equalTo(self.titleLb.snp_bottom).offset(12*KFitHeightRate)
                    make.left.equalTo(self.bgmView.snp_left).offset(15*KFitWidthRate)
                    make.right.equalTo(self.bgmView.snp_right).offset(-15*KFitWidthRate)
                    make.height.equalTo(self.textLb.font.lineHeight)
                }
            }
            self.updateLayoutShowMore()
        } else {
            /* 不存在第二行 无展示更多的操作*/
            setUpHidden(isHidden: true)
            self.textLb.snp_remakeConstraints { (make) in
                make.top.equalTo(self.titleLb.snp_bottom).offset(12*KFitHeightRate)
                make.left.equalTo(self.bgmView.snp_left).offset(15*KFitWidthRate)
                make.right.equalTo(self.bgmView.snp_right).offset(-15*KFitWidthRate)
                make.height.equalTo(self.textLb.font.lineHeight)
            }
            self.updateLayoutNoMore()
        }
    }
    private func setUpHidden(isHidden:Bool) {
        self.lineView.isHidden = isHidden
        self.showBtn_text.isHidden = isHidden
        self.showBtn_image.isHidden = isHidden
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
extension CBPetMsgCterLocationRcdCell {
    @objc private func showOrHideAction(sender:CBPetBaseButton) {
        sender.isSelected = !sender.isSelected
        self.showBtn_image.isSelected = sender.isSelected
        self.showBtn_text.isSelected = sender.isSelected
        self.msgCterLocationRcdModel.isShow = sender.isSelected
        if self.viewModel is CBPetMsgCterViewModel {
            guard (self.viewModel as! CBPetMsgCterViewModel).showMoreClickBlock == nil else {
                (self.viewModel as! CBPetMsgCterViewModel).showMoreClickBlock!(self.msgCterLocationRcdModel)
                return
            }
        }
    }
    private func updateLayoutNoMore() {
        self.lineView.snp_updateConstraints { (make) in
            make.top.equalTo(self.textLb.snp_bottom).offset(15*KFitHeightRate)
            make.left.equalTo(self.bgmView.snp_left).offset(0)
            make.right.equalTo(self.bgmView.snp_right).offset(0)
            make.height.equalTo(0)
        }
        self.showBtn_text.snp_updateConstraints { (make) in
            make.top.equalTo(self.lineView.snp_bottom).offset(0*KFitHeightRate)
            make.left.equalTo(self.bgmView.snp_left).offset(15*KFitWidthRate)
            make.size.equalTo(CGSize(width: 0*KFitWidthRate, height: 0*KFitHeightRate))
            make.bottom.equalTo(self.bgmView.snp_bottom).offset(0*KFitHeightRate)
        }
        self.showBtn_image.snp_updateConstraints { (make) in
            make.centerY.equalTo(self.showBtn_text)
            make.right.equalTo(self.bgmView.snp_right).offset(-15*KFitWidthRate)
            make.size.equalTo(CGSize(width: 0, height: 0))
        }
    }
    private func updateLayoutShowMore() {
        self.lineView.snp_updateConstraints { (make) in
            make.top.equalTo(self.textLb.snp_bottom).offset(15*KFitHeightRate)
            make.left.equalTo(self.bgmView.snp_left).offset(0)
            make.right.equalTo(self.bgmView.snp_right).offset(0)
            make.height.equalTo(1)
        }
        self.showBtn_text.snp_updateConstraints { (make) in
            make.top.equalTo(self.lineView.snp_bottom).offset(12*KFitHeightRate)
            make.left.equalTo(self.bgmView.snp_left).offset(15*KFitWidthRate)
            make.size.equalTo(CGSize(width: 44*KFitWidthRate, height: 20*KFitHeightRate))
            make.bottom.equalTo(self.bgmView.snp_bottom).offset(-12*KFitHeightRate)
        }
        let showImage = UIImage(named: "pet_msg_hideDetail")!
        self.showBtn_image.snp_updateConstraints { (make) in
            make.centerY.equalTo(self.showBtn_text)
            make.right.equalTo(self.bgmView.snp_right).offset(-15*KFitWidthRate)
            make.size.equalTo(CGSize(width: showImage.size.width, height: showImage.size.height))
        }
    }
    private func getAddress() {
        guard AppDelegate.shareInstance.IsShowGoogleMap == true else {
            // 显示百度地图
            let reverseGeoCodeOpetion = BMKReverseGeoCodeSearchOption.init()
            reverseGeoCodeOpetion.location = CLLocationCoordinate2DMake(Double(self.msgCterLocationRcdModel.lat ?? "0")!, Double(self.msgCterLocationRcdModel.lng ?? "0")!)
            self.searcher.delegate = self
            let flag = self.searcher.reverseGeoCode(reverseGeoCodeOpetion)
            if flag == true {
                CBLog(message: "反geo检索发送成功")
            } else {
                CBLog(message: "反geo检索发送失败")
            }
            return
        }
    }
    // MARK: - BMKGeoCodeSearchDelegate
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeSearchResult!, errorCode error: BMKSearchErrorCode) {
        //self.timeLb.text = CBPetUtils.convertTimestampToDateStr(timestamp: self.msgCterLocationRcdModel.add_time ?? "", formateStr: "yyyy-MM-dd HH:mm:ss")
        if let valueTimeZone = CBPetHomeParamtersModel.getHomeParamters().timeZone {
            self.timeLb.text = CBPetUtils.convertTimestampToDateStr(timestamp: self.msgCterLocationRcdModel.add_time ?? "", formateStr: "yyyy-MM-dd HH:mm:ss",timeZone: Int(valueTimeZone) ?? 0)
        }
        self.titleLb.text = self.msgCterLocationRcdModel.title
        if error == BMK_SEARCH_NO_ERROR {
            if msgCterLocationRcdModel.title == "唤醒通知".localizedStr {
                self.textLb.text = "设备".localizedStr + (CBPetHomeInfoTool.getHomeInfo().pet.name ?? "") + "唤醒".localizedStr + "," + "位置在".localizedStr + "\(result.address ?? "")"
                updateTextLayout(textStr: "设备".localizedStr + (CBPetHomeInfoTool.getHomeInfo().pet.name ?? "") + "位置在".localizedStr + "\(result.address ?? "")")
            } else {
                self.textLb.text = "您的宠物".localizedStr + (CBPetHomeInfoTool.getHomeInfo().pet.name ?? "") + "位置在".localizedStr + "\(result.address ?? "")"
                updateTextLayout(textStr: "您的宠物".localizedStr + (CBPetHomeInfoTool.getHomeInfo().pet.name ?? "") + "位置在".localizedStr + "\(result.address ?? "")")
            }
            CBLog(message: "地理反编码:\(result.address ?? "")")
        } else {
            CBLog(message: "未找地理位置")
            if msgCterLocationRcdModel.title == "唤醒通知".localizedStr {
                self.textLb.text = "设备".localizedStr + (CBPetHomeInfoTool.getHomeInfo().pet.name ?? "") + "唤醒".localizedStr + "," +  "位置在".localizedStr + "\(result.address ?? "")"
                updateTextLayout(textStr: "设备".localizedStr + (CBPetHomeInfoTool.getHomeInfo().pet.name ?? "") + "位置在".localizedStr + "\(result.address ?? "")")
            } else {
                self.textLb.text = "您的宠物".localizedStr + " \"" + (CBPetHomeInfoTool.getHomeInfo().pet.name ?? "") + "\" " + "的位置未知".localizedStr
                updateTextLayout(textStr: "您的宠物".localizedStr + " \"" + (CBPetHomeInfoTool.getHomeInfo().pet.name ?? "") + "\" " + "的位置未知".localizedStr)
            }
        }
        self.showBtn_text.isSelected = self.msgCterLocationRcdModel.isShow
        self.showBtn_image.isSelected = self.msgCterLocationRcdModel.isShow
    }
}
