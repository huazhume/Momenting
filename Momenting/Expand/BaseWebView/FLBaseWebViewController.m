//
//  FLBaseWebViewController.m
//  FaceLive
//
//  Created by zhangyi on 2017/7/12.
//  Copyright © 2017年 mty. All rights reserved.
//

#import "FLBaseWebViewController.h"
#import "MTNavigationView.h"


@interface FLBaseWebViewController () <FLWebViewDelegate,MTNavigationViewDelegate>

/**  closeButton */
@property(nonatomic , strong) UIButton * closeButton;
@property(nonatomic , strong) UIButton * backButton;

@property(nonatomic, assign) NSInteger extraType;
@property(nonatomic, strong) MTNavigationView *navigationView;


@end

@implementation FLBaseWebViewController

-(instancetype)initWithUrl:(NSString *)url{
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (void)setNavigationTitle:(NSString *)navigationTitle
{
    _navigationTitle = navigationTitle;
    self.navigationView.navigationTitle = navigationTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.navigationView];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat y = 0;
    self.webView = [[FLWebView alloc] initWithFrame:CGRectMake(0, self.isShowNavigation ? 55 + iPhoneTopMargin : -20, SCREEN_WIDTH , SCREEN_HEIGHT - (self.isShowNavigation ? 55 + iPhoneTopMargin : -20) ) url:self.url];
    [self.webView loadWithUrl:_url];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [self registNotification];
    
    self.navigationView.hidden = !self.isShowNavigation;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)reloadData{
    [self.webView loadWithUrl:_url];
}

-(void)leftBarButtonClick{
    if (_webView.webView.canGoBack) {
        [_webView.webView goBack];
    }else{
        if (self.dismissBlock) {
            self.dismissBlock();
        }
        
        if (self.isDisMiss) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - MTNavigationViewDelegate
- (void)leftAction
{
    if (self.isDisMiss) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - notification
- (void)registNotification
{
    [self.webView.webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    self.url = self.webView.webView.URL.absoluteString;
}

//更新导航栏状态
-(void)updateNavigationView{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __weak typeof(self) weakSelf = self;
        [_webView.webView evaluateJavaScript:@"document.title" completionHandler:^(id title, NSError * _Nullable error) {
            NSString * titleStr = title;
            if (titleStr.length > 15) {
                titleStr = [titleStr substringToIndex:15];
                titleStr = [titleStr stringByAppendingString:@"..."];
            }
            if (titleStr.length > 0) {
                weakSelf.customTitle =  self.customTitle ?: titleStr;
            }
        }];
        if (_webView.webView.canGoBack) {
            _closeButton.hidden = NO;
        }else{
            _closeButton.hidden = YES;
        }
    });
}

//关闭当前页面
-(void)closeCurrentPage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [self.webView.webView removeObserver:self forKeyPath:@"URL"];
    if (_webView) {
        _webView.bridge = nil;
        _webView = nil;
    }
}

#pragma mark - invokeMethod
- (void)dismissWebView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setWebTitle:(NSDictionary *)params
{
    NSString *title = [params objectForKey:@"title"];
    if (title.length > 0) {
        self.customTitle = self.customTitle ?: title;
    }
}

#pragma mark - FLWebViewDelegate

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    [self updateNavigationView];
}

-(void)webViewdidStart:(WKWebView *)webView Navigation:(WKNavigation *)navigation{
    
}

-(void)webViewdidFinish:(WKWebView *)webView Navigation:(WKNavigation *)navigation{
    [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *title, NSError * _Nullable error) {
        if (title.length > 0) {
            self.customTitle =  self.customTitle ?: title;
        }
    }];
}

-(void)webView:(WKWebView *)webView Navigation:(WKNavigation *)navigation didFail:(NSError *)error{

}

-(void)backActionCallBack:(BOOL)backRoot{
    if (backRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self leftBarButtonClick];
    }
}

#pragma mark - 懒加载
- (MTNavigationView *)navigationView
{
    if (!_navigationView) {
        _navigationView = [MTNavigationView loadFromNib];
        _navigationView.frame = CGRectMake(0, iPhoneTopMargin, SCREEN_WIDTH, 55);
        _navigationView.delegate = self;
//        _navigationView.backgroundColor = [UIColor whiteColor];
        _navigationView.rightTitle = @"";
        _navigationView.navigationTitle = @"";
//        _navigationView.type = MTNavigationViewNoteDetail;
    }
    return _navigationView;
}

@end
