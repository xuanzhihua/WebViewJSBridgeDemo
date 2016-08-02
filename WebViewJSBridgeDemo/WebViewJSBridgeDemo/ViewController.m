//
//  ViewController.m
//  WebViewJSBridgeDemo
//
//  Created by 旋之华 on 16/8/1.
//  Copyright © 2016年 . All rights reserved.
//

#import "ViewController.h"
#import <WebViewJavascriptBridge.h>

@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 2.加载网页
    NSString *indexPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *appHtml = [NSString stringWithContentsOfFile:indexPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseUrl = [NSURL fileURLWithPath:indexPath];
    [self.webView loadHTMLString:appHtml baseURL:baseUrl];
    
    // 3.开启日志
    [WebViewJavascriptBridge enableLogging];
    
    // 4.给webView建立JS和OC的沟通桥梁
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    
    
    /* JS调用OC的API:访问相册 */
    [self.bridge registerHandler:@"openCamera" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"需要%@图片", data[@"count"]);
        
        UIImagePickerController *imageVC = [[UIImagePickerController alloc] init];
        imageVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imageVC animated:YES completion:nil];
    }];
    
    
     /* JS调用OC的API:访问底部弹窗 */
    [self.bridge registerHandler:@"showSheet" handler:^(id data, WVJBResponseCallback responseCallback) {
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"你猜我谈不谈?" message:@"不谈不谈,就不谈!!" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [vc addAction:cancelAction];
        [vc addAction:okAction];
        [self presentViewController:vc animated:YES completion:nil];
    }];
    
    
}

/*  获取用户信息  */
- (IBAction)getUserinfo {
    // 调用JS中的API
    [self.bridge callHandler:@"getUserInfo" data:@{@"userId":@"DX001"} responseCallback:^(id responseData) {
        NSString *userInfo = [NSString stringWithFormat:@"%@,姓名:%@,年龄:%@", responseData[@"userID"], responseData[@"userName"], responseData[@"age"]];
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"从网页端获取的用户信息" message:userInfo preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [vc addAction:cancelAction];
        [vc addAction:okAction];
        [self presentViewController:vc animated:YES completion:nil];
    }];
}

/* 弹框显示消息 */
- (IBAction)showInfo {
    // 调用JS中的API
    [self.bridge callHandler:@"alertMessage" data:@"调用了js中的Alert弹窗!" responseCallback:^(id responseData) {
       
    }];
}

/* 控制界面动态跳转 */
- (IBAction)pushToNewWebSite {
    // 调用JS中的API
    [self.bridge callHandler:@"pushToNewWebSite" data:@{@"url":@"http://m.jd.com"} responseCallback:^(id responseData) {
        
    }];
}

/* 刷新界面 */
- (IBAction)reloadWebPage {
    [self.webView reload];
}

/* 插入新图片 */
- (IBAction)insertImgToWebPage {
    
    NSDictionary *dict = @{
                           @"url" : @"http://upload-images.jianshu.io/upload_images/1268909-0e394c67e1ce6666.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                           };
    // 调用JS中的API
    [self.bridge callHandler:@"insertImgToWebPage" data:dict responseCallback:^(id responseData) {
        
    }];
    
}

@end
