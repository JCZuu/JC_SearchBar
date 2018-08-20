//
//  BaseViewController.h
//  JCSearchBar
//
//  Created by 祝国庆 on 2018/8/15.
//  Copyright © 2018年 qixinpuhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface BaseViewController : UIViewController
//自定义导航栏
@property(nonatomic, strong) UIImageView        *customNavView;
@property(nonatomic, strong) UINavigationBar    *customNavBar;
@property(nonatomic, strong) UINavigationItem   *customNavItem;
@end
