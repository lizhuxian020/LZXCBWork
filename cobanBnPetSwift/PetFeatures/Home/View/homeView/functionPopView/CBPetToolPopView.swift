//
//  CBPetToolPopView.swift
//  cobanBnPetSwift
//
//  Created by Main on 2022/1/19.
//  Copyright © 2022 coban. All rights reserved.
//

import Foundation

let G_ToolPopView_TopHeight = KIs_iPhoneXStyle ? TabPaddingBARHEIGHT : 20*KFitHeightRate

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
    
    private var bottomFitView : UIView = UIView.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateContent() {
        var iconDataSource : [Dictionary<String,String>] = [
            ["img":"pet_func_interaction", "txt":"互动".localizedStr],
            ["img":"pet_function_locate", "txt":"定位".localizedStr],
            ["img":"pet_function_punishment", "txt":"惩罚".localizedStr],
        ]
        if let simCardType = CBPetHomeInfoTool.getHomeInfo().pet.device.simCardType,
           simCardType == "1" {
            iconDataSource.insert(["img":"pet_function_wakeup", "txt":"唤醒".localizedStr], at: 2)
        }
        
        //self.iconContainer.removeAllView
        self.iconViewContainer.subviews.forEach { view in
            view.removeFromSuperview()
        }
        //self.iconCOntainer.addIconViewWithData
        var lastView : UIView?
        for data in iconDataSource {
            let view = self.createIconView(data)
            self.iconViewContainer.addSubview(view)
            view.snp_makeConstraints { make in
                make.width.equalTo(self.iconViewContainer.snp_width).dividedBy(4)
                make.top.bottom.equalTo(0)
                if lastView == nil {
                    make.left.equalTo(0)
                } else {
                    make.left.equalTo(lastView!.snp_right)
                }
            }
            lastView = view
        }
        
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
            make.centerX.equalTo(self.topTapView)
            make.top.equalTo(10*KFitHeightRate)
        }
        lineView.backgroundColor = KPetC8C8C8Color
        lineView.layer.cornerRadius = 2*KFitHeightRate
        
        self.addSubview(iconViewContainer)
        iconViewContainer.snp_makeConstraints { make in
            make.top.equalTo(self.topTapView.snp_bottom)
            make.left.right.equalTo(0)
        }
        iconViewContainer.backgroundColor = .red
        
        self.addSubview(bottomFitView)
        bottomFitView.snp_makeConstraints { make in
            make.top.equalTo(iconViewContainer.snp_bottom)
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(TabPaddingBARHEIGHT)
        }
    }
    
    private func createIconView(_ data: [String: String]) -> UIView {
        let view = UIView.init()
        let imgView = UIImageView.init()
        let lblView = UILabel(text: "", textColor: KPet333333Color, font: UIFont.init(name: CBPingFangSC_Regular, size: 12*KFitHeightRate)!, textAlignment: .center)
        let imgName = data["img"] ?? ""
        let txt = data["txt"] ?? ""
        
        imgView.image = UIImage.init(named: imgName)
        lblView.text = txt
        
        view.addSubview(imgView)
        imgView.snp_makeConstraints { make in
            make.top.equalTo(10*KFitHeightRate)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 40*KFitHeightRate, height: 40*KFitHeightRate))
        }
        view.addSubview(lblView)
        lblView.snp_makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(imgView.snp_bottom).offset(5)
            make.bottom.equalTo(-10*KFitHeightRate)
        }
        
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickIcon(sender:)))
//        view.addGestureRecognizer(tap)
        view.tapBlk = { [weak self] ()->Void in
            CBLog(message: data)
            guard self != nil,
                  let funcBLk = (self?.viewModel as? CBPetHomeViewModel)?.functionViewBlock else {
                return
            }
            funcBLk(false, data["txt"]!)
        }
        return view
    }
    
//    @objc private func clickIcon(sender: UITapGestureRecognizer) {
//        let view = sender.view
//        
//    }
    
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
