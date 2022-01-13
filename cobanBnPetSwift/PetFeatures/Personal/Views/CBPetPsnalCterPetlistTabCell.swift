//
//  CBPetPsnalCterPetlistTabCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/3.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetPsnalCterPetlistTabCell: CBPetBaseTableViewCell,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    private lazy var petIconImgeView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "pet_psnal_myPetIcon")
        return imageView
    }()
    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "我的宠物".localizedStr, textColor: UIColor.init().colorWithHexString(hexString: "#000000"), font: UIFont(name: CBPingFang_SC_Bold, size: 16*KFitHeightRate)!,textAlignment: .left)
        return lb
    }()
    private lazy var collectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CBPetPeronalPageCollectsCell.self, forCellWithReuseIdentifier: "CBPetPeronalPageCollectsCell")
        return collectionView
    }()
    private lazy var arrayDataSource:[Any] = {
        let arr = [Any]()
        return arr
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        super.setupViewModel(viewModel: viewModel)
        self.viewModel = viewModel
        if self.viewModel is CBPetPsnalCterViewModel {
            let vvModel = self.viewModel as! CBPetPsnalCterViewModel
            vvModel.psnlUpdateDataBlock = { [weak self] (type:CBPetPsnalCterUpdType,objc:Any) -> Void in
                if type == .petList {
                    self?.arrayDataSource = objc as! [Any]// as! [Any]//.append(petList)
                    var addModel = CBPetPsnalCterPetModel.init()
                    addModel.title = "添加".localizedStr
                    addModel.icon = "pet_psnal_petDefaultAvatar"
                    self?.arrayDataSource.append(addModel)
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        self.bottomLineView.isHidden = false
        
        self.contentView.addSubview(self.petIconImgeView)
        self.contentView.addSubview(self.titleLb)
        
        let iconImage = UIImage.init(named: "pet_psnal_myPetIcon")!
        self.petIconImgeView.snp_makeConstraints { (make) in
            make.top.equalTo(20*KFitHeightRate)
            make.left.equalTo(30*KFitWidthRate)
            make.size.equalTo(CGSize(width: iconImage.size.width, height: iconImage.size.height))
        }
        self.titleLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.petIconImgeView)
            make.left.equalTo(self.petIconImgeView.snp_right).offset(8*KFitWidthRate)
            make.right.equalTo(-30*KFitWidthRate)
        }
        
        self.contentView.addSubview(self.collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.snp_makeConstraints { (make) in
            make.top.equalTo(self.petIconImgeView.snp_bottom).offset(0*KFitHeightRate)
            make.left.equalTo(20*KFitWidthRate)
            make.right.equalTo(-20*KFitWidthRate)
            make.height.equalTo(115*KFitHeightRate)
            make.bottom.equalTo(-1)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CBPetPeronalPageCollectsCell", for: indexPath) as! CBPetPeronalPageCollectsCell
        if self.arrayDataSource.count > indexPath.row {
            let petModel = self.arrayDataSource[indexPath.row]
            cell.psnalCterPetModel = petModel as! CBPetPsnalCterPetModel
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.viewModel is CBPetPsnalCterViewModel {
            guard (self.viewModel as! CBPetPsnalCterViewModel).psnlCterClickBlock == nil else {
                if self.arrayDataSource.count > indexPath.row {
                    let petModel = self.arrayDataSource[indexPath.row] as! CBPetPsnalCterPetModel
                    (self.viewModel as! CBPetPsnalCterViewModel).psnlCterClickBlock!(.editPet,petModel)
                }
                return
            }
        }
    }
    /* flowlayoutDelegate */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (SCREEN_WIDTH - 60*KFitWidthRate)/4, height: 115*KFitHeightRate)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
