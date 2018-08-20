//
//  SearchViewController.m
//  JCSearchBar
//
//  Created by 祝国庆 on 2018/8/15.
//  Copyright © 2018年 qixinpuhui. All rights reserved.
//

#import "SearchViewController.h"
#import "Header.h"
#import "SearchListViewController.h"
#import "SearchResultViewController.h"
#import "DetailViewController.h"
@interface SearchViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, SearchListDelegate, SearchResultDelegate>
{
    UIButton            *searchBtn;      //搜索按钮
    NSMutableArray      *searchList;     //根据输入内容显示模糊搜索列表
    NSMutableArray      *hotList;        //热门搜索列表
    NSMutableArray      *historyList;    //搜索历史列表
}
@property (nonatomic, strong) UITextField    *searchTextField;
@property (nonatomic, strong) UITableView    *historyTableView;
@property (nonatomic, strong)  SearchListViewController  *searchListVC;
@property (nonatomic, strong)  SearchResultViewController *searchResultVC;

@property (nonatomic, assign) NSInteger deleteItem;
@end

@implementation SearchViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_searchTextField resignFirstResponder];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    searchList = [[NSMutableArray alloc]init];
    historyList = [[NSMutableArray alloc]init];
    hotList = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavSubViews];
    [self requestHistoryData];
}
//nav 搜索框
- (void)initNavSubViews
{
    _searchTextField = [[UITextField alloc]init];
    _searchTextField.placeholder = @"搜索你感兴趣的新闻";
    _searchTextField.font = [UIFont systemFontOfSize:13.0];
    _searchTextField.delegate = self;
    _searchTextField.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2];
    _searchTextField.tintColor = COLOR_C8__;
    [_searchTextField setValue:COLOR_A3__ forKeyPath:@"_placeholderLabel.textColor"];
    _searchTextField.frame = CGRectMake(0, (KNavHeight_Sys - KStatusBarHeight_Sys - 26) / 2, 270 * kAutoLayoutWidth, 26);
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.layer.cornerRadius = 6;
    _searchTextField.layer.masksToBounds = YES;
    UIButton *_leftPaddingView = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftPaddingView.frame = CGRectMake(0, 0, 28 + 5 * kAutoLayoutWidth, 18);
    [_leftPaddingView setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    _searchTextField.leftView = _leftPaddingView;
    _searchTextField.returnKeyType = UIReturnKeySearch;
    self.customNavItem.titleView = _searchTextField;
    [_searchTextField addTarget:self action:@selector(textfieldChangedSearch:) forControlEvents:UIControlEventEditingChanged];
    [_searchTextField becomeFirstResponder];
    //搜索按钮
    searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 40, 50);
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [searchBtn setTitleColor:COLOR_C8__ forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.customNavItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:searchBtn]];
    [searchBtn addTarget:self
                 action:@selector(searchAction:)
       forControlEvents:UIControlEventTouchUpInside];
    //自定义返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 20, 50);
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton setImage:[UIImage imageNamed:@"back_icon_black"] forState:UIControlStateNormal];
    [backButton addTarget:self
                   action:@selector(backAction:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.customNavItem.leftBarButtonItems = @[barButtonItem];
}
#pragma mark - init Views
//初始化搜索历史表视图
- (void)initHistoryTableViews
{
    [self.view addSubview:self.historyTableView];
    [_historyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.historyTableView.superview);
        make.top.mas_equalTo(KNavHeight_Sys);
    }];
    
}
#pragma mark - 表视图
- (UITableView *)historyTableView
{
    if (!_historyTableView)
    {
        _historyTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _historyTableView.delegate = self;
        _historyTableView.dataSource = self;
        _historyTableView.backgroundColor = [UIColor whiteColor];
        _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _historyTableView;
}
#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return hotList.count > 0?1:0;
    }
    return historyList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *historyIdetifier = @"history";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historyIdetifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:historyIdetifier];
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.tag = 100;
        titleLabel.hidden = YES;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(titleLabel.superview);
            make.width.mas_lessThanOrEqualTo(KScreenWidth - 100);
        }];
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.tag = 200 + indexPath.row;
        deleteBtn.hidden = YES;
        [deleteBtn setImage:[UIImage imageNamed:@"search_delete_icon"] forState:UIControlStateNormal];
        deleteBtn.adjustsImageWhenHighlighted = NO;
        [cell.contentView addSubview:deleteBtn];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(deleteBtn.superview);
            make.right.equalTo(deleteBtn.superview).offset(-15);
            make.width.height.mas_equalTo(20);
        }];
        UIView *lineView = [[UIView alloc]init];
        lineView.tag = 102;
        lineView.backgroundColor = COLOR_A4__;
        lineView.hidden = YES;
        [cell.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(lineView.superview);
            make.height.mas_equalTo(0.8);
        }];
        for (int i = 0 ; i < hotList.count; i ++)
        {
            UIButton *hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            hotBtn.userInteractionEnabled = YES;
            hotBtn.hidden = YES;
            hotBtn.tag = 300 + i;
            [hotBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            hotBtn.backgroundColor = COLOR_MAIN_VC_BG__;
            [cell.contentView addSubview:hotBtn];
            [hotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(i%2==0?15:15 + 5 + (KScreenWidth - 15 - 5 - 15)/ 2);
                make.top.mas_equalTo(floor(i/2.0) * 5 + floor(i/2.0)*40);
                make.width.mas_equalTo((KScreenWidth - 15 - 5 - 15)/ 2);
                make.height.mas_equalTo(40);
            }];
            hotBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
            hotBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:100];
    UIButton *deleteBtn = (UIButton *)[cell.contentView viewWithTag:200 + indexPath.row];
    if (indexPath.section == 0)
    {//热门搜索
        titleLabel.hidden = deleteBtn.hidden = YES;
        for (int i = 0; i < hotList.count; i ++)
        {
            UIButton *hotBtn = (UIButton *)[cell.contentView viewWithTag:300 + i];
            hotBtn.hidden = NO;
            [hotBtn setTitle:hotList[i] forState:UIControlStateNormal];
            [hotBtn addTarget:self action:@selector(hotAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else
    {//搜索记录
        for (int i = 0; i < hotList.count; i ++)
        {
            UIButton *hotBtn = (UIButton *)[cell.contentView viewWithTag:200 + i];
            hotBtn.hidden = YES;
        }
        titleLabel.hidden = deleteBtn.hidden = NO;
        UIView *lineView = [cell.contentView viewWithTag:102];
        if (historyList.count > 0)
        {
            titleLabel.text = historyList[indexPath.row];
            lineView.hidden = indexPath.row < historyList.count - 1? NO:YES;
            [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchTextField resignFirstResponder];
    if (indexPath.section == 1)
    {//显示搜索结果
        [self showSearchResultViews:[historyList objectAtIndex:indexPath.row]];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (hotList.count > 0)
        {
            return ceil(hotList.count / 2.0) * (5 + 40) + 30;
        }
        return CGFLOAT_MIN;
    }
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section==0?CGFLOAT_MIN:((historyList.count > 0? 30:CGFLOAT_MIN));
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 45.0)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, KScreenWidth - 30, 20)];
    headerView.userInteractionEnabled = titleLabel.userInteractionEnabled = NO;
    titleLabel.textColor = COLOR_C5__;
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    [headerView addSubview:titleLabel];
    titleLabel.text = section==0?@"热门搜索":@"搜索记录";
    return section==0?(hotList.count==0?[UIView new]:headerView):(historyList.count==0?[UIView new]:headerView);
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, KScreenWidth, 30)];
    footerView.backgroundColor = COLOR_MAIN_VC_BG__;
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setTitle:@"清除历史记录" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:COLOR_A3__ forState:UIControlStateNormal];
    [deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [deleteBtn setFrame:CGRectMake(20, 0, KScreenWidth - 40, 30)];
    [footerView addSubview:deleteBtn];
    [deleteBtn addTarget:self action:@selector(clearHistoryAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return section==0?[UIView new]:(historyList.count>0?footerView:[UIView new]);
}
#pragma mark - UITextFieldDelegate
//开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [self showSearchTitleList];
}
//键盘的搜索按钮事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self showSearchResultViews:textField.text];
    return YES;
}
//模糊搜索列表页面代理
#pragma mark - SearchListDelegate
- (void)resignFirstResponderForSearchTF
{
    [_searchTextField resignFirstResponder];
}
//模糊搜索选择后，显示搜索结果列表
- (void)didSelectSearchText:(NSString *)searchTextM
{
    [self showSearchResultViews:searchTextM];
}
//搜索结果页面代理
#pragma mark - SearchResultDelegate
/**
 *  点击搜索结果列表事件
 *  代理方法参数根据需求进行修改
 */
- (void)pushToNewsDetailPage:(NSDictionary *)newsModelM
{
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.title = @"详情页面";
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - 点击事件
#pragma mark - Control Action
//点击搜索按钮
- (void)searchAction:(UIButton *)button
{
    [_searchTextField resignFirstResponder];
    if ([button.currentTitle isEqualToString:@"搜索"])
    {
        if (!IsStrEmpty(_searchTextField.text))
        {
            [self showSearchResultViews:_searchTextField.text];
        }
        else
        {
            NSLog(@"请输入关键字");
        }
    }
    else
    {
        [button setTitle:@"搜索" forState:UIControlStateNormal];
        _searchTextField.text = @"";
        _searchResultVC.view.hidden = YES;
    }
}
//输入文字模糊搜索
- (void)textfieldChangedSearch:(UITextField *)textField
{
    NSArray *datas = @[@"1211", @"1231", @"1234", @"11234",
                       @"12345", @"123456", @"123451", @"123457",
                       @"12345678", @"231298", @"1234578", @"1234578897655",
                       @"234321", @"1234567890", @"123456765", @"98776",
                       @"34345345", @"123455675", @"345456", @"487548",
                       @"5667568787", @"234567", @"876543", @"56789"];
    NSString *searchString = [textField text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (searchList != nil )
    {
        [searchList removeAllObjects];
    }
    //过滤数据
    searchList = [NSMutableArray arrayWithArray:[datas filteredArrayUsingPredicate:preicate]];
    [self showSearchTitleList];
}
//点击热门搜索
- (void)hotAction:(UIButton *)button
{
    NSLog(@"热门");
    //显示搜索结果列表页面
//    [self showSearchResultViews:hotList[button.tag-300]];
    //直接跳转到详情页面
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    detailVC.title = @"详情页面";
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
//点击删除按钮
- (void)deleteAction:(UIButton *)button
{
    [_searchTextField resignFirstResponder];
    [historyList removeObjectAtIndex:button.tag-200];
    [_historyTableView reloadData];
}
//清除搜索历史
- (void)clearHistoryAction:(UIButton *)button
{
    [_searchTextField resignFirstResponder];
    [historyList removeAllObjects];
    [_historyTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
//显示或者隐藏模糊搜索列表
- (void)showSearchTitleList
{
    _searchResultVC.view.hidden = YES;
    if (_searchListVC == nil)
    {
        _searchListVC = [[SearchListViewController alloc]init];
        _searchListVC.delegate = self;
        [self addChildViewController:_searchListVC];
        [self.view addSubview:_searchListVC.view];
        [_searchListVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.searchListVC.view.superview);
            make.top.mas_equalTo(KNavHeight_Sys);
        }];
    }
    _searchListVC.view.hidden = IsStrEmpty(_searchTextField.text)?YES:NO;
    _searchListVC.searchTitle = _searchTextField.text;
    _searchListVC.searchList = searchList;
}
//显示或者隐藏搜索结果
- (void)showSearchResultViews:(NSString *)searchText
{
    [_searchTextField resignFirstResponder];
    _searchListVC.view.hidden = YES;
    _searchTextField.text = searchText;
    [historyList addObject:_searchTextField.text];
    [_historyTableView reloadData];
    [searchBtn setTitle:@"取消" forState:UIControlStateNormal];
    if (_searchResultVC == nil)
    {
        _searchResultVC = [[SearchResultViewController alloc]init];
        _searchResultVC.delegate = self;
        [self addChildViewController:_searchResultVC];
        [self.view addSubview:_searchResultVC.view];
        [_searchResultVC.view mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.left.right.bottom.equalTo(self.searchResultVC.view.superview);
            make.top.mas_equalTo(KNavHeight_Sys);
        }];
    }
    _searchResultVC.searchText = _searchTextField.text;
    _searchResultVC.view.hidden = NO;
}
#pragma mark - Request Data
- (void)requestHistoryData
{
    hotList = [[NSMutableArray alloc]initWithObjects:@"狂犬疫苗问题", @"抖音小姐姐", @"2018 亚运会", @"中美贸易战", @"亚运会男足", nil];
    historyList = [[NSMutableArray alloc]initWithObjects:@"仙鹤门地铁站", @"重庆火锅", @"疯狂的赛车", @"天鹅湖", nil];
    [self initHistoryTableViews];
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
