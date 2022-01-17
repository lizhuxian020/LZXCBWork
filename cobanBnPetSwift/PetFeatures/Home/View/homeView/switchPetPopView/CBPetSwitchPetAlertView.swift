//
//  CBPetSwitchPetAlertView.swift
//  cobanBnPetSwift
//
//  Created by lee on 2022/1/18.
//  Copyright © 2022 coban. All rights reserved.
//

import Foundation

class CBPetSwitchPetAlertView : CBPetBaseView {
    
    private var bgView : UIView = UIView.init()
    private var contentView : UIView = UIView.init()
    
    public func showContent() {
        self.isHidden = false
        self.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        } completion: { _ in
            
        }

    }
    
    public func dismiss() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
        } completion: { _ in
            self.isHidden = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.backgroundColor = .red
        
        self.addSubview(bgView)
        bgView.frame = self.bounds
        bgView.backgroundColor = .white
        
        contentView.backgroundColor = .green
        self.addSubview(contentView)
        contentView.frame = CGRect.init(x: 0, y: NavigationBarHeigt, width: 100, height: 300)
        
        self.isHidden = true
        self.alpha = 0;
    }
}
