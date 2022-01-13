//
//  CBPetChatPetfriendHdView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/30.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetChatPetfriendHdView: UITableViewHeaderFooterView {

    public lazy var viewModel:Any = {
        let viewMd = CBPetBaseViewModel.init()
        return viewMd
    }()
    private lazy var bgmView:UIView = {
        let vv = UIView.init()
        vv.backgroundColor = UIColor.white
        return vv
    }()
    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "申请添加您为宠友".localizedStr, textColor: KPet666666Color, font: UIFont(name: CBPingFang_SC, size: 12*KFitHeightRate)!)
        return lb
    }()
    private lazy var moreApplyBtn:CBPetBaseButton = {
        let btn = CBPetBaseButton(title: "更多申请".localizedStr, titleColor: KPetAppColor, font: UIFont(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!)
        return btn
    }()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        self.backgroundColor = UIColor.white
        self.addSubview(self.bgmView)
        self.bgmView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        self.bgmView.addSubview(self.titleLb)
        self.titleLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(12*KFitWidthRate)
        }
        
        self.bgmView.addSubview(self.moreApplyBtn)
        self.moreApplyBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(-20*KFitWidthRate)
        }
        self.moreApplyBtn.addTarget(self, action: #selector(moreApplyClick), for: .touchUpInside)
    }
    public func setupViewModel(viewModel:Any) {
        self.viewModel = viewModel
    }
    @objc private func moreApplyClick() {
        /* 是否是此类*/
        if self.viewModel is CBPetFuncChatViewModel {
            guard (self.viewModel as! CBPetFuncChatViewModel).clickPushFuncChatBlock == nil else {
                (self.viewModel as! CBPetFuncChatViewModel).clickPushFuncChatBlock!(CBPetFuncChatClickType.moreApply,"")
                return
            }
        }
    }
    var leftTitleValue:String = String() {
        didSet {
            titleLb.text = self.leftTitleValue
        }
    }
    var rightTitleValue:String = String() {
        didSet {
            moreApplyBtn.setTitle(self.rightTitleValue, for: .normal)
            moreApplyBtn.setTitle(self.rightTitleValue, for: .highlighted)
            if self.rightTitleValue == "我的宠友".localizedStr {
                moreApplyBtn.isEnabled = false
            } else {
                moreApplyBtn.isEnabled = true
            }
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
