//
//  CBAppSettingTableViewCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/4/7.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBAppSettingTableViewCell: CBPetBaseTableViewCell {

    private lazy var titleLab:UILabel = {
        let lb = UILabel(text: "")
        lb.textColor = kCellTextColor
        return lb
    }()
    private lazy var rightText:UILabel = {
        let lb = UILabel(text: "")
        return lb
    }()
    private lazy var noticeStatusLb:UILabel = {
        let lb = UILabel(text: "")
        return lb
    }()
    private lazy var noticeSiwtch:UISwitch = {
        let noticSwi = UISwitch.init()
        noticSwi.isOn = true
        noticSwi.isHidden = true
        return noticSwi
    }()
//    var appSettingModel:CBAppSettingModel = CBAppSettingModel() {
//        didSet {
//            self.titleLab.text = appSettingModel.leftTitle
//            self.rightText.text = appSettingModel.rightText
//            switch self.appSettingModel.leftTitle {
//            case "消息通知".localizedStr:
//                self.noticeSiwtch.isHidden = false
//                self.rigntArrowImgView.isHidden = true
//                self.bottomLineView.isHidden = false
//                break
//            case "修改密码".localizedStr:
//                self.noticeSiwtch.isHidden = true
//                self.rigntArrowImgView.isHidden = false
//                self.bottomLineView.isHidden = false
//                break
//            case "清除缓存".localizedStr:
//                self.noticeSiwtch.isHidden = true
//                self.rigntArrowImgView.isHidden = false
//                self.bottomLineView.isHidden = false
//                break
//            case "关于我们".localizedStr:
//                self.noticeSiwtch.isHidden = true
//                self.rigntArrowImgView.isHidden = false
//                self.bottomLineView.isHidden = true
//                break
//            default:
//                break
//            }
//        }
//    }
    class func cellCopyTableView(tableView:UITableView) -> CBAppSettingTableViewCell {
        let cellID = "CBAppSettingTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = CBAppSettingTableViewCell.init(style: .default, reuseIdentifier: cellID)
        }
        return cell as! CBAppSettingTableViewCell
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    private func setupView() {
        self.selectionStyle = .none
        self.addSubview(titleLab)
        self.titleLab.snp_makeConstraints { (make) in
            make.left.equalTo(15*KFitWidthRate)
            make.centerY.equalTo(self.snp_centerY)
        }
        self.contentView.addSubview(rightText)
        self.rightText.snp_makeConstraints { (make) in
            make.right.equalTo(self.rigntArrowImgView.snp_left).offset(-15*KFitWidthRate)
            make.centerY.equalTo(self.snp_centerY)
        }
        self.contentView.addSubview(noticeSiwtch)
        self.noticeSiwtch.addTarget(self, action: #selector(noticeSwitchClick), for: .valueChanged)
        self.noticeSiwtch.snp_makeConstraints { (make) in
            // UISwitch (开关大小无法设置）
            make.centerY.equalTo(self.snp_centerY)
            make.right.equalTo(-15*KFitWidthRate)
        }
        self.contentView.addSubview(noticeStatusLb)
        self.noticeStatusLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.right.equalTo(self.noticeSiwtch.snp_left).offset(-10*KFitWidthRate)
            make.height.equalTo(30)
        }
    }
    @objc func noticeSwitchClick() {
        
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
