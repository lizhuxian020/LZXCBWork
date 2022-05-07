//
//  CBPetBaseNavigationViewController.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/3/18.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit

class CBPetBaseNavigationViewController: UINavigationController,UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.delegate = self
        if #available(iOS 13.0, *) {
             let app = UINavigationBarAppearance()
             app.configureWithOpaqueBackground()  // 重置背景和阴影颜色
            
//            self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
             app.titleTextAttributes = [
                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                   NSAttributedString.Key.foregroundColor: UIColor.white
             ]
            app.backgroundColor = UIColor.init().colorWithHexString(hexString: "#2E2F41")  // 设置导航栏背景色
             app.shadowColor = .clear
             UINavigationBar.appearance().scrollEdgeAppearance = app  // 带scroll滑动的页面
             UINavigationBar.appearance().standardAppearance = app // 常规页面。描述导航栏以标准高度
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: KCBPushNewVCNotification), object: nil, userInfo: nil)
        super.pushViewController(viewController, animated: true)
    }
    deinit {
        self.delegate = nil
    }
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        
//        return self.topViewController?.preferredStatusBarStyle ?? UIStatusBarStyle.default
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
