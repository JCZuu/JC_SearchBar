//
//  SearchResultViewController.m
//  JCSearchBar
//
//  Created by 祝国庆 on 2018/8/17.
//  Copyright © 2018年 qixinpuhui. All rights reserved.
//

#import "SearchResultViewController.h"
#import "Header.h"
@interface SearchResultViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray      *dataArray;
}
@property (nonatomic, strong) UITableView *tabelView;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc]init];
    [self initMainViews];
}
//
- (void)setSearchText:(NSString *)searchText
{
    if (_searchText != searchText)
    {
        _searchText = searchText;
    }
    [self requestData];
}
//初始图主视图
- (void)initMainViews
{
    [self.view addSubview:self.tabelView];
    [self.tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.tabelView.superview);
    }];
    if (@available(iOS 11.0, *)) {
        _tabelView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
#pragma mark - 表视图
- (UITableView *)tabelView
{
    if (!_tabelView)
    {
        _tabelView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.backgroundColor = [UIColor whiteColor];
    }
    return _tabelView;
}
#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idetifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idetifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [NSString stringWithFormat:@"第%zi行搜索内容：%@", indexPath.row + 1, dataArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(pushToNewsDetailPage:)])
    {
        [self.delegate pushToNewsDetailPage:nil];
    }
}
//高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
//cell 高亮状态
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = COLOR_C3__;
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}
#pragma mark - Request Data
- (void)requestData
{
    dataArray = [[NSMutableArray alloc]init];
    int count = arc4random() % 15;
    for (int i=0; i < count; i++)
    {
        NSString *str = [NSString stringWithFormat:@"%@搜索搜索顶顶顶顶", _searchText];
        [dataArray addObject:str];
    }
    [self.tabelView reloadData];
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
