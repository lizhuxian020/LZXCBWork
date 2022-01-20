//
//  CBPetToolAssistanceView.swift
//  cobanBnPetSwift
//
//  Created by lee on 2022/1/20.
//  Copyright © 2022 coban. All rights reserved.
//

import Foundation


class CBPetToolAssistanceView : CBPetBaseView {
    
    private var contentView: UIView = UIView.init()
    private var bgImgView : UIImageView = UIImageView.init()
    private var iconViewContainer : UIView = UIView.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(frame: CGRect) {
        
        guard let window = UIApplication.shared.keyWindow else {
            return;
        }
        
        window.addSubview(self)
        self.frame = window.bounds
        
        self.contentView.snp_remakeConstraints { make in
            make.left.equalTo(5*KFitWidthRate)
            make.bottom.equalTo(frame.origin.y-SCREEN_HEIGHT+15*KFitHeightRate)
        }
    }
    
    public func hide() {
        self.removeFromSuperview()
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        self.addSubview(contentView)
        
        contentView.addSubview(bgImgView)
        contentView.addSubview(iconViewContainer)
        
        bgImgView.snp_makeConstraints { make in
            make.edges.equalTo(iconViewContainer)
        }
        
        iconViewContainer.snp_makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        let img = UIImage.init(named: "pet_interaction_bg") ?? UIImage.init()
        let imgW = img.size.width
        let imgH = img.size.height
        bgImgView.image = img.resizableImage(withCapInsets: UIEdgeInsets.init(top: imgH*0.25, left: imgW*0.3, bottom: imgH*0.35, right: imgW*0.15), resizingMode: .stretch)
        
        self.tapBlk = {[weak self] ()->Void in
            self?.hide()
        }
    }
    
    public func updateContent() {
        
        iconViewContainer.subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        var iconDataSource : [Dictionary<String,String>] = [
            ["img":"pet_function_listen", "txt":"听听".localizedStr],
            ["img":"pet_function_shout", "txt":"喊话".localizedStr],
        ]
        if let value = CBPetHomeInfoTool.getHomeInfo().devUser.isAdmin,
           value.valueStr == "1" {
            /* 管理员*/
            iconDataSource.append(["img":"pet_function_chat", "txt":"微聊".localizedStr])
        }
        
        var lastView : UIView?
        for i in 0..<iconDataSource.count {
            let view = self.createIconView(iconDataSource[i])
            self.iconViewContainer.addSubview(view)
            view.snp_makeConstraints { make in
                make.top.equalTo(10*KFitHeightRate)
                make.bottom.equalTo(-10*KFitHeightRate)
                if lastView == nil {
                    make.left.equalTo(20*KFitWidthRate)
                } else {
                    make.left.equalTo(lastView!.snp_right).offset(15*KFitWidthRate)
                    make.width.equalTo(lastView!)
                }
                if i == iconDataSource.count-1 {
                    make.right.equalTo(-20*KFitWidthRate)
                }
            }
            lastView = view
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
            make.left.greaterThanOrEqualTo(0)
            make.right.lessThanOrEqualTo(0)
            make.size.equalTo(CGSize(width: 40*KFitHeightRate, height: 40*KFitHeightRate))
        }
        view.addSubview(lblView)
        lblView.snp_makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(imgView.snp_bottom).offset(5)
            make.bottom.equalTo(-10*KFitHeightRate)
            make.left.greaterThanOrEqualTo(0)
            make.right.lessThanOrEqualTo(0)
        }
        
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
        
        
    
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
    }
}
