//
//  LCTitleView.m
//  LCPageView
//
//  Created by 复新会智 on 2018/5/15.
//  Copyright © 2018年 复新会智. All rights reserved.
//

#import "LCTitleView.h"
#import "LCPageView.h"
#import "LCPageContentViewProtocol.h"

@interface LCTitleView () <LCPageContentViewProtocol>

/** 标题视图 */
@property(nonatomic, strong)UIScrollView *titleScrollView;
/** 标题视图的高度 */
@property(nonatomic, assign)CGFloat titleHeight;
/** 当前的index */
@property(nonatomic, assign)NSInteger currentIndex;
/** 标题内容的数组 */
@property(nonatomic, strong)NSArray <UILabel *>*titleLableArray;

@end


@implementation LCTitleView

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray <NSString *>*)titles
                pageViewStyle:(LCPageViewStyle *)pageViewStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
        self.style = pageViewStyle;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)initSuperTitleView
{
    [self initTitleView];
}
- (void)dealloc
{
//    NSLog(@"LCTitleView释放");
}
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    UIView *superV = [self getLCPageViewWithCurrentView:self];
    if ([superV isKindOfClass:[LCPageView class]]) {
        [superV performSelector:@selector(setContentViewDelegate:) withObject:self];
//        LCPageView *v = (LCPageView *)superV;
//        id<LCPageContentViewProtocol> delegate = [v valueForKey:@"contentScrollDelegate"];
//        delegate = self;
//        v.contentScrollDelegate = self;
    }
}

/// 初始化标题
- (void)initTitleView
{
    if (self.titles <= 0) {
        /// 没有子控制器, 抛出异常
        return;
    }
    [self addSubview:self.titleScrollView];
    NSMutableArray <UILabel *>*labels = [NSMutableArray array];
    NSMutableArray *widthArray = [NSMutableArray array];    // 全部的宽度
    __block CGFloat totalWidth; // 总宽度
    __block CGFloat maxWidth;   // 最大宽度
    __weak typeof(self) weakSelf = self;
    [self.titles enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc] init];
        [labels addObject:label];
        label.tag = idx;
        label.text = obj;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:weakSelf.style.titleLabelFont];
        label.userInteractionEnabled = YES;
        label.textColor = idx == 0 ? weakSelf.style.titleLabelSelectColor : weakSelf.style.titleLabelNormalColor;
        label.backgroundColor = idx == 0 ? weakSelf.style.titleLabelSelectBgColor : weakSelf.style.titleLabelNormalBgColor;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(titleLabelDidClick:)]];
        [weakSelf.titleScrollView addSubview:label];
        CGFloat width = [obj boundingRectWithSize:CGSizeMake(MAXFLOAT, weakSelf.style.titleViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:weakSelf.style.titleLabelFont]} context:nil].size.width;
        [widthArray addObject:@(width)];
        totalWidth += width;
        if (width > maxWidth) {
            maxWidth = width;
        }
    }];
    self.titleLableArray = labels;
    CGFloat maxLabelW;
    if (totalWidth <= self.bounds.size.width) {
        /// 如果总宽度小于屏幕的宽度, 就用平均宽度
        maxLabelW = self.bounds.size.width / (CGFloat)labels.count;
    }else {
        /// 如果大于, 就用label的宽度(18 是间距)
        maxLabelW = maxWidth + 18;
    }
    __block CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat W = maxLabelW;
    CGFloat H = self.style.titleViewHeight;
    [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        X = maxLabelW * (CGFloat)idx;
        label.frame = CGRectMake(X, Y, W, H);
    }];
    self.titleScrollView.contentSize = CGSizeMake(CGRectGetMaxX(labels.lastObject.frame), 0);
}
#pragma mark - 事件
/// 点击label
- (void)titleLabelDidClick:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)tap.view;
    if (label.tag == self.currentIndex) {
        return;
    }
    [self changeLabelColor:label.tag];
    [self changeContentPage:@(label.tag)];
}
/// 改变label颜色
- (void)changeLabelColor:(NSInteger)index
{
    
    UILabel *currentLabel = self.titleLableArray[self.currentIndex];
    UILabel *targetLabel = self.titleLableArray[index];
    currentLabel.textColor = self.style.titleLabelNormalColor;
    currentLabel.backgroundColor = self.style.titleLabelNormalBgColor;
    targetLabel.textColor = self.style.titleLabelSelectColor;
    targetLabel.backgroundColor = self.style.titleLabelSelectBgColor;
    self.currentIndex = index;
}
/// 滚动内容
- (void)changeContentPage:(NSNumber *)index
{
    UIView *superV = [self getLCPageViewWithCurrentView:self];
    if ([superV isKindOfClass:[LCPageView class]]) {
        [superV performSelector:@selector(scrollCollectionviewWithIndexNum:) withObject:index];
    }
}
/// 获取superView
- (UIView *)getLCPageViewWithCurrentView:(UIView *)currentView
{
    UIView *superV = [currentView superview];
    if (!superV) {
        return nil;
    }
    if (![superV isKindOfClass:[LCPageView class]]) {
        superV  = [self getLCPageViewWithCurrentView:superV];
    }
    return superV;
}
- (void)scrollCollectionviewWithIndex:(NSInteger)index
{
    [self changeContentPage:@(index)];
}
#pragma mark - 代理方法
/// 即将开始拖拽
- (void)lc_scrollViewWillBeginDragging:(UIScrollView *)scrollView contentViewOffset:(CGPoint)offset contentViewSize:(CGSize)size
{
    [self scrollViewWillBeginDragging:scrollView contentViewOffset:offset contentViewSize:size];
}

/// 已经停止拖拽
- (void)lc_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate contentViewOffset:(CGPoint)offset contentViewSize:(CGSize)size
{
    [self scrollViewDidEndDragging:scrollView willDecelerate:decelerate contentViewOffset:offset contentViewSize:size];
}

/// 已经结束拖拽
- (void)lc_scrollViewDidEndDecelerating:(UIScrollView *)scrollView contentViewOffset:(CGPoint)offset contentViewSize:(CGSize)size
{
    [self scrollViewDidEndDecelerating:scrollView contentViewOffset:offset contentViewSize:size];
    NSInteger index = (NSInteger)(offset.x / size.width);
    [self changeLabelColor:index];
}

/// 已经滚动结束
- (void)lc_scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView contentViewOffset:(CGPoint)offset contentViewSize:(CGSize)size
{
    [self scrollViewDidEndScrollingAnimation:scrollView contentViewOffset:offset contentViewSize:size];
}

/// 正在滚动
- (void)lc_scrollViewDidScroll:(UIScrollView *)scrollView contentViewOffset:(CGPoint)offset contentViewSize:(CGSize)size
{
    [self scrollViewDidScroll:scrollView contentViewOffset:offset contentViewSize:size];
}
#pragma mark - 子类重写的方法
/// 即将开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView contentViewOffset:(CGPoint)offset contentViewSize:(CGSize)size {}

/// 已经停止拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate contentViewOffset:(CGPoint)offset contentViewSize:(CGSize)size {}

/// 已经结束拖拽
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView contentViewOffset:(CGPoint)offset contentViewSize:(CGSize)size {}

/// 已经滚动结束
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView contentViewOffset:(CGPoint)offset contentViewSize:(CGSize)size {}

/// 正在滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView contentViewOffset:(CGPoint)offset contentViewSize:(CGSize)size {}
#pragma mark - getter setter
- (UIScrollView *)titleScrollView
{
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.scrollsToTop = NO;
        _titleScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _titleScrollView;
}
@end
