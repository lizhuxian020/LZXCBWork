//
//  CBPetMultiVCNaviBar.swift
//  cobanBnPetSwift
//
//  Created by lee on 2022/1/16.
//  Copyright © 2022 coban. All rights reserved.
//

import Foundation

class CBPetMultiVCNaviBar : CBPetBaseView {
    
//    var _configData : [String]?
    
    var configData : [String] = [] {
        didSet {
            self.setContentWithConfig(configData: configData)
        }
    }
    
    lazy private var statusView: UIView? = {
        let view = UIView.init()
        self.addSubview(view)
        return view
    }()
    
    lazy private var contentView: UIView? = {
        let view = UIView.init()
        self.addSubview(view)
        return view
    }()
    
    lazy private var titlesContentView: UIView? = {
        let view = UIView.init()
        self.contentView!.addSubview(view)
        return view
    }()
    
    
    lazy private var backBtn: UIButton? = {
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "pet_leftArrow_black"), for: .normal)
        self.contentView!.addSubview(btn)
        btn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        return btn
    }()
    
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel;
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.white
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        statusView?.snp_makeConstraints({ make in
            make.height.equalTo(statusBarHeight)
            make.top.left.right.equalTo(0)
        })
        let contentHeight = 44
        contentView?.snp_makeConstraints({ make in
            make.height.equalTo(contentHeight)
            make.top.equalTo(statusView!.snp_bottom)
            make.left.right.bottom.equalTo(0)
        })
        
        backBtn?.snp_makeConstraints({ make in
            make.centerY.equalTo(contentView!)
            make.left.equalTo(20)
            make.width.height.equalTo(30);
        })
        
//        backBtn?.layoutIfNeeded()
        let titlesContentWidth = SCREEN_WIDTH - (20+30)*2;
        titlesContentView?.snp_makeConstraints({ make in
            make.left.equalTo(backBtn!.snp_right)
            make.top.bottom.equalTo(contentView!)
            make.width.equalTo(titlesContentWidth)
        })
        
        CBLog(message: backBtn)
        
    }
    
    private func setContentWithConfig(configData: [String]) {
        var lastView : UIView?
        for title in configData {
            let view = UILabel.init(text: title)
            view.textAlignment = .center
            titlesContentView?.addSubview(view)
            view.snp_makeConstraints { make in
                make.top.bottom.equalTo(titlesContentView!)
                if lastView == nil {
                    make.left.equalTo(titlesContentView!)
                } else {
                    make.left.equalTo(lastView!.snp_right)
                }
                make.width.equalTo(titlesContentView!.snp_width).dividedBy(configData.count)
            }
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapTitle(sender:)))
            view.addGestureRecognizer(tap)
            view.isUserInteractionEnabled = true
            lastView = view
        }
    }
    
    @objc private func tapTitle(sender:UIGestureRecognizer) {
        let lbl = sender.view as! UILabel;
        if let vm = self.viewModel as? CBPetMultiViewModel,
           let clickBlk = vm.clickNaviTitleBLK {
            clickBlk(lbl.text ?? "")
        }
    }
    
    @objc private func clickBackBtn(_ sender: UIButton) {
        guard self.viewModel is CBPetMultiViewModel else {
            return;
        }
        let viewModel = self.viewModel as! CBPetMultiViewModel
        guard viewModel.clickBackBtnBLK != nil else {
            return
        }
        viewModel.clickBackBtnBLK!();
    }
    
    deinit {
        CBLog(message: "\(self) dealloc")
    }
}
