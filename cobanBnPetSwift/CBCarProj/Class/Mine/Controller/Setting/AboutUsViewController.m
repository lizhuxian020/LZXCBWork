//
//  AboutUsViewController.m
//  Telematics
//
//  Created by lym on 2017/11/14.
//  Copyright © 2017年 lym. All rights reserved.
//

#import "AboutUsViewController.h"
#import <WebKit/WebKit.h>

@interface AboutUsViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

#pragma mark - CreateUI
- (void)createUI
{
    [self initBarWithTitle:Localized(@"关于我们") isBack: YES];
    [self createWebView];
}

- (void)createWebView
{
    NSURL *url = nil;
    if (self.webUrl != nil) {
        url = [NSURL URLWithString: self.webUrl];
    }else {
        //@"http://api.brezze.global/app/getinfo.html?code=agreement"
        self.webUrl = @"http://www.coban.net/En/About/Index.html";
    }
//    NSURLRequest *request = [NSURLRequest requestWithURL: url];
//    [self.webView loadRequest: request];
//    [self.view addSubview: self.webView];
//    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.top.equalTo(self.view);
//    }];
    
    self.webView = [[WKWebView alloc] init];
    //[MBProgressHUD showHUDIcon:self.self.webView animated:YES];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    [self.view addSubview: _webView];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //监听UIWindow显示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];
    //监听UIWindow隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
}
-(void)beginFullScreen {
    //NSLog(@"进入全屏");
}
-(void)endFullScreen {
    //NSLog(@"退出全屏");
    [UIApplication sharedApplication].statusBarHidden = NO;
}
- (void)dealloc {
    self.webView.navigationDelegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [MBProgressHUD showHUDIcon:self.webView animated:YES];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [MBProgressHUD hideHUDForView:self.webView animated:YES];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [MBProgressHUD hideHUDForView:self.webView animated:YES];
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"接收到服务器响应，是否跳转%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    //每次点击H5中的line会跳转一个新网页，"_black" 是开一个新的页面 打开网页,和Safari中点加号一样！
    //当然在应用中如果不实现和Safari一样的效果 那就只能让其在当前页面中 重新加载一次新link
    //if (navigationAction.targetFrame == nil) {
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        //[webView loadRequest:navigationAction.request];
    }
    NSLog(@"跳转rurl：%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}
#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    //每次点击H5中的line会跳转一个新网页，"_black" 是开一个新的页面 打开网页,和Safari中点加号一样！
    //当然在应用中如果不实现和Safari一样的效果 那就只能让其在当前页面中 重新加载一次新link
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;//self.webView;//[[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}
#pragma mark - Other Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
