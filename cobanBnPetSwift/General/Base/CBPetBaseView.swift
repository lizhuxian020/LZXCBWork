//
//  CBPetBaseView.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/5/21.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetBaseView: UIView {
    
    public lazy var viewModel:Any = {
        let viewMd = CBPetBaseViewModel.init()
        return viewMd
    }()
    var noDataResult:Bool?
    public lazy var noDataView:CBPetNoDataView = {
        let noDataView = CBPetNoDataView()
        self.addSubview(noDataView)
        noDataView.isHidden = true
        noDataView.snp_makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        })
        return noDataView
    }()
    public lazy var noDataObjcView:CBPetNoDataView = {
        let noDataView = CBPetNoDataView()
        noDataView.isHidden = true
        return noDataView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(noNoDataNotification), name: NSNotification.Name.init(K_CBPetNoDataNotification), object: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    public func setupViewModel(viewModel:Any) {
        self.viewModel = viewModel
    }
    /* 无数据占位*/
    @objc public func noNoDataNotification(notifi:Notification) {
        let resultDic:[String:Any] = notifi.object as! [String : Any]
        noDataResult = (resultDic["isShow"] as! Bool)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
