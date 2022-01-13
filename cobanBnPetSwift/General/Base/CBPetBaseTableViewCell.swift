//
//  CBPetBaseTableViewCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/4/7.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetBaseTableViewCell: UITableViewCell {

    public lazy var viewModel:Any = {
        let viewMd = CBPetBaseViewModel.init()
        return viewMd
    }()
    lazy var topLineView:UIView = {
        let line = UIView.init()
        line.backgroundColor = KPetLineColor
        line.isHidden = true
        return line
    }()
    lazy var bottomLineView:UIView = {
        let line = UIView.init()
        line.backgroundColor = KPetLineColor
        line.isHidden = true
        return line
    }()
    lazy var rigntArrowImgView:UIImageView = {
        let arrow = UIImageView.init()
        arrow.isHidden = true
        return arrow
    }()
    lazy var rigntArrowBtn:CBPetBaseButton = {
        let arrow = CBPetBaseButton(imageName: "pet_psnal_rightArrow")
        arrow.isHidden = true
        arrow.isUserInteractionEnabled = false
        return arrow
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.addSubview(self.topLineView)
        self.topLineView.snp_makeConstraints { (make) in
            make.left.equalTo(15*KFitWidthRate)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(1)
        }
        self.addSubview(self.bottomLineView)
        self.bottomLineView.snp_makeConstraints { (make) in
            make.left.equalTo(15*KFitWidthRate)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(1)
        }
        self.addSubview(self.rigntArrowImgView)
        let imgRight = UIImage.init(named: "pet_psnal_rightArrow")
        self.rigntArrowImgView.image = imgRight
        self.rigntArrowImgView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.right.equalTo(-30*KFitWidthRate)
            make.size.equalTo(CGSize.init(width: (imgRight?.size.width)!, height: (imgRight?.size.height)!))
        }
        
        self.addSubview(self.rigntArrowBtn)
        self.rigntArrowBtn.setImage(imgRight, for: .normal)
        self.rigntArrowBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.right.equalTo(-30*KFitWidthRate)
            make.size.equalTo(CGSize.init(width: (imgRight?.size.width)!, height: (imgRight?.size.height)!))
        }
    }
    public func setupViewModel(viewModel:Any) {
        self.viewModel = viewModel
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
