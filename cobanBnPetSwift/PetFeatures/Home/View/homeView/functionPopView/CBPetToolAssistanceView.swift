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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show() {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self)
            self.frame = window.bounds
        }
    }
    
    public func hide() {
        
    }
    
    private func setupUI() {
        self.backgroundColor = .red
        self.addSubview(contentView)
        contentView.snp_makeConstraints { make in
            make.centerX.centerY.equalTo(self)
            make.width.equalTo(200)
            make.height.equalTo(100)
        }
        
        contentView.addSubview(bgImgView)
        bgImgView.snp_makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        let img = UIImage.init(named: "pet_interaction_bg")
        bgImgView.image = img
    }
}
