//
//  CBPetPsnalPetInfoTabCell.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/6/3.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetPsnalPetInfoTabCell: CBPetBaseTableViewCell,UIScrollViewDelegate {

    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "头像".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .left)
        return lb
    }()
    private lazy var textLb:UILabel = {
        let lb = UILabel(text: "133-2343-3432".localizedStr, textColor: KPet999999Color, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .right)
        lb.numberOfLines = 1
        return lb
    }()
    private lazy var avtarImgeView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 26*KFitHeightRate
        imageView.image = UIImage.init(named: "pet_psnal_petDefaultAvatar")
        return imageView
    }()
    private lazy var photoImgeView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private var scrollView:UIScrollView?
    private var lastImageView:UIImageView?
    private var originalFrame:CGRect?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
    }
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        self.bottomLineView.isHidden = false
        self.rigntArrowBtn.isHidden = false
    
        self.contentView.addSubview(self.titleLb)
        self.contentView.addSubview(self.textLb)
        self.contentView.addSubview(self.avtarImgeView)
        self.contentView.addSubview(self.photoImgeView)
        
        let imgRight = UIImage.init(named: "pet_psnal_rightArrow")
        self.rigntArrowBtn.snp_updateConstraints { (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.right.equalTo(-20*KFitWidthRate)
            make.size.equalTo(CGSize.init(width: (imgRight?.size.width)!, height: (imgRight?.size.height)!))
        }
        self.rigntArrowBtn.addTarget(self, action: #selector(toDetailClick), for: .touchUpInside)
        
        self.titleLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(20*KFitWidthRate)
            make.width.equalTo(30*KFitWidthRate)
        }
    
        self.textLb.snp_makeConstraints { (make) in
            make.top.equalTo(20*KFitHeightRate)
            make.right.equalTo(self.rigntArrowBtn.snp_left).offset(-12*KFitWidthRate)
            make.left.equalTo(self.titleLb.snp_right).offset(40*KFitWidthRate)
        }
        
        self.avtarImgeView.snp_makeConstraints { (make) in
            make.top.equalTo(15*KFitHeightRate)
            make.right.equalTo(self.rigntArrowBtn.snp_left).offset(-12*KFitWidthRate)
            make.size.equalTo(CGSize(width: 52*KFitHeightRate, height: 52*KFitHeightRate))
        }
        
        self.photoImgeView.snp_makeConstraints { (make) in
            make.top.equalTo(self.textLb.snp_bottom).offset(10*KFitHeightRate)
            make.right.equalTo(self.rigntArrowBtn.snp_left).offset(-12*KFitWidthRate)
            make.size.equalTo(CGSize(width: 80*KFitWidthRate, height: 60*KFitHeightRate))
            make.bottom.equalTo(-20*KFitHeightRate)
        }
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(showZoomImageView))
        self.photoImgeView.addGestureRecognizer(tapGesture)
    }
    ///MARK: - 缩放防疫记录图片
    @objc private func showZoomImageView(gestureRecognizer:UITapGestureRecognizer) {
        
        
        if gestureRecognizer.view is UIImageView {
            let gestureImageView = gestureRecognizer.view as! UIImageView
            if !(gestureImageView.image != nil) {
                return
            }
            let bgmView = UIScrollView.init()
            bgmView.frame = UIScreen.main.bounds
            bgmView.backgroundColor = UIColor.init().colorWithHexString(hexString: "#222222", alpha: 0.85)
   
            let tapBg = UITapGestureRecognizer.init(target: self, action: #selector(tapBgmView))
            bgmView.addGestureRecognizer(tapBg)
            
            let maxImageView = UIImageView.init()
            maxImageView.image = gestureImageView.image
            //maxImageView.frame = bgmView.convert(gestureImageView.frame, from: CBPetUtils.getCurrentVC().view)
            bgmView.addSubview(maxImageView)
            
            UIApplication.shared.keyWindow?.addSubview(bgmView)
            
            self.lastImageView = maxImageView
            self.originalFrame = maxImageView.frame
            self.scrollView = bgmView
            
            /* 最大放大比例*/
            self.scrollView?.maximumZoomScale = 1.5
            self.scrollView?.delegate = self
            
            //UIView.animate(withDuration: 0.5) {
                var frame = maxImageView.frame
                frame.size.width = bgmView.frame.size.width
                frame.size.height = frame.size.width*((maxImageView.image?.size.height)!/(maxImageView.image?.size.width)!)
                frame.origin.x = 0
                frame.origin.y = (bgmView.frame.size.height - frame.size.height)*0.5
                maxImageView.frame = frame
            //}
        }
        
        
    }
    @objc private func tapBgmView(tap:UITapGestureRecognizer) {
        self.scrollView?.contentOffset = CGPoint.zero
        //UIView.animate(withDuration: 0.5, animations: {
            self.lastImageView?.frame = self.originalFrame ?? CGRect.init()
            tap.view?.backgroundColor = UIColor.clear
        //}) { (finished:Bool) in
            tap.view?.removeFromSuperview()
            self.scrollView = nil
            self.lastImageView = nil
        //}
    }
    /* 返回可缩放的视图*/
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.lastImageView
    }
    var petInfoModel = CBPetPsnalCterPetPet() {
        didSet {
            self.titleLb.text = petInfoModel.title
            self.textLb.text = petInfoModel.text
            
            let titleWidth:CGFloat = petInfoModel.title?.getWidthText(text: petInfoModel.title!, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, height: 13*KFitHeightRate) ?? 0.0
            self.titleLb.snp_updateConstraints { (make) in
                make.centerY.equalTo(self)
                make.left.equalTo(20*KFitWidthRate)
                make.width.equalTo(titleWidth)
            }
            self.textLb.textAlignment = .right
            self.textLb.numberOfLines = 1
            
            if petInfoModel.title == "头像".localizedStr {
                self.textLb.text = ""
                self.avtarImgeView.snp_updateConstraints { (make) in
                    make.top.equalTo(15*KFitHeightRate)
                    make.right.equalTo(self.rigntArrowBtn.snp_left).offset(-12*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 52*KFitHeightRate, height: 52*KFitHeightRate))
                }
                //总的 15 + 52 + 15 已有 20 + lbelTexHeight(0) + 10
                self.photoImgeView.snp_updateConstraints { (make) in
                    make.top.equalTo(self.textLb.snp_bottom).offset(10*KFitHeightRate)
                    make.right.equalTo(self.rigntArrowBtn.snp_left).offset(-12*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 0*KFitWidthRate, height: 0*KFitHeightRate))
                    make.bottom.equalTo((20+10)*KFitHeightRate - (52+15+15)*KFitHeightRate)
                }
                self.avtarImgeView.sd_setImage(with: URL.init(string: petInfoModel.text ?? ""), placeholderImage: UIImage(named: "pet_psnal_petDefaultAvatar"), options: [])
            } else if petInfoModel.title == "防疫记录".localizedStr {
                self.textLb.numberOfLines = 0
                self.textLb.textAlignment = .left
                self.bottomLineView.isHidden = true
                self.avtarImgeView.snp_updateConstraints { (make) in
                    make.top.equalTo(15*KFitHeightRate)
                    make.right.equalTo(self.rigntArrowBtn.snp_left).offset(-12*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 0*KFitHeightRate, height: 0*KFitHeightRate))
                }
                self.photoImgeView.snp_updateConstraints { (make) in
                    make.top.equalTo(self.textLb.snp_bottom).offset(10*KFitHeightRate)
                    make.right.equalTo(self.rigntArrowBtn.snp_left).offset(-12*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 80*KFitWidthRate, height: 60*KFitHeightRate))
                    make.bottom.equalTo(-20*KFitHeightRate)
                }
                self.photoImgeView.sd_setImage(with: URL.init(string: petInfoModel.epidemicImage ?? ""), placeholderImage: UIImage(named: "pet_psnal_defaultAvatar"), options: [])
            } else {
                self.avtarImgeView.snp_updateConstraints { (make) in
                    make.top.equalTo(15*KFitHeightRate)
                    make.right.equalTo(self.rigntArrowBtn.snp_left).offset(-12*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 0*KFitHeightRate, height: 0*KFitHeightRate))
                }
                self.photoImgeView.snp_updateConstraints { (make) in
                    make.top.equalTo(self.textLb.snp_bottom).offset(10*KFitHeightRate)
                    make.right.equalTo(self.rigntArrowBtn.snp_left).offset(-12*KFitWidthRate)
                    make.size.equalTo(CGSize(width: 0*KFitWidthRate, height: 0*KFitHeightRate))
                    make.bottom.equalTo(-10*KFitHeightRate)
                }
                if petInfoModel.title == "性别".localizedStr {
                    switch petInfoModel.sex {
                        case "0":
                            self.textLb.text = "MM".localizedStr
                            break
                        case "1":
                            self.textLb.text = "GG".localizedStr
                            break
                        case "2":
                            self.textLb.text = "绝育 MM".localizedStr
                            break
                        case "3":
                            self.textLb.text = "绝育 GG".localizedStr
                            break
                        default:
                            break
                    }
                }
                
                //////
            }
        }
    }
    
    @objc private func toDetailClick() {
        if self.viewModel is CBPetPsnalCterViewModel {
            (self.viewModel as! CBPetPsnalCterViewModel).pushBlock!(self.petInfoModel as Any)
        }
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
class CBPetPsnalPetInfoDeviceTabCell: CBPetBaseTableViewCell {

    private lazy var titleLb:UILabel = {
        let lb = UILabel(text: "头像".localizedStr, textColor: KPetTextColor, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .left)
        return lb
    }()
    private lazy var textLb:UILabel = {
        let lb = UILabel(text: "133-2343-3432".localizedStr, textColor: KPet999999Color, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!,textAlignment: .right)
        lb.numberOfLines = 1
        return lb
    }()
    private lazy var bgmView:UIView = {
        let vv = UIView()
        vv.backgroundColor = UIColor.white
        return vv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupViewModel(viewModel: Any) {
        self.viewModel = viewModel
    }
    private func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = KPetBgmColor
        
        self.addSubview(self.bgmView)
        self.bgmView.addSubview(self.titleLb)
        self.bgmView.addSubview(self.textLb)
        
        self.bgmView.snp_makeConstraints { (make) in
            make.top.equalTo(10*KFitHeightRate)
            make.left.equalTo(0)
            make.bottom.equalTo(0*KFitHeightRate)
            make.height.equalTo(52*KFitHeightRate)
            make.width.equalTo(SCREEN_WIDTH)
        }
        self.titleLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.bgmView)
            make.left.equalTo(20*KFitWidthRate)
            make.width.equalTo(30)
        }
        self.textLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.bgmView)
            make.right.equalTo(-20*KFitWidthRate)
            make.left.equalTo(self.titleLb.snp_right).offset(40*KFitWidthRate)
        }
    }
    
    var petInfoModel = CBPetPsnalCterPetPet() {
        didSet {
            self.titleLb.text = petInfoModel.title
            self.textLb.text = petInfoModel.text
            self.textLb.textAlignment = .right
            let titleWidth:CGFloat = petInfoModel.title?.getWidthText(text: petInfoModel.title!, font: UIFont(name: CBPingFangSC_Regular, size: 14*KFitHeightRate)!, height: 13*KFitHeightRate) ?? 0.0
            self.titleLb.snp_updateConstraints { (make) in
                make.centerY.equalTo(self.bgmView)
                make.left.equalTo(20*KFitWidthRate)
                make.width.equalTo(titleWidth)
            }
        }
    }
    
    @objc private func toDetailClick() {
        if self.viewModel is CBPetPsnalCterViewModel {
            (self.viewModel as! CBPetPsnalCterViewModel).pushBlock!(self.petInfoModel as Any)
        }
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
