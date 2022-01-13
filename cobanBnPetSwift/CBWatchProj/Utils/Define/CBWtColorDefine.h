//
//  CBWtColorDefine.h
//  Singapore_powerbank
//
//  Created by 麦鱼科技 on 2017/8/16.
//  Copyright © 2017年 麦鱼科技. All rights reserved.
//

#ifndef CBWtColorDefine_h
#define CBWtColorDefine_h

#define KWtRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define KWtRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//vc背景色
#define KWtViewVCBackgroundColor [UIColor whiteColor]
//导航栏颜色
#define KWtNavBarBgColor [UIColor whiteColor]
//主色调
#define KWtAppMainColor KWtRGB(28.0,150.0,242.0)
//棕色
#define KWtBrownColor [UIColor colorWithHexString:@"808080"]
//蓝色
#define KWtBlueColor [UIColor colorWithRed: 15 /255.0 green: 126/255.0 blue: 255/255.0 alpha:1.0]
//绿色
#define KWtGreenColor [UIColor colorWithRed: 116 /255.0 green: 218/255.0 blue: 128/255.0 alpha:1.0]
//黑色
#define KWtBlackColor [UIColor colorWithRed: 73 /255.0 green: 73/255.0 blue: 73/255.0 alpha:1.0]
//线颜色
#define KWtLineColor [UIColor colorWithRed: 210 /255.0 green: 210/255.0 blue: 210/255.0 alpha:1.0]
//cell的背景色
#define KWtCellBackColor [UIColor colorWithRed: 255 /255.0 green: 255/255.0 blue: 255/255.0 alpha:1.0]
//cell 文本颜色
#define KWtCellTextColor [UIColor colorWithRed: 73 /255.0 green: 73/255.0 blue: 73/255.0 alpha:1.0]
//背景颜色
#define KWtBackColor [UIColor colorWithRed: 237 /255.0 green: 237/255.0 blue: 237/255.0 alpha:1.0]
//输入框内容颜色
#define KWtTextFieldColor [UIColor colorWithRed: 210 /255.0 green: 210/255.0 blue: 210/255.0 alpha:1.0]
//登录注册忘记密码的颜色
#define KWtLoginPartColor [UIColor colorWithRed: 179 /255.0 green: 167/255.0 blue: 199/255.0 alpha:1.0]

#define KWt137Color [UIColor colorWithRed: 137 / 255.0 green: 137 / 255.0 blue: 137 / 255.0 alpha: 1.0]

#endif /* CBWtColorDefine_h */
