//
//  SearchResultViewController.h
//  JCSearchBar
//
//  Created by 祝国庆 on 2018/8/17.
//  Copyright © 2018年 qixinpuhui. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchResultDelegate <NSObject>
- (void)pushToNewsDetailPage:(NSDictionary *)newsModelM;
@end
@interface SearchResultViewController : UIViewController
@property (nonatomic, copy)     NSString  *searchText;      //要搜索的主题

@property (nonatomic, assign)   id<SearchResultDelegate> delegate;

@end
