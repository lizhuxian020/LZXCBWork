//
//  CBPetRecordingListCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/28.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetRecordingListCell: CBPetBaseTableViewCell {

    private lazy var nameLb:UILabel = {
        let lb = UILabel(text: "录音1".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFang_SC, size: 14*KFitHeightRate)!)
        return lb
    }()
    private lazy var playBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(imageName: "pet_func_record_play")
        btn.setImage(UIImage.init(named: "pet_func_record_pause"), for: .selected)
        return btn
    }()
    private lazy var selectedBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(imageName: "pet_func_record_selected")
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
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
    }
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        self.bottomLineView.isHidden = false
        self.addSubview(self.nameLb)
        self.nameLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(20*KFitWidthRate)
        }
        self.addSubview(self.playBtn)
        let playBtnImage = UIImage.init(named: "pet_func_record_play")!
        self.playBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self.nameLb.snp_right).offset(15*KFitWidthRate)
            make.size.equalTo(CGSize(width: playBtnImage.size.width, height: playBtnImage.size.height))
        }
        self.playBtn.addTarget(self, action: #selector(playGoHomeVoice), for: .touchUpInside)
        
        self.addSubview(self.selectedBtn)
        let checkImage = UIImage.init(named: "pet_func_record_selected")!
        self.selectedBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(-20*KFitWidthRate)
            make.size.equalTo(CGSize(width: checkImage.size.width, height: checkImage.size.height))
        }
    }
    var rcdModel:CBPetHomeRcdListModel = CBPetHomeRcdListModel() {
        didSet {
            self.nameLb.text = (rcdModel.file_name ?? "未知".localizedStr) + "_" + (rcdModel.voiceId ?? "0")
            
            NotificationCenter.default.removeObserver(self)
            
            NotificationCenter.default.addObserver(self, selector: #selector(begin), name: NSNotification.Name.init(String.init(format: "%@_begin",rcdModel.add_time ?? "")), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(stop), name: NSNotification.Name.init(String.init(format: "%@_stop",rcdModel.add_time ?? "")), object: nil)
            
            if self.viewModel is CBPetHomeViewModel {
                let vvModel = self.viewModel as! CBPetHomeViewModel
                if self.rcdModel.id == vvModel.paramtersObject?.fileRecord.id {
                    /* 为默认录音*/
                    self.selectedBtn.isHidden = false
                } else {
                    self.selectedBtn.isHidden = true
                }
            }
        }
    }
    @objc private func playGoHomeVoice() {
        if self.viewModel is CBPetHomeViewModel {
            let vvModel = self.viewModel as! CBPetHomeViewModel
            guard vvModel.petHomeGoHomeRecordBlock == nil else {
                vvModel.petHomeGoHomeRecordBlock!("play",self.rcdModel)
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

