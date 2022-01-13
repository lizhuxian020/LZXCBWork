//
//  CBPetCtrlPanelPopCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/6.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetCtrlPanelPopCell: CBPetBaseTableViewCell {

    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .left)
        return lb
    }()
    private lazy var textLb:UILabel = {
        let lb = UILabel(text: "".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .right)
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        super.setupViewModel(viewModel: viewModel)
        self.viewModel = viewModel
    }
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        self.bottomLineView.isHidden = false
        self.rigntArrowBtn.isHidden = false
        
        self.addSubview(self.titleLb)
        self.addSubview(self.textLb)
        
        self.bottomLineView.snp_remakeConstraints { (make) in
            make.left.equalTo(25*KFitWidthRate)
            make.right.equalTo(-25*KFitWidthRate)
            make.bottom.equalTo(0)
            make.height.equalTo(1*KFitHeightRate)
        }
        
        self.titleLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(25*KFitWidthRate)
            make.top.equalTo(20*KFitHeightRate)
            make.bottom.equalTo(-20*KFitHeightRate)
        }
        let imgRight = UIImage.init(named: "pet_psnal_rightArrow")
        self.rigntArrowBtn.snp_remakeConstraints { (make) in
            make.centerY.equalTo(self.titleLb)
            make.right.equalTo(-25*KFitWidthRate)
            make.size.equalTo(CGSize.init(width: (imgRight?.size.width)!, height: (imgRight?.size.height)!))
        }
        self.rigntArrowBtn.addTarget(self, action: #selector(rightArrowClick), for: .touchUpInside)
        self.textLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.titleLb)
            make.right.equalTo(self.rigntArrowBtn.snp_left).offset(-10*KFitWidthRate)
        }
        
    }
    var ctrlPanelModel:CBPetCtrlPanelModel = CBPetCtrlPanelModel() {
        didSet {
            self.titleLb.text = self.ctrlPanelModel.title
            self.textLb.text = self.ctrlPanelModel.text
//            if self.ctrlPanelModel.title == "设置时区".localizedStr {
//                self.bottomLineView.isHidden = true
//            } else {
//                self.bottomLineView.isHidden = false
//            }
            switch ctrlPanelModel.title {
            case "设置回家语音".localizedStr:
                self.textLb.text = (self.ctrlPanelModel.fileRecord.file_name ?? "未知".localizedStr) + "_" + (self.ctrlPanelModel.fileRecord.voiceId ?? "0")
                break
            case "设置时区".localizedStr:
                self.textLb.text = self.ctrlPanelModel.timeZone
                break
            default:
                break
            }
        }
    }
    @objc private func noticeSwitchClick() {
        
    }
    @objc private func rightArrowClick() {
        if self.viewModel is CBPetHomeViewModel {
            let homeViewModel = self.viewModel as! CBPetHomeViewModel
            guard homeViewModel.ctrlPanelClickBlock == nil else {
                homeViewModel.ctrlPanelClickBlock!(self.ctrlPanelModel.title as Any,false,false)
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
