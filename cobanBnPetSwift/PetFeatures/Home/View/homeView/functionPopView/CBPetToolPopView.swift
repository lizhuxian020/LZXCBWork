//
//  CBPetToolPopView.swift
//  cobanBnPetSwift
//
//  Created by Main on 2022/1/19.
//  Copyright © 2022 coban. All rights reserved.
//

import Foundation

let G_ToolPopView_TopHeight = 20*KFitHeightRate

class CBPetToolPopView : CBPetBaseView {
    
    private var isShow : Bool = true
    
    private var topTapView : UIView = {
        let view = UIView.init()
        return view
    }()
    
    private var iconViewContainer : UIView = {
        let view = UIView.init()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateContent() {
        var iconDataSource : [Dictionary<String,String>] = [
            ["img":"", "txt":"互动".localizedStr],
            ["img":"", "txt":"定位".localizedStr],
            ["img":"", "txt":"惩罚".localizedStr],
        ]
        if let simCardType = CBPetHomeInfoTool.getHomeInfo().pet.device.simCardType,
           simCardType == "1" {
            iconDataSource.insert(["img":"", "txt":"唤醒".localizedStr], at: 2)
        }
        
        //self.iconContainer.removeAllView
        //self.iconCOntainer.addIconViewWithData
        
//        if let value = CBPetHomeInfoTool.getHomeInfo().devUser.isAdmin {
//            if value.valueStr == "1" {
//                /* 管理员*/
//            } else {
//                /* 0或无为非管理员 */
//            }
//        }
    }
    
    private func setupUI() {
        self.layer.cornerRadius = G_ToolPopView_TopHeight
        self.backgroundColor = .white
        
        self.addSubview(topTapView)
        topTapView.snp_makeConstraints { make in
            make.top.left.right.equalTo(0)
            make.height.equalTo(G_ToolPopView_TopHeight)
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickTopTap))
        topTapView.addGestureRecognizer(tap)
        
        let lineView = UIView.init()
        topTapView.addSubview(lineView)
        lineView.snp_makeConstraints { make in
            make.size.equalTo(CGSize(width: 36*KFitWidthRate, height: 3*KFitHeightRate))
            make.centerY.centerX.equalTo(self.topTapView)
        }
        lineView.backgroundColor = KPetC8C8C8Color
        lineView.layer.cornerRadius = 2*KFitHeightRate
        
        self.addSubview(iconViewContainer)
        iconViewContainer.snp_makeConstraints { make in
            make.top.equalTo(self.topTapView.snp_bottom)
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(200)
        }
        iconViewContainer.backgroundColor = .red
    }
    
    @objc private func clickTopTap() {
        if let vm = self.viewModel as? CBPetHomeViewModel,
           let blk = vm.functionViewBlock {
            blk(isShow, "")
            isShow = !isShow
        }
        
    }
    
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
    }
}
