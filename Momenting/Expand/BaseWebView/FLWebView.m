//
//  FLWebView.m
//  FaceLive
//
//  Created by zhangyi on 2017/7/12.
//  Copyright © 2017年 mty. All rights reserved.
//

#import "FLWebView.h"


@interface FLWebView ()<WKUIDelegate,WKNavigationDelegate>


@end

@implementation FLWebView

- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)url
{
    self = [super initWithFrame:frame];
    if (self) {
        WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
        //将所有cookie以document.cookie = 'key=value';形式进行拼接(引号一定要是英文)
        NSString *cookieValue = [self getCookieValue];
        // 加cookie给h5识别，表明在ios端打开该地址
        WKUserContentController* userContentController = WKUserContentController.new;
        WKUserScript * cookieScript = [[WKUserScript alloc]
                                       initWithSource: cookieValue
                                       injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContentController addUserScript:cookieScript];
        webConfig.userContentController = userContentController;
        self.webView = [[WKWebView alloc] initWithFrame:self.bounds configuration:webConfig];
        self.webView.scrollView.bounces = YES;
        self.webView.allowsBackForwardNavigationGestures = YES;
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate = self;
        [self addSubview:self.webView];
        [self setUpBridge];
        [self addSubview:self.progressView];
        [self bringSubviewToFront:self.progressView];
        [self addNotifications];
        
    }
    return self;
}


#pragma mark - Notification
- (void)addNotifications
{
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.1f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    }
}

-(NSString *)getCookieValue{
    return @"momenting";
}


-(void)setUpBridge{
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
    [self registerHandler];
}


//处理OC与JS交互
-(void)registerHandler{
    
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
    
}


//加载webView
-(void)loadWithUrl:(NSString *)url{
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    if ([url hasPrefix:@"http"]) {
        [self.webView loadRequest:request];
    } else {
        
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        NSString * htmlPath = [[NSBundle mainBundle] pathForResource:url
                                                              ofType:@"html"];
        NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
        [self.webView loadHTMLString:htmlCont baseURL:baseURL];
    }
}

-(void)setHiddenProgress:(BOOL)hiddenProgress{
    _hiddenProgress = hiddenProgress;
    if (hiddenProgress) {
        //隐藏
        [self.progressView removeFromSuperview];
    }else{
        //显示
        self.progressView.hidden = NO;
    }
}

-(void)dealloc{
    if (self.webView) {
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
        self.webView = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - WKNavigationDelegate

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
    NSString *url = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    
    if ([url hasPrefix:@"itms"]) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    if ([self.delegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [self.delegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    }
}

//开始加载
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    if ([self.delegate respondsToSelector:@selector(webViewdidStart:Navigation:)]) {
        [self.delegate webViewdidStart:webView Navigation:navigation];
    }
}

//加载完成
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if ([self.delegate respondsToSelector:@selector(webViewdidFinish:Navigation:)]) {
        [self.delegate webViewdidFinish:webView Navigation:navigation];
    }
}

//加载失败
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(webView:Navigation:didFail:)]) {
        [self.delegate webView:webView Navigation:navigation didFail:error];
    }
}

#pragma mark - 懒加载
-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        _progressView.trackTintColor = [UIColor clearColor];
    
    }
    return _progressView;
}


@end
