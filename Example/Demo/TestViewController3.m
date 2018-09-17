//
//  TestViewController3.m
//  LCPageView
//
//  Created by lianchen on 2018/5/16.
//  Copyright © 2018年 lianchen. All rights reserved.
//

#import "TestViewController3.h"
//#import <MJRefresh/MJRefresh.h>
//#import "UIViewController+Category.h"
#import "TestViewController2.h"
#import "LCPageView.h"

@interface TestViewController3 ()<UITableViewDelegate, UITableViewDataSource>

/** <#describe#> */
@property(nonatomic, strong)UITableView *tableView;

@end

@implementation TestViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lcScrollView = self.tableView;
    
    self.view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
//    __weak typeof(self) weakSelf = self;
//    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//        [weakSelf endRefresh];
//    }];
}

- (void)endRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"结束刷新");
//        [self.tableView.mj_header endRefreshing];
    });
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"2222"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"2222"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"测试数据:%ld", indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TestViewController2 *vc = [[TestViewController2 alloc] init];
    vc.title = @"示例2:内部刷新";
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"Controller3 OffsetY:%.2f", scrollView.contentOffset.y);
}

@end
