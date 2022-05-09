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
        
        AppDelegate.setNavigationBGColor()
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
