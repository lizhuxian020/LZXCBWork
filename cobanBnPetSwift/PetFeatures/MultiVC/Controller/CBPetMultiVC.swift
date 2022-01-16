//
//  CBPetMultiVC.swift
//  cobanBnPetSwift
//
//  Created by lee on 2022/1/15.
//  Copyright © 2022 coban. All rights reserved.
//

import Foundation

class CBPetMultiVC : CBPetBaseViewController {
    
    public lazy var multiVM : CBPetMultiViewModel = {
        return CBPetMultiViewModel.init()
    }()
    
    private lazy var barView : CBPetMultiVCNaviBar = {
        var barView = CBPetMultiVCNaviBar.init()
        self.view.addSubview(barView)
        return barView
    }()
    
    var configData : [String : CBPetBaseViewController]?
    
    init(configData : [String : CBPetBaseViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.configData = configData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupView() {
        self.setupViewModel()
        view.backgroundColor = .red
        
        barView.setupViewModel(viewModel: self.multiVM)
        barView.snp_makeConstraints { make in
            make.top.left.right.equalTo(0)
        }
        barView.configData = self.configData!.keys.map({ String in
            return String
        })
    }
    
    private func setupViewModel() {
        self.multiVM.clickBackBtnBLK = {[weak self] () -> Void in
            self?.backBtnClick()
        }
        self.multiVM.clickNaviTitleBLK = {[weak self] (title) -> Void in
            CBLog(message: "controller clickTitle : \(self?.configData![title])")
            
        }
    }
}
