//
//  MBProgressHUD+Extension.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/3/19.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class MBProgressHUD_Extension: NSObject {

}

extension MBProgressHUD {
    /* 加载完成提示，只有标题*/
    class func showMessage(Msg msg:String,Deleay delay:TimeInterval) {
        if msg.count > 0 {
            self.showHUD(Msg: msg, Detail: "", Delay: delay)
        }
    }
    
    class func showHUD(Msg msg:String,Detail detail:String,Delay delay:TimeInterval) {
        let window = UIApplication.shared.delegate?.window
        let hud = MBProgressHUD.showAdded(to: window!!, animated: true)
        hud.mode = .text
        hud.bezelView.backgroundColor = UIColor.init().colorWithHexString(hexString: "#000000")
        hud.contentColor = UIColor.init().colorWithHexString(hexString: "#FFFFFF")
        hud.label.text = msg
        hud.label.font = UIFont.init(name: CBPingFangSC_Regular, size: 14)
        hud.label.numberOfLines = 0
        hud.detailsLabel.text = detail
        hud.detailsLabel.numberOfLines = 0
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: delay)
    }
    
    class func showHUD(Msg msg:String,Detail detail:String) {
        let window = UIApplication.shared.delegate?.window
        let hud = MBProgressHUD.showAdded(to: window!!, animated: true)
        hud.mode = .text
        hud.bezelView.backgroundColor = UIColor.init().colorWithHexString(hexString: "#000000")
        hud.contentColor = UIColor.init().colorWithHexString(hexString: "#FFFFFF")
        hud.label.text = msg
        hud.label.font = UIFont.init(name: CBPingFangSC_Regular, size: 14)
        hud.label.numberOfLines = 0
        hud.detailsLabel.text = detail
        hud.detailsLabel.numberOfLines = 0
        hud.removeFromSuperViewOnHide = true
    }
    
    class func showHUDIcon(View view:UIView,Animated animated:Bool) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView
        
        /* loading图片和动画*/
        let image = UIImage.init(named: "ic_wheel")
        let imageView = UIImageView.init(image: image)
        imageView.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0)
        
        let anima = CABasicAnimation.init(keyPath: "transform.rotation")
        anima.fromValue = 180*2;//M_PI*2
        anima.toValue = 0
        anima.duration = 5
        anima.repeatCount = 100
        imageView.layer.add(anima, forKey: nil)
        
        hud.customView = imageView
        /* 先设置hud.bezelView 的style 为MBProgressHUDBackgroundStyleSolidColor，
         然后再设置其背影色就可以了。因为他默认的style是MBProgressHUDBackgroundStyleBlur,
         即不管背影色设置成什么颜色，都会被加上半透明的效果，所以要先改其style*/
        hud.bezelView.style = .solidColor
        hud.bezelView.color = RGBA(r: 0, g: 0, b: 0, a: 0)
        
        let targetWidth:CGFloat
        let targetHeight:CGFloat
        let margin = 0
        targetWidth = imageView.frame.size.width + CGFloat(margin*2)
        targetHeight = imageView.frame.size.height + CGFloat(margin*2)
        let newSize = CGSize.init(width: targetWidth, height: targetHeight)
        hud.minSize = newSize
    }
}
