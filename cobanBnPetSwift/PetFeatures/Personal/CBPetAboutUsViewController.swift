//
//  CBPetAboutUsViewController.swift
//  cobanBnPetSwift
//
//  Created by coban on 2020/7/29.
//  Copyright © 2020 coban. All rights reserved.
//

import UIKit
import WebKit

class CBPetAboutUsViewController: CBPetBaseViewController {//WKUIDelegate,WKNavigationDelegate

    private lazy var webView:WKWebView = {
        let webV = WKWebView.init()
        return webV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
        
    }
    private func setupView() {
        self.view.backgroundColor = UIColor.white
        initBarWith(title: "关于我们".localizedStr, isBack: true)
        
        self.view.addSubview(self.webView)
        self.webView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.webView.load(URLRequest.init(url: URL.init(string: "http://www.coban.net/En/About/Index.html")!))
    }
    deinit {
        self.webView.navigationDelegate = nil
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
extension CBPetAboutUsViewController:WKUIDelegate,WKNavigationDelegate {
    /* 页面开始加载时调用*/
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //
        //MBProgressHUD.showAdded(to: self.webView, animated: true)
    }
    /* 内容开始返回时调用*/
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //
    }
    /* 页面加载完成之后调用*/
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //
    }
    /* 页面加载失败时调用*/
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        //
    }
    /* 接收到服务器跳转请求之后调用*/
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        //
    }
    @available(iOS 13.0, *)
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        decisionHandler(.allow, WKWebpagePreferences.init())
    }
    /* 在发送请求之前，决定是否跳转*/
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let frameInfo = navigationAction.targetFrame
        if !(frameInfo?.isMainFrame ?? false) {
        }
        decisionHandler(.allow)
    }
    /* WKUIDelegate*/
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let frameInfo = navigationAction.targetFrame
        if !(frameInfo?.isMainFrame ?? false) {
            webView.load(navigationAction.request)
        }
        return nil
    }
    /* 输入框*/
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        completionHandler("http")
    }
    /* 确认框*/
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
    /* 警告框*/
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
