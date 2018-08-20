//
//  Header.h
//  JCSearchBar
//
//  Created by 祝国庆 on 2018/8/15.
//  Copyright © 2018年 qixinpuhui. All rights reserved.
//

#ifndef Header_h
#define Header_h
/**  屏幕宽度、高度 */
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
/**  是否是iphoneX */
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
/**  Nav View Height */
#define KNavHeight_Sys (KIsiPhoneX==1 ? 88 : 64)
#define KTabbarHeight_Sys (KIsiPhoneX==1 ? 83 : 49)
#define KStatusBarHeight_Sys (KIsiPhoneX==1 ? 44 : 20)
#define kAutoLayoutWidth    (KScreenWidth / (750 / 2))

#define COLOR_MAIN_VC_BG__ [UIColor colorWithRed:244/255.0 green:245/255.0 blue:247/255.0 alpha:1.0]
#define COLOR_A3__ [UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1.0]
#define COLOR_A4__ [UIColor colorWithRed:225/255.0 green:229/255.0 blue:235/255.0 alpha:1.0]
#define COLOR_A1__ [UIColor colorWithRed:41/255.0 green:41/255.0 blue:41/255.0 alpha:1.0]
#define COLOR_C3__ [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0]

#define COLOR_C5__ [UIColor colorWithRed:165/255.0 green:165/255.0 blue:165/255.0 alpha:1.0]
#define COLOR_C8__ [UIColor colorWithRed:255/255.0 green:68/255.0 blue:64/255.0 alpha:1.0]
/**  字符串是否为空 */
#define IsStrEmpty(_ref)             (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))


///////////////////////////////
#import "Masonry.h"

#endif /* Header_h */
