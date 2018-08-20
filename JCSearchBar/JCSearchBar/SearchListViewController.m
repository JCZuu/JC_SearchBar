//
//  SearchListViewController.m
//  JCSearchBar
//
//  Created by 祝国庆 on 2018/8/17.
//  Copyright © 2018年 qixinpuhui. All rights reserved.
//

#import "SearchListViewController.h"
#import "Header.h"
@interface SearchListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)  UITableView      *searchTableView;

@end

@implementation SearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSearchTableViews];
}
//初始化搜索历史表视图
- (void)initSearchTableViews
{
    [self.view addSubview:self.searchTableView];
    [_searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(_searchTableView.superview);
    }];
}
//搜索列表刷新
- (void)setSearchList:(NSArray *)searchList
{
    if (_searchList != searchList)
    {
        _searchList = searchList;
    }
    [_searchTableView reloadData];
}
#pragma mark - 表视图
- (UITableView *)searchTableView
{
    if (!_searchTableView)
    {
        _searchTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.backgroundColor = [UIColor whiteColor];
        _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _searchTableView;
}
#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idetifier];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44.3, KScreenWidth, 0.7)];
        lineView.tag = 100;
        lineView.hidden = YES;
        lineView.backgroundColor = COLOR_A4__;
        [cell.contentView addSubview:lineView];
    }
    UIView *lineView = [cell.contentView viewWithTag:100];
    lineView.hidden = NO;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.imageView.image = [UIImage imageNamed:@"search_logo_icon"];
    
    NSString *searchStr = _searchList[indexPath.row];
    NSMutableAttributedString *searchAttr = [[NSMutableAttributedString alloc]initWithString:searchStr];
    NSRange titleRange = [searchStr rangeOfString:_searchTitle];
    if (titleRange.location != NSNotFound)
    {//存在某个字符串
        [searchAttr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, titleRange.location)];
        [searchAttr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName:COLOR_C8__} range:NSMakeRange(titleRange.location, titleRange.length)];
        [searchAttr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(titleRange.location + titleRange.length, searchAttr.length - titleRange.location - titleRange.length)];
    }
    cell.textLabel.attributedText = searchAttr;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{//选择搜索的内容项
    if ([self.delegate respondsToSelector:@selector(didSelectSearchText:)])
    {
        [self.delegate didSelectSearchText:_searchList[indexPath.row]];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{//滑动取消第一响应者
    if ([self.delegate respondsToSelector:@selector(resignFirstResponderForSearchTF)])
    {
        [self.delegate resignFirstResponderForSearchTF];
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
