//
//  CBPetUtilsMacro.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/3/5.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
//import Foundation

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let KIs_iPhoneXStyle:Bool = UIApplication.shared.statusBarFrame.height >= 44.0 ? true:false
//@available(iOS 11.0, *)
//let KIs_iPhoneXStyle2 = (UIApplication.shared.delegate?.window??.safeAreaInsets.bottom)! > 0 ? true:false


let NavigationBarHeigt:CGFloat = UIApplication.shared.statusBarFrame.size.height + 44.0//KIs_iPhoneXStyle ? 88.0 : 64.0
let NavPaddingBARHEIGHT:CGFloat = UIApplication.shared.statusBarFrame.size.height - 44.0//KIs_iPhoneXStyle ? 24.0 : 0.0
let kNavAndStatusHeight:CGFloat = UIApplication.shared.statusBarFrame.size.height + CGFloat(NavigationBarHeigt)
let TabBARHEIGHT:CGFloat = KIs_iPhoneXStyle ? 83.0 : 49.0
let TabPaddingBARHEIGHT:CGFloat = KIs_iPhoneXStyle ? 34.0 : 0.0

let fontRate = (SCREEN_WIDTH/414.0)
let frameSizeRate = (SCREEN_WIDTH/414.0)

// plus (414,736)为基准，大屏机型不变，小屏机型缩小。6s (375,667)
// 1、6s(375,667)为基准，大于6s屏以plus(414,736)为基准，
// 2、小于6s屏则比例缩小，
// 3、大于6s屏幕且小于puls屏则比例介于6s和plus之间，相对plus屏比例缩小，相对6s屏比例增大
// 4、大于plus屏比例增大,
let KFitWidthRate = (SCREEN_WIDTH/((SCREEN_WIDTH > 375) ? 414 : 375))
let KFitHeightRate = (SCREEN_HEIGHT/((SCREEN_HEIGHT > 667) ? 736 : 667))

/* 控制面板x与屏幕间隔*/
let ctrlPanelSpace = 107*KFitWidthRate/2

/******************* 常用设计字体  *********************/
let CBPingFang_SC:String = "PingFang SC"

let CBPingFangSC_Regular:String = "PingFangSC-Regular"

let CBPingFang_SC_Bold:String = "PingFangSC-Semibold"//"PingFang SC Bold"//"PingFang SC Bold"//Avenir Next

let CBPingFang_SC_SemiBold:String = "PingFangSC-Semibold"//Avenir Next

let CBAvenir_Next:String = "AvenirNextCondensed-DemiBold"//AvenirNext-Medium

let CBAvenirNext_Medium:String = "AvenirNext-Medium"

let CBAvenirNext_DemiBoldItalic:String = "AvenirNext-DemiBoldItalic"

let CBAvenirNext_MediumItalic:String = "AvenirNext-MediumItalic"

let CBAvenirNext_DemiBold:String = "AvenirNext-DemiBold"

let CBAvenirNext_Bold:String = "AvenirNext-Bold"

// 背景颜色
let KPetAppColor:UIColor = UIColor.init().colorWithHexString(hexString: "#2DDFAF")
// 导航栏颜色
let KPetNavigationBarColor:UIColor = UIColor.init().colorWithHexString(hexString: "#2E2F41")
// 背景颜色
let KPetBgmColor:UIColor = UIColor.init().colorWithHexString(hexString: "#F5F5F5")//UIColor.init(red: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: 1.0)
// cell 文本颜色
let kCellTextColor:UIColor = UIColor.init(red: 73/255.0, green: 73/255.0, blue: 73/255.0, alpha: 1.0)
// 输入框内容颜色
let kTextFieldColor:UIColor = UIColor.init(red: 210/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1.0)
// 线颜色
let kLineColor:UIColor = UIColor.init(red: 210/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1.0)
// 登录注册忘记密码的颜色
let kLoginPartColor:UIColor = UIColor.init(red: 179/255.0, green: 167/255.0, blue: 199/255.0, alpha: 1.0)
// 蓝色
let kBlueColor:UIColor = UIColor.init(red: 15/255.0, green: 126/255.0, blue: 255/255.0, alpha: 1.0)
// 黑色
let kBlackColor:UIColor = UIColor.init(red: 73/255.0, green: 73/255.0, blue: 73/255.0, alpha: 1.0)
// 137
let k137Color:UIColor = UIColor.init(red: 137/255.0, green: 137/255.0, blue: 137/255.0, alpha: 1.0)
// label字体颜色
let KPetTextColor:UIColor = UIColor.init().colorWithHexString(hexString: "#222222")
// place字体颜色
let KPetPlaceholdColor:UIColor = UIColor.init().colorWithHexString(hexString: "#999999")
// 线颜色
let KPetLineColor:UIColor = UIColor.init().colorWithHexString(hexString: "#E8E8E8")
// 666666 颜色
let KPet666666Color:UIColor = UIColor.init().colorWithHexString(hexString: "#666666")
// 999999 颜色
let KPet999999Color:UIColor = UIColor.init().colorWithHexString(hexString: "#999999")
// C8C8C8 颜色
let KPetC8C8C8Color:UIColor = UIColor.init().colorWithHexString(hexString: "#C8C8C8")
// 333333 颜色
let KPet333333Color:UIColor = UIColor.init().colorWithHexString(hexString: "#333333")

func RGBA(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}
func RGB(r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
}

let CBFont = {(fontSize: CGFloat) -> UIFont? in
    return UIFont.init(name: CBPingFangSC_Regular, size: fontSize*KFitHeightRate)
}

let CBFontM = {(fontSize: CGFloat) -> UIFont? in
    return UIFont.init(name: CBPingFang_SC_Bold, size: fontSize*KFitHeightRate)
}
let KCBPetWakeUpLocalPhone = "KCBPetWakeUpLocalPhone"


