//
//  CBPetMultiVC.swift
//  cobanBnPetSwift
//
//  Created by lee on 2022/1/15.
//  Copyright © 2022 coban. All rights reserved.
//

import Foundation
import UIKit

class CBPetMultiVC : CBPetBaseViewController,UIScrollViewDelegate {
    
    public lazy var multiVM : CBPetMultiViewModel = {
        return CBPetMultiViewModel.init()
    }()
    
    private lazy var barView : CBPetMultiVCNaviBar = {
        var barView = CBPetMultiVCNaviBar.init()
        self.view.addSubview(barView)
        return barView
    }()
    
    private lazy var scrollView : UIScrollView? = {
        let scrollView = UIScrollView.init()
        self.view.addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var contentView : UIView? = {
        let view = UIView.init()
        scrollView?.addSubview(view)
        return view
    }()
    
    var configData : [String : CBPetBaseViewController]?
    var titles : [String]?
    
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
        view.backgroundColor = .white
        
        barView.setupViewModel(viewModel: self.multiVM)
        barView.snp_makeConstraints { make in
            make.top.left.right.equalTo(0)
        }
        
        self.titles = self.configData!.keys.map({ string in
            return string
        })
        barView.configData = self.titles ?? []
        
        
        self.scrollView?.snp_makeConstraints({ make in
            make.top.equalTo(barView.snp_bottom)
            make.left.bottom.right.equalTo(0)
        })
        self.contentView?.snp_makeConstraints({ make in
            make.height.edges.equalTo(self.scrollView!)
        })
        
        self.setupContentView()
        
        self.scrollView?.panGestureRecognizer.require(toFail: (self.navigationController?.interactivePopGestureRecognizer)!)
    }
    
    private func setupContentView() {
        guard let configData = self.configData, let titles = self.titles else {
            return
        }
        var lastView : UIView?
        for i in 0..<titles.count {
            let vc = configData[titles[i]]
            let view = vc!.view!
            self.contentView?.addSubview(view)
            view.snp_makeConstraints { make in
                make.top.bottom.equalTo(self.contentView!)
                make.width.equalTo(self.scrollView!)
                if lastView == nil {
                    make.left.equalTo(self.contentView!)
                } else {
                    make.left.equalTo(lastView!.snp_right)
                }
                if i == titles.count-1 {
                    make.right.equalTo(self.contentView!)
                }
            }
            lastView = view
        }
    }
    
    private func setupViewModel() {
        self.multiVM.clickBackBtnBLK = {[weak self] () -> Void in
            self?.backBtnClick()
        }
        self.multiVM.clickNaviTitleBLK = {[weak self] (idx) -> Void in
            CBLog(message: idx)
            self?.scrollView?.setContentOffset(CGPoint.init(x: CGFloat(idx)*(self?.scrollView?.frame.width)!, y: 0), animated: true)
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let pageNum : Int = Int(round(offset / scrollView.frame.width))
        
        barView.didScrollTo(pageNum)
    }
}
