//
//  SearchListViewController.h
//  JCSearchBar
//
//  Created by 祝国庆 on 2018/8/17.
//  Copyright © 2018年 qixinpuhui. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchListDelegate <NSObject>
- (void)resignFirstResponderForSearchTF;
- (void)didSelectSearchText:(NSString *)searchTextM;

@end
@interface SearchListViewController : UIViewController
@property (nonatomic, copy)   NSString      *searchTitle;       //搜索主题
@property (nonatomic, strong) NSArray       *searchList;        //筛选列表

@property (nonatomic, assign) id<SearchListDelegate> delegate;

@end
