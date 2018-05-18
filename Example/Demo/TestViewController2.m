//
//  TestViewController2.m
//  LCPageView
//
//  Created by 复新会智 on 2018/5/14.
//  Copyright © 2018年 复新会智. All rights reserved.
//


/// 标题的高度
#define kPageViewTitleHeight 38

///导航高度
#define kNavH (kScreenH == 812.0 ? 88 : 64)

//屏幕尺寸
#define kScreenBounds [UIScreen mainScreen].bounds
//屏幕高度
#define kScreenH [UIScreen mainScreen].bounds.size.height
//屏幕宽度
#define kScreenW [UIScreen mainScreen].bounds.size.width

#import "TestViewController2.h"
#import "LCPageView.h"
#import "TestViewController3.h"
#import "TestTitleView.h"
//#import <MJRefresh/MJRefresh.h>


@interface TestViewController2 ()
/** <#注释#> */
@property(nonatomic, strong) LCPageView *pageView;

/** <#describe#> */
@property(nonatomic, assign)BOOL isOverall;
@end

@implementation TestViewController2
- (instancetype)initWithOverallRefresh:(BOOL)isOverall;
{
    self = [super init];
    if (self) {
        self.isOverall = isOverall;
    }
    return self;
}

- (void)dealloc
{
//    NSLog(@"TestViewController2销毁");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self testPageView];
}
- (void)testPageView
{
    NSArray *titles = @[@"测试&测试1", @"测试&测试2", @"主页", @"我的"];
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *title in titles) {
        TestViewController3 *vc = [[TestViewController3 alloc] init];
        vc.title = title;
        [array addObject:vc];
    }
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor redColor];
    headView.frame = CGRectMake(0, 0, kScreenW, 150);
    
    LCPageViewStyle *style = [[LCPageViewStyle alloc] init];
    
    CGRect frame = CGRectMake(0, 64, kScreenW, kScreenH - 64);
    /// 自定义标题
    TestTitleView *titleView = [[TestTitleView alloc] initWithFrame:CGRectMake(0,0, kScreenW, 38) titles:titles pageViewStyle:style];
    [titleView initSuperTitleView];
    
    /// 主pageView
    self.pageView = [[LCPageView alloc] initWithFrame:frame headView:headView childControllers:array parentController:self customTitleView:titleView pageViewStyle:style];
    
    /// 是否开启整体bounces/刷新
    self.pageView.mainScrollView.bounces = self.isOverall;
    if (self.isOverall) {
//        __weak typeof(self) weakSelf = self;
//        self.pageView.mainScrollView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//            NSLog(@"开启刷新");
//            [weakSelf endRefresh];
//        }];
    }
    [self.view addSubview:self.pageView];
}

- (void)endRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"结束刷新");
//        [self.pageView.mainScrollView.mj_header endRefreshing];
    });
}

@end
