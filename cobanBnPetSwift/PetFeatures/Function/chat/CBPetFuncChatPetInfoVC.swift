//
//  CBPetFuncChatPetInfoVC.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/2.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetFuncChatPetInfoVC: CBPetBaseViewController {

    private lazy var petInfoView:CBPetFuncChatPetInfoView = {
        let vv = CBPetFuncChatPetInfoView.init()
        return vv
    }()
    public lazy var psnalCterViewModel:CBPetPsnalCterViewModel = {
        let viewModel = CBPetPsnalCterViewModel()
        return viewModel
    }()
    private lazy var funcViewModel:CBPetFuncChatViewModel = {
        let vv = CBPetFuncChatViewModel.init()
        return vv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupView()
    }
    private func setupView() {
        initBarWith(title: "宠物资料".localizedStr, isBack: true)
        self.petInfoView.backgroundColor = UIColor.white
        self.view.addSubview(self.petInfoView)
        self.petInfoView.snp_makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        self.petInfoView.updatePetsInfoData(petInfoModel: self.psnalCterViewModel.petInfoModel?.pet ?? CBPetPsnalCterPetPet())
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
