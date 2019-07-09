//
//  LCPageView.m
//  LCPageView
//
//  Created by lianchen on 2018/5/9.
//  Copyright © 2018年 lianchen. All rights reserved.
//

#import "LCPageView.h"
#import "UIScrollView+Category.h"
#import "UIView+LCFrame.h"


static NSString *const kPageViewCollectionViewCellID = @"kPageViewCollectionViewCellID";

@interface LCPageView ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout>
/** 子控制器数组 */
@property(nonatomic, strong)NSArray <UIViewController *>*childControllers;
/** 父控制器 */
@property(nonatomic, weak)UIViewController *parentController;
/** 样式 */
@property(nonatomic, strong)id <LCPageViewStyleProtocol>style;
/** 最底部滚动视图 */
@property(nonatomic, strong)MainScrollView *mainScrollView;
/** 外面传进来的主滚动视图 */
@property(nonatomic, strong)UIScrollView *outsideScrollView;
/** 主标题视图 */
@property(nonatomic, strong)LCTitleView *titleView;
/** 主标题底部视图(存放主标题视图) */
@property(nonatomic, strong)UIView *titleBottomView;
/** 标题视图的高度 */
@property(nonatomic, assign)CGFloat titleHeight;
/** 当前的index */
@property(nonatomic, assign)NSInteger currentIndex;
/** 标题内容的数组 */
@property(nonatomic, strong)NSArray <UILabel *>*titleLableArray;
/** 内容视图 */
@property(nonatomic, strong)UICollectionView *contentCollectionView;
/** 头部视图 */
@property(nonatomic, strong)UIView *headView;
/** 头部视图的高度 */
@property(nonatomic, assign)CGFloat headViewHeight;
/** CollectionView ContentSize */
@property (nonatomic, assign)CGSize collectionViewCellSize;
@end

@implementation LCPageView
{
    /** 内容滚动的代理 */
    NSPointerArray* _delegates;
}

- (void)dealloc
{
    for (UIViewController *vc in self.childControllers) {
        vc.lcScrollView.delegate = nil;
    }
    //    NSLog(@"LCPageView销毁");
    [self removeAllDelegates];
}
#pragma mark - 接口
/**
 更新pageView的高度
 */
- (void)updatePageViewHeight:(CGFloat)height
{
    CGRect frame = CGRectMake(0, 0, self.lc_width, height);
    [self updatePageViewFrame:frame];
}
/**
 更新pageView的Frame
 */
- (void)updatePageViewFrame:(CGRect)frame
{
    self.frame = frame;
    self.mainScrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    CGFloat Y = self.titleBottomView.lc_bottom;
    if ([self titleViewHeight] == 0) {
        Y = self.headView.lc_bottom;
    }
    self.collectionViewCellSize = CGSizeMake(frame.size.width, frame.size.height - [self titleViewHeight]);
    self.contentCollectionView.frame = CGRectMake(0, Y, self.collectionViewCellSize.width, self.collectionViewCellSize.height);
    [self.contentCollectionView reloadData];
}

- (void)moveToIndex:(NSInteger)index
{
    [self.titleView scrollCollectionviewWithIndex:index];
    [self scrollViewDidEndDecelerating:self.contentCollectionView];
}
/**
 更新标题内容
 */
- (void)updatePageViewTitles:(NSArray <NSString *>*)titles
{
    if (!titles) {
        return;
    }
    [self.titleView updateTitles:titles];
}
#pragma mark - 初始化操作
- (instancetype)initWithFrame:(CGRect)frame
                     headView:(UIView *)headView
             childControllers:(NSArray <UIViewController *>*)childControllers
             parentController:(UIViewController *)parentController
              customTitleView:(LCTitleView *)customTitleView
                pageViewStyle:(id <LCPageViewStyleProtocol>)pageViewStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _delegates = [NSPointerArray weakObjectsPointerArray];
        self.headView = headView;
        self.childControllers = childControllers;
        self.parentController = parentController;
        self.style = pageViewStyle;
        self.collectionViewCellSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height - [self titleViewHeight]);
        [self initHeadView];
        [self initTitleViewWithCustomTitleView:customTitleView];
        [self initContentView];
        
    }
    return self;
}
- (void)initHeadView
{
    if (!self.headView || self.headView.bounds.size.height == 0) {
        // 没有头部视图
        self.mainScrollView.bounces = NO;
        return;
    }
    self.mainScrollView.bounces = YES;
    self.headViewHeight = self.headView.frame.size.height;
    [self.mainScrollView addSubview:self.headView];
    self.mainScrollView.contentSize = CGSizeMake(0, self.headView.bounds.size.height);
}
/// 初始化标题
- (void)initTitleViewWithCustomTitleView:(LCTitleView *)customTitleView
{
    if (self.childControllers.count <= 0) {
        /// 没有子控制器, 抛出异常
        return;
    }
    if (customTitleView) {
        if (self.titleViewHeight > 0) {
            self.titleView = customTitleView;
            [self.titleBottomView addSubview:customTitleView];
        }
    }else {
        NSMutableArray *array = [NSMutableArray array];
        for (UIViewController *vc in self.childControllers) {
            NSString *title = vc.title ? : vc.navigationItem.title;
            [array addObject:title ? : @" "];
        }
        self.titleView = [[LCTitleView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.titleViewHeight) titles:array pageViewStyle:self.style];
        [self.titleBottomView addSubview:self.titleView];
    }
}

/// 初始化内容
- (void)initContentView
{
    if (self.parentController == nil) {
        /// 没有父控制器, 抛出异常
        return;
    }
    if (self.childControllers.count == 0) {
        /// 没有子控制器
        return;
    }
    for (UIViewController *vc in self.childControllers) {
        [self.parentController addChildViewController:vc];
        __weak typeof(self) weakSelf = self;
        /// 确保vc的viewDidload方法执行以后, lcScrollView 才会有值
        if (vc.view) {}
        vc.automaticallyAdjustsScrollViewInsets = NO;
        /// 确保子控制器第一次加载的时候执行viewWillAppear:方法
        [vc beginAppearanceTransition:YES animated:YES];
        /// 外面scrollview的滚动方法
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
            [weakSelf limitMainScrollViewContentSize:scrollView];
        };
    }
    [self.mainScrollView insertSubview:self.contentCollectionView belowSubview:self.titleBottomView];
}



#pragma mark - 事件逻辑
/// 滚动(多次调用)
- (void)scrollCollectionviewWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.contentCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

#pragma mark - titleView  代理方法
- (void)scrollCollectionviewWithIndexNum:(NSNumber *)index
{
    [self scrollCollectionviewWithIndex:[index integerValue]];
    UIViewController *vc = self.childControllers[index.integerValue];
    [self limitMainScrollViewContentSize:vc.lcScrollView];
    /// 里面的ScrollView滚到最前面
    for (UIViewController *vc in self.childControllers) {
        vc.lcScrollView.contentOffset = CGPointZero;
    }
    /// 代理传到外面
    if ([self.delegate respondsToSelector:@selector(pageView:moveToIndex:)]) {
        [self.delegate pageView:self moveToIndex:index.integerValue];
    }
}
#pragma mark - collectionview delegate datasource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.collectionViewCellSize;
}
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
    vc.view.frame = cell.contentView.bounds;/// 这里因为层级深, frame布局不够准确
    [cell.contentView addSubview:vc.view];
//    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(cell.contentView);
//    }];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (UIViewController *vc in self.childControllers) {
        [vc.view endEditing:YES];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollCollectionviewWithIndex:[self getCurrentSelectIndex]];
    if ([scrollView isKindOfClass:[self.contentCollectionView class]]) {
        [self performDelegateWithSel:@selector(lc_scrollViewDidEndDecelerating:) withObject:(UICollectionView *)scrollView];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollCollectionviewWithIndex:[self getCurrentSelectIndex]];
    
    if ([scrollView isKindOfClass:[self.contentCollectionView class]]) {
        [self performDelegateWithSel:@selector(lc_scrollViewDidEndScrollingAnimation:) withObject:(UICollectionView *)scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isKindOfClass:[self.contentCollectionView class]]) {
        SuppressPerformSelectorLeakWarning([self performDelegateWithSel:@selector(lc_scrollViewDidEndDragging:) withObject1:(UICollectionView *)scrollView withobject2:@(decelerate)]);
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[self.contentCollectionView class]]) {
        [self performDelegateWithSel:@selector(lc_scrollViewWillBeginDragging:) withObject:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /// 限制主滚动视图滚动范围
    [self limitMainScrollViewContentOffset:scrollView];
    
    /// 代理
    if ([scrollView isKindOfClass:[self.contentCollectionView class]]) {
        [self performDelegateWithSel:@selector(lc_scrollViewDidHorizontalScroll:) withObject:scrollView];
    }else {
        [self performDelegateWithSel:@selector(lc_scrollViewDidVerticalScroll:) withObject:scrollView];
    }
}
#pragma mark - private
/// 限制主scrollView的ContentOffset
- (void)limitMainScrollViewContentOffset:(UIScrollView *)scrollView
{
    /// 限制主滚动视图滚动范围
    UIViewController *vc = self.childControllers[[self getCurrentSelectIndex]];
    if ([self.outsideScrollView isEqual:vc.lcScrollView]) {
        if (self.outsideScrollView.contentOffset.y > 50 || scrollView.contentOffset.y > self.headViewHeight) {
            self.mainScrollView.contentOffset = CGPointMake(0, self.headViewHeight);
        }
    }else {
        if (scrollView.contentOffset.y > 50 || scrollView.contentOffset.y > self.headViewHeight) {
            self.mainScrollView.contentOffset = CGPointMake(0, self.headViewHeight);
        }
    }
}
///限制主滚动视图的contentSize
- (void)limitMainScrollViewContentSize:(UIScrollView *)scrollView
{
    if (scrollView.contentSize.height < (self.lc_height - self.headViewHeight - self.titleViewHeight)) {
        self.mainScrollView.contentSize = CGSizeMake(0, scrollView.contentSize.height + self.headViewHeight + self.titleViewHeight);
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else {
        self.mainScrollView.contentSize = CGSizeMake(self.lc_width, scrollView.contentSize.height + self.headView.lc_height + self.titleViewHeight);
    }
}
/// 获取当前显示的控制器索引
- (NSInteger)getCurrentSelectIndex
{
    NSInteger index = (NSInteger)(self.contentCollectionView.contentOffset.x / self.contentCollectionView.bounds.size.width);
    return index;
}
/// 获取标题的高度
- (CGFloat)titleViewHeight
{
    CGFloat height = self.style.titleViewHeight;
    if (self.childControllers.count == 1) {
        if (self.style.titleHiddenForOneController) {
            height = 0;
        }
    }
    return height;
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
        if (@available(iOS 11.0, *)) {
            _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _mainScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_mainScrollView];
    }
    return _mainScrollView;
}
- (UIView *)titleBottomView
{
    if (!_titleBottomView) {
        _titleBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headView.bounds.size.height, self.bounds.size.width, self.titleViewHeight)];
        [self.mainScrollView addSubview:_titleBottomView];
        _titleBottomView.backgroundColor = self.style.titleViewBgColor;
    }
    return _titleBottomView;
}

- (UICollectionView *)contentCollectionView
{
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGSize size = CGSizeMake(self.bounds.size.width, self.bounds.size.height - self.titleViewHeight);
        //        layout.itemSize = size;
        layout.estimatedItemSize = CGSizeMake(0, 0);
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
        _contentCollectionView.scrollEnabled = self.style.contentViewScrollEnabled;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
            _contentCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _contentCollectionView;
}


#pragma mark - LCMultiDelegate
- (void)addDelegate:(id<LCPageContentViewProtocol>)delegate {
    [_delegates addPointer:(__bridge void*)delegate];
}
- (void)removeDelegate:(id<LCPageContentViewProtocol>)delegate {
    NSUInteger index = [self indexOfDelegate:delegate];
    if (index != NSNotFound)
        [_delegates removePointerAtIndex:index];
    [_delegates compact];
}
- (void)removeAllDelegates {
    for (NSUInteger i = _delegates.count; i > 0; i -= 1)
        [_delegates removePointerAtIndex:i - 1];
}
- (void)performDelegateWithSel:(SEL)sel withObject:(id)object
{
    for (NSUInteger i = 0; i < _delegates.count; i += 1) {
        id delegate = [_delegates pointerAtIndex:i];
        if ([delegate respondsToSelector:sel]) {
            SuppressPerformSelectorLeakWarning1([delegate performSelector:sel withObject:object]);
        }
    }
}
- (void)performDelegateWithSel:(SEL)sel withObject1:(id)object1 withobject2:(id)onject2
{
    for (NSUInteger i = 0; i < _delegates.count; i += 1) {
        id delegate = [_delegates pointerAtIndex:i];
        if ([delegate respondsToSelector:sel]) {
            SuppressPerformSelectorLeakWarning1([delegate performSelector:sel withObject:object1 withObject:onject2]);
        }
    }
}
- (NSUInteger)indexOfDelegate:(id)delegate {
    for (NSUInteger i = 0; i < _delegates.count; i += 1) {
        if ([_delegates pointerAtIndex:i] == (__bridge void*)delegate) {
            return i;
        }
    }
    return NSNotFound;
}
- (BOOL)respondsToSelector:(SEL)selector {
    if ([super respondsToSelector:selector])
        return YES;
    for (id delegate in _delegates) {
        if (delegate && [delegate respondsToSelector:selector])
            return YES;
    }
    return NO;
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (signature)
        return signature;
    
    [_delegates compact];
    if (_delegates.count == 0) {
        return [self methodSignatureForSelector:@selector(description)];
    }
    for (id delegate in _delegates) {//存储了各个对象的代理
        if (!delegate)
            continue;
        signature = [delegate methodSignatureForSelector:selector];
        if (signature)
            break;
    }
    return signature;
}
- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL selector = [invocation selector];
    BOOL responded = NO;
    for (id delegate in _delegates) {
        if (delegate && [delegate respondsToSelector:selector]) {
            [invocation invokeWithTarget:delegate];
            responded = YES;
        }
    }
    if (!responded)
        [self doesNotRecognizeSelector:selector];
}

@end
