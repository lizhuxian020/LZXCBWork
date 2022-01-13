//
//  CBPetPersonalPageTabvCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/2.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetPersonalPageTabvCell: CBPetBaseTableViewCell {

    private lazy var leftLb:UILabel = {
        let lb = UILabel(text: "电话".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .left)
        return lb
    }()
    private lazy var rightLb:UILabel = {
        let lb = UILabel(text: "133-2343-3432".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!,textAlignment: .right)
        lb.numberOfLines = 1
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        self.bottomLineView.isHidden = false
    
        self.addSubview(self.leftLb)
        self.addSubview(self.rightLb)
        
        self.leftLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(20*KFitWidthRate)
            make.width.equalTo(20)
            make.right.equalTo(self.rightLb.snp_left).offset(-15*KFitWidthRate)
        }
        
        self.rightLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(-20*KFitWidthRate)
            make.left.equalTo(self.leftLb.snp_right).offset(15*KFitWidthRate)
        }
    }
    var psnalUserInfoModel:CBPetUserInfoModel = CBPetUserInfoModel() {
        didSet {
            leftLb.text = psnalUserInfoModel.title
            rightLb.text = psnalUserInfoModel.text
            let title_width = psnalUserInfoModel.title?.getWidthText(text: psnalUserInfoModel.title ?? "", font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, height: 20)
            self.leftLb.snp_updateConstraints { (make) in
                make.centerY.equalTo(self)
                make.left.equalTo(20*KFitWidthRate)
                make.width.equalTo(title_width ?? 0)
                make.right.equalTo(self.rightLb.snp_left).offset(-15*KFitWidthRate)
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
