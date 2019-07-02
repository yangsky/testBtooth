//
//  BTFHomepageTableViewController.m
//  BTF
//
//  Created by aimoke on 16/7/27.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "BTFHomepageTableViewController.h"

@interface BTFHomepageTableViewController ()

@end

@implementation BTFHomepageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.title = @"Homepage";
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//
//    // 1.创建webview，并设置大小，"20"为状态栏高度
//    CGFloat width = self.view.frame.size.width;
//    CGFloat height = self.view.frame.size.height - 20;
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, width, height)];
//    // 2.创建URL
//    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
//    // 3.创建Request
//    NSURLRequest *request =[NSURLRequest requestWithURL:url];
//    // 4.加载网页
//    [webView loadRequest:request];
//    // 5.最后将webView添加到界面
//    [self.view addSubview:webView];
//    [self.view bringSubviewToFront:webView];
}

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
