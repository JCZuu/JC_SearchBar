//
//  MainViewController.m
//  JCSearchBar
//
//  Created by 祝国庆 on 2018/8/15.
//  Copyright © 2018年 qixinpuhui. All rights reserved.
//

#import "MainViewController.h"
#import "SearchViewController.h"
#import "Header.h"
@interface MainViewController ()

@end

@implementation MainViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadSearchViews];

}
- (void)loadSearchViews
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KNavHeight_Sys)];
    bgView.backgroundColor = [UIColor clearColor];
    [self.customNavView addSubview:bgView];
    UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgBtn setImage:[UIImage imageNamed:@"toutiao_icon"] forState:UIControlStateNormal];
    [bgView addSubview:imgBtn];
    imgBtn.adjustsImageWhenHighlighted = NO;
    [imgBtn setFrame:CGRectMake(15, (KNavHeight_Sys-KStatusBarHeight_Sys - 22 * kAutoLayoutWidth) / 2 + KStatusBarHeight_Sys, 90 * kAutoLayoutWidth, 22 * kAutoLayoutWidth)];
    UIButton *searchButton = [[UIButton alloc]init];
    searchButton.backgroundColor = [UIColor whiteColor];
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    searchButton.frame = CGRectMake(imgBtn.frame.origin.x+imgBtn.frame.size.width + 5, (KNavHeight_Sys-KStatusBarHeight_Sys - 26 * kAutoLayoutWidth) / 2 + KStatusBarHeight_Sys, 245 * kAutoLayoutWidth, 26 * kAutoLayoutWidth);
    [bgView addSubview:searchButton];
    searchButton.layer.cornerRadius = 12 * kAutoLayoutWidth;
    searchButton.layer.masksToBounds = YES;
    
    UIImageView *searchImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_icon"]];
    searchImgView.contentMode = UIViewContentModeScaleAspectFit;
    [searchButton addSubview:searchImgView];
    searchImgView.frame = CGRectMake(15, 26 * kAutoLayoutWidth / 2 - 12 / 2, 12, 12);
    UILabel *searchLabel = [[UILabel alloc]init];
    searchLabel.font = [UIFont systemFontOfSize:12.0];
    searchLabel.textColor = [UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1.0];
    searchLabel.textAlignment = NSTextAlignmentLeft;
    searchLabel.frame = CGRectMake(searchImgView.frame.origin.x + searchImgView.frame.size.width + 5, 0, 245 * kAutoLayoutWidth - 45, 26 * kAutoLayoutWidth);
    [searchButton addSubview:searchLabel];
    searchLabel.text = @"大家都在搜：提出这些新要求";
}
- (void)searchAction
{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
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
