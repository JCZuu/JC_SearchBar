//
//  BaseViewController.m
//  JCSearchBar
//
//  Created by 祝国庆 on 2018/8/15.
//  Copyright © 2018年 qixinpuhui. All rights reserved.
//

#import "BaseViewController.h"
#import "MainViewController.h"
#import "SearchViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController
- (void)loadView
{
    [super loadView];
    if (!self.customNavView)
    {
        [self setCustomNavigationBar];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//自定义导航栏
- (void)setCustomNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _customNavView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KNavHeight_Sys)];
    _customNavView.backgroundColor = [UIColor whiteColor];
    _customNavView.layer.masksToBounds = YES;
    _customNavView.userInteractionEnabled = YES;
    _customNavView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:_customNavView atIndex:0];
    //新建导航栏
    _customNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, KStatusBarHeight_Sys, CGRectGetWidth(self.view.bounds), KNavHeight_Sys - KStatusBarHeight_Sys)];
    _customNavBar.translucent = YES;
    [_customNavBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //消除阴影
    _customNavBar.shadowImage = [UIImage new];
    [_customNavBar setTintColor:[UIColor clearColor]];
    [_customNavView addSubview:_customNavBar];
    _customNavItem = [[UINavigationItem alloc] init];
    [_customNavBar setItems:@[_customNavItem]];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, KNavHeight_Sys - 0.7, KScreenWidth, 0.7)];
    lineView.hidden = NO;
    lineView.backgroundColor = COLOR_A4__;
    [_customNavView addSubview:lineView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    lineView.hidden = NO;
    if ([self isKindOfClass:[MainViewController class]])
    {
        self.customNavView.backgroundColor = COLOR_C8__;
    }
    else
    {
        self.customNavView.backgroundColor = [UIColor whiteColor];
    }
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
