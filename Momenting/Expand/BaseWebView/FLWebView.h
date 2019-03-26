//
//  FLWebView.h
//  FaceLive
//
//  Created by zhangyi on 2017/7/12.
//  Copyright © 2017年 mty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"
#import <WebKit/WebKit.h>


@protocol FLWebViewDelegate <NSObject>

@optional

-(void)webViewdidStart:(WKWebView *)webView Navigation:(WKNavigation *)navigation;
-(void)webViewdidFinish:(WKWebView *)webView Navigation:(WKNavigation *)navigation;
-(void)webView:(WKWebView *)webView Navigation:(WKNavigation *)navigation didFail:(NSError *)error;
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
-(void)setControllerLandscape;

-(void)backActionCallBack:(BOOL)backRoot;



@end

@interface FLWebView : UIView


/**  delegate */
@property(nonatomic , weak) id<FLWebViewDelegate> delegate;
/**  webView */
@property(nonatomic , strong) WKWebView * webView;
/**  bridge */
@property(nonatomic , strong) WebViewJavascriptBridge * bridge;

@property(nonatomic , strong) UIProgressView * progressView;
/**  是否显示进度条(默认显示) */
@property(nonatomic , assign) BOOL hiddenProgress;

- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)url;

- (void)hideNavigation;

-(void)loadWithUrl:(NSString *)url;


@end
