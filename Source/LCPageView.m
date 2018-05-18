//
//  LCPageView.m
//  LCPageView
//
//  Created by 复新会智 on 2018/5/9.
//  Copyright © 2018年 复新会智. All rights reserved.
//
/// 标题的高度
#define kPageViewTitleHeight 38


//屏幕尺寸
#define kScreenBounds [UIScreen mainScreen].bounds
//屏幕高度
#define kScreenH [UIScreen mainScreen].bounds.size.height
//屏幕宽度
#define kScreenW [UIScreen mainScreen].bounds.size.width




#import "LCPageView.h"
#import "UIScrollView+Category.h"
#import "UIViewController+Category.h"
#import "LCPageContentViewProtocol.h"


static NSString *const kPageViewCollectionViewCellID = @"kPageViewCollectionViewCellID";

@interface LCPageView ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

/** 内容滚动的代理 */
@property(nonatomic, weak)id<LCPageContentViewProtocol> contentScrollDelegate;

/** 子控制器数组 */
@property(nonatomic, strong)NSArray <UIViewController *>*childControllers;
/** 父控制器 */
@property(nonatomic, weak)UIViewController *parentController;
/** 样式 */
@property(nonatomic, strong)LCPageViewStyle *style;

/** 最底部滚动视图 */
@property(nonatomic, strong)MainScrollView *mainScrollView;
/** <#注释#> */
@property(nonatomic, strong)UIScrollView *outsideScrollView;

/** 主标题视图 */
@property(nonatomic, strong)LCTitleView *titleView;
/** 主标题底部视图(存放主标题视图) */
@property(nonatomic, strong)UIView *titleBottomView;
/** 标题滚动视图 */
@property(nonatomic, strong)UIScrollView *titleScrollView;
/** 标题视图的高度 */
@property(nonatomic, assign)CGFloat titleHeight;
/** 当前的index */
@property(nonatomic, assign)NSInteger currentIndex;
/** 标题内容的数组 */
@property(nonatomic, strong)NSArray <UILabel *>*titleLableArray;

/** 内容视图 */
@property(nonatomic, strong) UICollectionView *contentCollectionView;
/** 内容视图开始滚动位置 */
@property(nonatomic, assign) CGFloat startOffsetX;

/** 头部视图 */
@property(nonatomic, strong) UIView *headView;
/** 头部视图的高度 */
@property(nonatomic, assign)CGFloat headViewHeight;

@end

@implementation LCPageView

- (void)dealloc
{
    for (UIViewController *vc in self.childControllers) {
        vc.lcScrollView.delegate = nil;
    }
//    NSLog(@"LCPageView销毁");
}
#pragma mark - 初始化操作
- (instancetype)initWithFrame:(CGRect)frame
                     headView:(UIView *)headView
             childControllers:(NSArray <UIViewController *>*)childControllers
             parentController:(UIViewController *)parentController
              customTitleView:(LCTitleView *)customTitleView
                pageViewStyle:(LCPageViewStyle *)pageViewStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.headView = headView;
        self.childControllers = childControllers;
        self.parentController = parentController;
        self.style = pageViewStyle;
        [self initHeadView];
        [self initTitleViewWithCustomTitleView:customTitleView];
        [self initContentView];
        
    }
    return self;
}
- (void)initHeadView
{
    if (!self.headView) {
        // 没有头部视图
        return;
    }
    self.headViewHeight = self.headView.frame.size.height;
    [self.mainScrollView addSubview:self.headView];
    self.mainScrollView.contentSize = CGSizeMake(0, self.bounds.size.height + self.headView.bounds.size.height);
}
/// 初始化标题
- (void)initTitleViewWithCustomTitleView:(LCTitleView *)customTitleView
{
    if (self.childControllers.count <= 0) {
        /// 没有子控制器, 抛出异常
        return;
    }
    if (customTitleView) {
        self.titleView = customTitleView;
        [self.titleBottomView addSubview:customTitleView];
    }else {
        NSMutableArray *array = [NSMutableArray array];
        for (UIViewController *vc in self.childControllers) {
            [array addObject:vc.title ? vc.title : @" "];
        }
        self.titleView = [[LCTitleView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.style.titleViewHeight) titles:array pageViewStyle:self.style];
        [self.titleBottomView addSubview:self.titleView];
    }
    if (self.titleView) {
        [self.titleView initSuperTitleView];
    }
}

/// 初始化内容
- (void)initContentView
{
    if (self.parentController == nil) {
        /// 没有父控制器, 抛出异常
        return;
    }
    if (self.childControllers.count <= 0) {
        /// 没有子控制器
        return;
    }
    for (UIViewController *vc in self.childControllers) {
        [self.parentController addChildViewController:vc];
        __weak typeof(self) weakSelf = self;
        /// 确保vc的viewDidload方法执行以后, lcScrollView 才会有值
        if (vc.view) {}
        vc.lcScrollView.scrollHandle = ^(UIScrollView *scrollView) {
            weakSelf.outsideScrollView = scrollView;
            if (weakSelf.mainScrollView.contentOffset.y == 0) {
                if (weakSelf.headViewHeight == 0) {
                    scrollView.showsVerticalScrollIndicator = YES;
                }else {
                    scrollView.showsVerticalScrollIndicator = NO;
                }
            }else if (weakSelf.mainScrollView.contentOffset.y < weakSelf.headViewHeight) {
                scrollView.contentOffset = CGPointZero;
                scrollView.showsVerticalScrollIndicator = NO;
            }else {
                scrollView.showsVerticalScrollIndicator = YES;
            }
        };
        
    }
    [self.mainScrollView insertSubview:self.contentCollectionView belowSubview:self.titleBottomView];
}



#pragma mark - 事件逻辑
- (void)scrollCollectionviewWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.contentCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - titleView  调用的方法
- (void)scrollCollectionviewWithIndexNum:(NSNumber *)index
{
    [self scrollCollectionviewWithIndex:[index integerValue]];
}
- (void)setContentViewDelegate:(id<LCPageContentViewProtocol>)delegate
{
    self.contentScrollDelegate = delegate;
}
#pragma mark - collectionview delegate datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childControllers.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPageViewCollectionViewCellID forIndexPath:indexPath];
    for (UIView *subV in cell.contentView.subviews) {
        [subV removeFromSuperview];
    }
    UIViewController *vc = self.childControllers[indexPath.item];
    vc.view.frame = cell.bounds;
    [cell.contentView addSubview:vc.view];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (UIViewController *vc in self.childControllers) {
        [vc.view endEditing:YES];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = (NSInteger)(self.contentCollectionView.contentOffset.x / self.contentCollectionView.bounds.size.width);
    [self scrollCollectionviewWithIndex:index];
    if ([scrollView isKindOfClass:[self.contentCollectionView class]]) {
        self.contentScrollDelegate ? [self.contentScrollDelegate lc_scrollViewDidEndDecelerating:(UICollectionView *)scrollView] : nil;
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = (NSInteger)(self.contentCollectionView.contentOffset.x / self.contentCollectionView.bounds.size.width);
    [self scrollCollectionviewWithIndex:index];
    
    if ([scrollView isKindOfClass:[self.contentCollectionView class]]) {
        self.contentScrollDelegate ? [self.contentScrollDelegate lc_scrollViewDidEndScrollingAnimation:(UICollectionView *)scrollView] : nil;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isKindOfClass:[self.contentCollectionView class]]) {
        self.contentScrollDelegate ? [self.contentScrollDelegate lc_scrollViewDidEndDragging:(UICollectionView *)scrollView willDecelerate:decelerate] : nil;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[self.contentCollectionView class]]) {
        self.contentScrollDelegate ? [self.contentScrollDelegate lc_scrollViewWillBeginDragging:(UICollectionView *)scrollView] : nil;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.outsideScrollView.contentOffset.y > 0 ||
        scrollView.contentOffset.y > self.headViewHeight) {
        self.mainScrollView.contentOffset = CGPointMake(0, self.headViewHeight);
    }
    if (scrollView.contentOffset.y != 0 && scrollView.contentOffset.y < self.headViewHeight) {
        for (UIViewController *vc in self.childControllers) {
            vc.lcScrollView.contentOffset = CGPointZero;
        }
    }
    if ([scrollView isKindOfClass:[self.contentCollectionView class]]) {
        self.contentScrollDelegate ? [self.contentScrollDelegate lc_scrollViewDidScroll:(UICollectionView *)scrollView] : nil;
    }
    
}
#pragma mark - 懒加载
- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[MainScrollView alloc] initWithFrame:self.bounds];
        _mainScrollView.bounces = NO;
        _mainScrollView.delegate = self;
        _mainScrollView.scrollsToTop = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [self addSubview:_mainScrollView];
    }
    return _mainScrollView;
}
- (UIView *)titleBottomView
{
    if (!_titleBottomView) {
        _titleBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headView.bounds.size.height, self.bounds.size.width, self.style.titleViewHeight)];
        _titleBottomView.backgroundColor = [UIColor clearColor];
        [self.mainScrollView addSubview:_titleBottomView];
    }
    return _titleBottomView;
}
- (UIScrollView *)titleScrollView
{
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.headView.bounds.size.height, self.bounds.size.width, self.style.titleViewHeight)];
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.scrollsToTop = NO;
    }
    return _titleScrollView;
}
- (UICollectionView *)contentCollectionView
{
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGSize size = CGSizeMake(self.bounds.size.width, self.bounds.size.height - self.style.titleViewHeight);
        layout.itemSize = size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGRect frame = CGRectMake(0, CGRectGetMaxY(self.titleBottomView.frame), size.width, size.height);
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        [_contentCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kPageViewCollectionViewCellID];
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.pagingEnabled = YES;
        _contentCollectionView.bounces = NO;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.backgroundColor = [UIColor whiteColor];
        _contentCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _contentCollectionView;
}

@end
