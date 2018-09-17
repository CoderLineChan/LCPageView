//
//  LCTitleView.m
//  LCPageView
//
//  Created by lianchen on 2018/5/15.
//  Copyright © 2018年 lianchen. All rights reserved.
//

#import "LCTitleView.h"
#import "LCPageView.h"
#import "UIView+LCFrame.h"

@interface LCTitleView () <LCPageContentViewProtocol>

/** 标题视图 */
@property(nonatomic, strong)UIScrollView *titleScrollView;
/** 标题视图的高度 */
@property(nonatomic, assign)CGFloat titleHeight;
/** 当前的index */
@property(nonatomic, assign)NSInteger currentIndex;
/** 标题内容的数组 */
@property(nonatomic, strong)NSArray <UILabel *>*titleLableArray;
/** 标题内容的数组 */
@property(nonatomic, strong)NSMutableArray <UILabel *>*titleLabels;
/** 存放标题的宽度 */
@property(nonatomic, strong)NSMutableArray *titleWidths;
@property(nonatomic, assign)CGFloat totalWidth;
@property(nonatomic, assign)CGFloat maxWidth;
@property(nonatomic, assign)CGFloat titleMargin;
@property(nonatomic, assign)NSInteger sourceIndex;
@property(nonatomic, assign)NSInteger targetIndex;
@property(nonatomic, assign)NSInteger oldLabelIndex;
@property(nonatomic, assign)CGFloat startOffsetX;
@property(nonatomic, assign)CGFloat didEndOffsetX;
@property(nonatomic, assign)BOOL isWillBeginDragging;
/** <#注释#> */
@property(nonatomic, assign)CGFloat progress;
/** <#注释#> */
@property(nonatomic, assign)NSInteger page;

#pragma mark - 底部指示条相关
@property(nonatomic, weak)UIView *indicatorLine;
@property(nonatomic, strong)UIColor *indicatorColor;
@property(nonatomic, assign)CGFloat indicatorH;


#pragma mark - 颜色相关
@property(nonatomic, assign) CGFloat startR;
@property(nonatomic, assign) CGFloat startG;
@property(nonatomic, assign) CGFloat startB;
@property(nonatomic, assign) CGFloat endR;
@property(nonatomic, assign) CGFloat endG;
@property(nonatomic, assign) CGFloat endB;

#pragma mark - 效果
@property(nonatomic, assign)BOOL isTitleZoom;
@property(nonatomic, assign)BOOL isShowIndicatorLine;
@property(nonatomic, assign)BOOL isShowNoticeView;
@property(nonatomic, assign)BOOL isMillcolorGrad;
@property(nonatomic, assign)BOOL isLineFollowMove;

@end

#define MinTitleMargin 20
#define MinTitleCount 4
@implementation LCTitleView

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray <NSString *>*)titles
                pageViewStyle:(LCPageViewStyle *)pageViewStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
        self.style = pageViewStyle;
        self.backgroundColor = pageViewStyle.titleViewBgColor;
        
        
        [self initConfig];
        [self calculateTitleWidths];
        [self initTitleView];
    }
    return self;
}
- (void)initSuperTitleView
{
    
}
- (void)initConfig
{
//    self.style.bottomLineEnable = YES;
//    self.style.titleZoomEnable = NO;
//    self.style.bottomLineColor = [UIColor redColor];
//    self.style.titleLabelNormalColor = [UIColor lightGrayColor];
//    self.style.titleLabelSelectColor = [UIColor blackColor];
//    self.style.titleLabelNormalBgColor = [UIColor clearColor];
//    self.style.titleLabelSelectBgColor = [UIColor clearColor];
//    self.style.titleZoomMaxScale = 0.1;
//    self.style.titleScrollEnable = NO;
//    self.style.titleMillcolorGradEnable = YES;
    
    [self setupStartColor:self.style.titleLabelNormalColor];
    [self setupEndColor:self.style.titleLabelSelectColor];
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
        SuppressPerformSelectorLeakWarning([superV performSelector:@selector(addDelegate:) withObject:self]);
    }
}

/// 初始化标题
- (void)initTitleView
{
    [self.titleLabels removeAllObjects];
    if (self.titles <= 0) {
        /// 没有子控制器, 抛出异常
        return;
    }
    CGFloat labX = 0;
    CGFloat labY = 0;
    CGFloat labW = 0;
    CGFloat bottomLineH = self.style.bottomLineEnable ? self.style.bottomLineHeight : 0;
    CGFloat labH = self.style.titleViewHeight - bottomLineH;
    [self addSubview:self.titleScrollView];
    for (int i = 0; i < _titles.count; i++) {
        UILabel *label = [[UILabel alloc] init];;
        label.tag = i;
        [label setText:_titles[i]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:self.style.titleLabelFont]];
        [label setTextColor:self.style.titleLabelNormalColor];
        [label setBackgroundColor:self.style.titleLabelNormalBgColor];
        label.userInteractionEnabled = YES;
        if (self.style.isAverageTitleWidth) {
            labW = _maxWidth;
        }else {
            labW = [self.titleWidths[i] integerValue] + _titleMargin * 2;
        }
        label.frame = CGRectMake(labX, labY, labW, labH);
        labX = labX + labW;
        [_titleLabels addObject:label];
        [_titleScrollView addSubview:label];
        if (i == 0) {
            if (self.style.bottomLineEnable) {
                self.indicatorLine.frame = CGRectMake(0, labH - bottomLineH, 0, bottomLineH);
                self.indicatorLine.lc_width = [self.titleWidths[i] integerValue];
                self.indicatorLine.lc_centerX = label.lc_centerX;
            }
            [self setLabelClickTitleState:label];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelDidClick:)];
        [label addGestureRecognizer:tap];
        
    }
    if (self.style.bottomLineEnable) {
        [_titleScrollView bringSubviewToFront:_indicatorLine];
    }
    UILabel *lastLabel = self.titleLabels.lastObject;
    _titleScrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastLabel.frame), labH);
    _titleScrollView.scrollEnabled = self.style.titleScrollEnable;
}

- (void)calculateTitleWidths
{
    CGFloat totalWidth = 0;
    for (NSString *title in _titles) {
        CGFloat textWidth = [self calculateTitleSize:title withMaxSize:CGSizeMake(MAXFLOAT, 0) withTextFont:[UIFont systemFontOfSize:self.style.titleLabelFont]].width;
        if (textWidth > _maxWidth) {
            _maxWidth = textWidth;
        }
        totalWidth += textWidth;
        [self.titleWidths addObject:@(textWidth + 4)];
    }
    if ([self.style isAverageTitleWidth]) {
        _totalWidth = _maxWidth * _titles.count;
        if (_totalWidth <= self.lc_width) {
            /// 如果总宽度小于屏幕的宽度, 就用平均宽度
            _maxWidth = self.lc_width / (CGFloat)_titles.count;
        }else {
            /// 如果大于, 就用label的宽度(18 是间距)
            _maxWidth = _maxWidth + 18;
        }
    }else {
        _totalWidth = totalWidth;
        CGFloat titleMargin = (self.lc_width - totalWidth) / (_titles.count + 1);
        CGFloat totalWidthScale = self.lc_width / kScreenW;
        if (totalWidth > self.lc_width) {
            _titleMargin = MinTitleMargin;
        }else{
            if (_titles.count <= MinTitleCount) {
                _titleMargin = (self.lc_width / _titles.count - _totalWidth * totalWidthScale / _titles.count) / 2;
            }else{
                _titleMargin = titleMargin > MinTitleMargin ? titleMargin : MinTitleMargin;
            }
        }
    }
}
-(CGSize)calculateTitleSize:(NSString *)title withMaxSize:(CGSize)maxSize withTextFont:(UIFont *)font{
    return [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}
#pragma mark - 事件
/// 点击label
- (void)titleLabelDidClick:(UITapGestureRecognizer *)tap
{
    _isWillBeginDragging = NO;
    if (!self.style.isTitleClick) {
        return;
    }
    UILabel *label = (UILabel *)tap.view;
    if (label.tag == self.oldLabelIndex) {
        return;
    }
    NSLog(@"点击标题%@",label);
    [self setLabelClickTitleState:label];
    self.oldLabelIndex = label.tag;
    self.sourceIndex = self.oldLabelIndex;
    self.targetIndex = self.oldLabelIndex;

    [self changeContentPage:@(label.tag)];
}

/**
 点击设置标题的状态
 */
- (void)setLabelClickTitleState:(UILabel *)label{
    [self setLabelTextColor:label];
    [self setLabelTextZoom:label];
    [self setLabelBottomLineScroll:label];
    [self setLabelAutoScroll:label];
    
    self.oldLabelIndex = label.tag;
}

- (void)setLabelTextColor:(UILabel *)lable
{
    UILabel *oldLable = self.titleLabels[self.oldLabelIndex];
    oldLable.textColor = self.style.titleLabelNormalColor;
    lable.textColor = self.style.titleLabelSelectColor;
    
    oldLable.backgroundColor = self.style.titleLabelNormalBgColor;
    lable.backgroundColor = self.style.titleLabelSelectBgColor;
}
- (void)setLabelTextZoom:(UILabel *)lable
{
    if (!self.style.titleZoomEnable) {
        return;
    }
    UILabel *oldLable = self.titleLabels[self.oldLabelIndex];
    oldLable.transform = CGAffineTransformMakeScale(1, 1);
    lable.transform = CGAffineTransformMakeScale(1 + self.style.titleZoomMaxScale, 1 + self.style.titleZoomMaxScale);
    
}
- (void)setLabelAutoScroll:(UILabel *)lable
{
    CGFloat offsetX = lable.center.x - kScreenW * 0.5;
    if (offsetX < 0) {
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - kScreenW;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)setLabelBottomLineScroll:(UILabel *)lable
{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorLine.lc_width = [self.titleWidths[lable.tag] doubleValue];
        self.indicatorLine.lc_centerX = lable.lc_centerX;
    }];
}


/// 滚动内容
- (void)changeContentPage:(NSNumber *)index
{
    UIView *superV = [self getLCPageViewWithCurrentView:self];
    if ([superV isKindOfClass:[LCPageView class]]) {
        SuppressPerformSelectorLeakWarning([superV performSelector:@selector(scrollCollectionviewWithIndexNum:) withObject:index]);
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

#pragma mark - 计算标题的偏移

- (void)calculateTitleScrollDidScroll:(UIScrollView *)scrollView startScrollOffsetX:(CGFloat)startOffsetX endScrollOffsetX:(CGFloat)endOffsetX{
    if (!self.isWillBeginDragging) {
        return;
    }
    
    CGFloat progress = 0.0;
    NSInteger sourceIndex = 0.0;
    NSInteger targetIndex = 0.0;
    CGFloat currenOffsetX = scrollView.contentOffset.x;
    CGFloat scrollWidth = scrollView.frame.size.width;
//    NSLog(@"currenOffsetX:%f", currenOffsetX);
    if (startOffsetX < currenOffsetX) { // 左滑
        progress = currenOffsetX / scrollWidth - floor(currenOffsetX / scrollWidth);
        sourceIndex = (NSInteger)currenOffsetX / scrollWidth;
        
        targetIndex = sourceIndex + 1;
        if (targetIndex >= self.titles.count) {
            targetIndex = self.titles.count - 1;
        }
        if (currenOffsetX - startOffsetX == scrollWidth) {
            progress = 1;
            targetIndex = sourceIndex;
        }
//        NSLog(@"左滑sourceIndex:%ld, targetIndex:%ld", sourceIndex, targetIndex);
    }else if (startOffsetX > currenOffsetX){  // 右滑
        progress = 1 - (currenOffsetX / scrollWidth - floor(currenOffsetX / scrollWidth));
        targetIndex = (NSInteger)currenOffsetX / scrollWidth;
        sourceIndex = targetIndex + 1;
        if (sourceIndex >= self.titles.count) {
            sourceIndex = self.titles.count - 1;
        }
        if (currenOffsetX - startOffsetX == scrollWidth) {
            progress = 1;
            sourceIndex = targetIndex;
        }
//        NSLog(@"右滑sourceIndex:%ld, targetIndex:%ld", sourceIndex, targetIndex);
    }else {                                 // 在中间
        sourceIndex = self.oldLabelIndex;
        targetIndex = sourceIndex;
        progress = 1;
    }
    CGFloat score = (currenOffsetX / scrollWidth);
    NSInteger temp = (NSInteger)score;
    if (score == temp) {
        if (temp != self.page) {
            
            progress = 1;
        }
        self.page = temp;
        
    }
//    NSLog(@"最终++sourceIndex:%ld, targetIndex:%ld", sourceIndex, targetIndex);
    self.sourceIndex = sourceIndex;
    self.targetIndex = targetIndex;
    [self titleBarScrollProgres:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    
}
- (void)titleBarScrollProgres:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex{
    if (self.style.titleMillcolorGradEnable) {
        [self setTitleColorGradienWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    }
    if (self.style.titleZoomEnable) {
        [self setTitleZoomScaleProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    }
    if (self.style.bottomLineEnable) {
        [self setLineFollowMoveScaleProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    }
    
    if (progress == 1) {
        UILabel *label = self.titleLabels[sourceIndex];
        [self setLabelAutoScroll:label];
//        self.oldLabelIndex = targetIndex;
    }
    
}



- (CGFloat)getTitleDistanceWithSourceLabel:(NSInteger)sourceLabel targetLabel:(NSInteger)targetLabel{
    CGFloat titleTargetW = [self.titleWidths[targetLabel] floatValue];
    CGFloat titleSourceW = [self.titleWidths[sourceLabel] floatValue];
    return titleTargetW - titleSourceW;
}
/**
 设置底部线跟着移动
 */
- (void)setLineFollowMoveScaleProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex{
    UILabel *sourceLabel = self.titleLabels[sourceIndex];
    UILabel *targetLabel = self.titleLabels[targetIndex];
    CGFloat sourceTitleW = [self.titleWidths[sourceIndex] floatValue];
    CGFloat targetTitleW = [self.titleWidths[targetIndex] floatValue];
    CGFloat moveTotalX = targetLabel.lc_centerX - sourceLabel.lc_centerX;
    CGFloat moveX = moveTotalX * progress;
    CGFloat moveTotalW = targetTitleW - sourceTitleW;
    CGFloat moveW = moveTotalW * progress;
    self.indicatorLine.lc_width = sourceTitleW + moveW;
    self.indicatorLine.lc_centerX = sourceLabel.lc_centerX + moveX;
//    if (!self.isClickTitle) {
//    }
}

/**
 设置标题大小缩放
 */
- (void)setTitleZoomScaleProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex{
    UILabel *sourceLabel = self.titleLabels[sourceIndex];
    UILabel *targetLabel = self.titleLabels[targetIndex];
    CGFloat sourceScale = 1 - progress;
    sourceLabel.transform = CGAffineTransformMakeScale(sourceScale * self.style.titleZoomMaxScale + 1, sourceScale * self.style.titleZoomMaxScale + 1);
    targetLabel.transform = CGAffineTransformMakeScale(progress * self.style.titleZoomMaxScale + 1, progress * self.style.titleZoomMaxScale + 1);
}

/**
 设置标题颜色渐变
 */
- (void)setTitleColorGradienWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex{
    CGFloat r = _endR - _startR;
    CGFloat g = _endG - _startG;
    CGFloat b = _endB - _startB;
    UIColor *sourceColor = [UIColor colorWithRed:_endR - r * progress green:_endG - g * progress blue:_endB - b * progress alpha:1];
    UIColor *targetColor = [UIColor colorWithRed:_startR + r * progress green:_startG + g * progress blue:_startB + b * progress alpha:1];
    UILabel *sourceLabel = self.titleLabels[sourceIndex];
    UILabel *targetLabel = self.titleLabels[targetIndex];
    sourceLabel.textColor = sourceColor;
    targetLabel.textColor = targetColor;
}
// 获取两个标题按钮宽度差值
- (CGFloat)widthDeltaWithTargetLabel:(UILabel *)targetLabel sourceLabel:(UILabel *)sourceLabel {
    CGFloat titleTargetW = [self.titleWidths[targetLabel.tag] floatValue];
    CGFloat titleSourceW = [self.titleWidths[sourceLabel.tag] floatValue];
    return titleTargetW - titleSourceW;
}
// 获取label里面title的X值
- (CGFloat)getLabelTitleX:(UILabel *)label {
    CGFloat titleWidth = [self.titleWidths[label.tag] floatValue];
    return (label.lc_width - titleWidth) * 0.5;
}

#pragma mark - 代理方法
/// 即将开始拖拽
- (void)lc_scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self collectionViewWillBeginDragging:(UICollectionView *)scrollView];
    _startOffsetX = scrollView.contentOffset.x;
    _isWillBeginDragging = YES;
    
}

/// 已经停止拖拽
- (void)lc_scrollViewDidEndDragging:(UICollectionView *)collectionView willDecelerate:(BOOL)decelerate
{
    [self collectionViewDidEndDragging:collectionView willDecelerate:decelerate];
//    NSInteger index = (NSInteger)(collectionView.contentOffset.x / collectionView.bounds.size.width);
}

/// 已经结束拖拽
- (void)lc_scrollViewDidEndDecelerating:(UICollectionView *)collectionView
{
    [self collectionViewDidEndDecelerating:collectionView];
    NSInteger index = (NSInteger)(collectionView.contentOffset.x / collectionView.bounds.size.width);
    self.didEndOffsetX = collectionView.contentOffset.x;
    [self calculateTitleScrollDidScroll:(UIScrollView *)collectionView startScrollOffsetX:_startOffsetX endScrollOffsetX:_didEndOffsetX];
    NSLog(@"oldIndex:%ld, index:%ld", self.oldLabelIndex, index);
    [self setLabelClickTitleState:self.titleLabels[index]];
    
}

/// 已经滚动结束
- (void)lc_scrollViewDidEndScrollingAnimation:(UICollectionView *)collectionView
{
    [self collectionViewDidEndScrollingAnimation:collectionView];
}

/// 正在滚动
- (void)lc_scrollViewDidHorizontalScroll:(UIScrollView *)scrollView
{
    [self collectionViewDidScroll:(UICollectionView *)scrollView];
    [self calculateTitleScrollDidScroll:scrollView startScrollOffsetX:_startOffsetX endScrollOffsetX:_didEndOffsetX];
}

#pragma mark - 子类重写的方法
/**
 正在滚动
 
 @param collectionView 内容滚动视图
 */
- (void)collectionViewDidScroll:(UICollectionView *)collectionView {}

/// 即将开始拖拽
- (void)collectionViewWillBeginDragging:(UICollectionView *)collectionView {}

/// 已经停止拖拽
- (void)collectionViewDidEndDragging:(UICollectionView *)collectionView willDecelerate:(BOOL)decelerate {}

/// 已经结束拖拽
- (void)collectionViewDidEndDecelerating:(UICollectionView *)collectionView {}

/// 已经滚动结束
- (void)collectionViewDidEndScrollingAnimation:(UICollectionView *)collectionView {}


#pragma mark - getter setter
- (void)setupStartColor:(UIColor *)color
{
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    _startR = components[0];
    _startG = components[1];
    _startB = components[2];
}

- (void)setupEndColor:(UIColor *)color
{
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    _endR = components[0];
    _endG = components[1];
    _endB = components[2];
}
- (UIScrollView *)titleScrollView
{
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.scrollsToTop = NO;
        _titleScrollView.backgroundColor = [UIColor clearColor];
    }
    return _titleScrollView;
}

/**
 *  滚动指示条
 */
- (UIView *)indicatorLine {
    if (!_indicatorLine) {
        UIView *indicatorLine = [[UIView alloc] init];
        _indicatorLine = indicatorLine;
        indicatorLine.backgroundColor = self.style.bottomLineColor;
        [self.titleScrollView addSubview:_indicatorLine];
    }
    return _indicatorLine;
}
/**
 *  存放每个标题的字体宽度
 */
- (NSMutableArray *)titleWidths {
    if (!_titleWidths) {
        _titleWidths = [NSMutableArray array];
    }
    return _titleWidths;
}
/**
 *  存放标题
 */
- (NSMutableArray *)titleLabels {
    if (!_titleLabels) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}


#pragma mark - 固定视图的高度
-(void)layoutSubviews{
    [super layoutSubviews];
    //    self.lc_height = LCTitleBarH;
}




/**
 *  指定颜色，获取颜色的RGB值
 *
 *  @param components RGB数组
 *  @param color      颜色
 */
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 1);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}


@end
