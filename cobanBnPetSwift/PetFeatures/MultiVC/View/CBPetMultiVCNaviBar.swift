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
    
    let normalFont = CBFont(12)
    let selectedFont = CBFontM(14)
    
    var configData : [String] = [] {
        didSet {
            self.setContentWithConfig(configData: configData)
        }
    }
    
    private var _currentSelectedLbl : UILabel?
    private var currentSelectedLbl : UILabel? {
        set {
            guard newValue != nil else {
                return
            }
            if let lbl = _currentSelectedLbl, lbl !== newValue{
                lbl.font = normalFont
            }
            _currentSelectedLbl = newValue
            _currentSelectedLbl!.font = selectedFont
        }
        get {
            return _currentSelectedLbl
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
    
    public func didScrollTo(_ idx: Int) {
        guard idx <= (self.titlesContentView?.subviews.count)!-1 else {
            return
        }
        self.currentSelectedLbl = self.titlesContentView?.subviews[idx] as? UILabel
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
        
        let titlesContentWidth = SCREEN_WIDTH - (20+30)*2;
        titlesContentView?.snp_makeConstraints({ make in
            make.left.equalTo(backBtn!.snp_right)
            make.top.bottom.equalTo(contentView!)
            make.width.equalTo(titlesContentWidth)
        })
        
    }
    
    private func setContentWithConfig(configData: [String]) {
        var lastView : UIView?
        for title in configData {
            let view = UILabel.init(text: title)
            view.font = normalFont
            if (lastView == nil) {
                self.currentSelectedLbl = view;
            }
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
        let idx = self.titlesContentView?.subviews.index(of: lbl) ?? 0
        self.currentSelectedLbl = lbl
        if let vm = self.viewModel as? CBPetMultiViewModel,
           let clickBlk = vm.clickNaviTitleBLK {
            clickBlk(idx)
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
