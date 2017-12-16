//
//  SecondViewController.m
//  JSOCProject
//
//  Created by 小飞鸟 on 2017/12/14.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "SecondViewController.h"
#import <WebKit/WebKit.h>
#import "WebViewJavascriptBridge.h"

@interface SecondViewController ()<WKNavigationDelegate>
@property WebViewJavascriptBridge* bridge;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor yellowColor];
    // Do any additional setup after loading the view.
    WKWebView* webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 400)];
    webView.navigationDelegate = self;
    webView.backgroundColor=[UIColor lightGrayColor];
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"bridge" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
    [self.view addSubview:webView];
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
    callbackButton.frame = CGRectMake(10, 450, 100, 35);
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge setWebViewDelegate:self];
    //
    [_bridge registerHandler:@"convertToOC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"传到前段的数据 %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
    
}

- (void)callHandler:(id)sender {
    id data = @{ @"name": @"张辉" };
    [_bridge callHandler:@"convertToH5" data:data responseCallback:^(id response) {
        NSLog(@"testJavascriptHandler responded: %@", response);
    }];
}



@end
