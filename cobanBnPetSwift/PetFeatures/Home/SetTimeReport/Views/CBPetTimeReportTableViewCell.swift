//
//  CBPetTimeReportTableViewCell.swift
//  cobanBnPetSwift
//
//  Created by hsl on 2021/12/12.
//  Copyright © 2021 coban. All rights reserved.
//

import UIKit

class CBPetTimeReportTableViewCell: CBPetBaseTableViewCell {

    private lazy var nameLb:UILabel = {
        let lb = UILabel(text: "唤醒时间1".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)!)
        self.addSubview(lb)
        return lb
    }()
    private lazy var timeLb:UILabel = {
        let lb = UILabel(text: "10:56".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFang_SC, size: 24*KFitHeightRate)!)
        self.addSubview(lb)
        return lb
    }()
    private lazy var arrowImage:UIImageView = {
        let imgV = UIImageView.init(image: UIImage(named: "arrow-右边"))
        self.addSubview(imgV)
        return imgV
    }()
//    private lazy var selectedBtn:CBPetBaseButton = {
//        let btn = CBPetBaseButton(imageName: "pet_func_record_selected")
//        btn.isHidden = true
//        return btn
//    }()
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
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
    
        nameLb.snp_makeConstraints { (make) in
            make.left.equalTo(20*KFitWidthRate)
            make.centerY.equalToSuperview()
        }

        timeLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(nameLb.snp.right).offset(15)
        }
        arrowImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-20*KFitWidthRate)
        }
    }
    var timeReportModel:CBPetTimingReportModel = CBPetTimingReportModel() {
        didSet {
            
            nameLb.text = "唤醒时间".localizedStr + "\(timeReportModel.index)"
            timeLb.text = String.init(format: "%02d", timeReportModel.timingHour) + ":" + String.init(format: "%02d", timeReportModel.timingMinute) 
        }
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
