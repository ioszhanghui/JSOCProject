//
//  ViewController.m
//  JSOCProject
//
//  Created by 小飞鸟 on 2017/12/14.
//  Copyright © 2017年 小飞鸟. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SecondViewController.h"

@interface ViewController ()<UIWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView * web =[[UIWebView alloc]initWithFrame:self.view.bounds];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil]]]];
    web.delegate=self;
    [self.view addSubview:web];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //js 调用OC 给OC传值
    context[@"convert"]=^(){
        
        NSArray * args=[JSContext currentArguments];
        NSDictionary * info =[self parseJSONStringToNSDictionary:[[args objectAtIndex:0] toString]];
        NSLog(@"%@",[info objectForKey:@"message"]);
        
    };
    context[@"goto"]=^(){
        
        [self presentViewController:[SecondViewController new] animated:YES completion:nil];
    };
    
    //oc 调用 js
    NSString *textJS = @"document.getElementsByClassName('btn')[0].style.backgroundColor = 'green';";
    [context evaluateScript:textJS];
    
    //OC 调用js 给h5传值
    NSString *cJS= @"test({'code':'300','message':'获取成功','color':'red'})";
    [context evaluateScript:cJS];
    
}

-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

@end
