//
//  LCPageViewStyle.m
//  LCPageView
//
//  Created by 陈连辰 on 2018/5/9.
//  Copyright © 2018年 lianchen. All rights reserved.
//

#import "LCPageViewStyle.h"

@interface LCPageViewStyle ()


@end

@implementation LCPageViewStyle
{
    CGFloat _titleViewHeight;
    CGFloat _titleLabelFont;
    /** 标题视图背景颜色 */
    UIColor *_titleViewBgColor;
    /** titleLabel正常颜色 */
    UIColor *_titleLabelNormalColor;
    /** titleLabel选中颜色 */
    UIColor *_titleLabelSelectColor;
    /** titleLabel正常背景颜色 */
    UIColor *_titleLabelNormalBgColor;
    /** titleLabel选中背景颜色 */
    UIColor *_titleLabelSelectBgColor;
    /** 是否平均标题的宽度 */
    BOOL _isAverageTitleWidth;
    /** 标题滚动功能 */
    BOOL _titleScrollEnable;
    /** 是否能点击标题 */
    BOOL _isTitleClick;
    /** 是否启用缩放 */
    BOOL _titleZoomEnable;
    /** 是否隐藏标题,当只有一个子控制器的时候 */
    BOOL _titleHiddenForOneController;
    /** 缩放大小0~1 */
    CGFloat _titleZoomMaxScale;
    /** 是否启用底部线 */
    BOOL _bottomLineEnable;
    /** 底部线颜色 */
    UIColor *_bottomLineColor;
    /** 底部线高度 */
    CGFloat _bottomLineHeight;
    /** 是否启用颜色渐变 */
    BOOL _titleMillcolorGradEnable;
    /** 标题label超过长度忽略方式 */
    NSLineBreakMode _labelLineBreakMode;
    /** 内容视图是否能滚动 */
    BOOL _contentViewScrollEnabled;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _titleViewHeight = 42;
        _titleLabelFont = 15;
        _titleViewBgColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
        _titleLabelNormalColor = [UIColor lightTextColor];
        _titleLabelSelectColor = [UIColor blackColor];
        _titleLabelNormalBgColor = [UIColor clearColor];
        _titleLabelSelectBgColor = [UIColor clearColor];
        _isAverageTitleWidth = NO;
        _titleScrollEnable = YES;
        _isTitleClick = YES;
        _titleZoomEnable = NO;
        _titleZoomMaxScale = 0.1;
        _bottomLineEnable = NO;
        _bottomLineColor = [UIColor redColor];
        _bottomLineHeight = 2;
        _titleMillcolorGradEnable = NO;
    }
    return self;
}


- (void)initNormalStyle
{
    _isAverageTitleWidth = YES;
    _titleLabelNormalColor = [UIColor whiteColor];
    _titleLabelSelectColor = [UIColor blackColor];
    _titleLabelNormalBgColor = [UIColor blueColor];
    _titleLabelSelectBgColor = [UIColor lightGrayColor];
    _titleScrollEnable = NO;
}
- (void)initDefaulStyle
{
    //    _titleViewBgColor = [UIColor whiteColor];
    _titleLabelNormalColor = [UIColor lightGrayColor];
    _titleLabelSelectColor = [UIColor blackColor];
    _titleLabelNormalBgColor = [UIColor clearColor];
    _titleLabelSelectBgColor = [UIColor clearColor];
    _titleScrollEnable = YES;
}
- (void)initGradientStyle
{
    _titleViewBgColor = [UIColor clearColor];
    _titleLabelNormalColor = [UIColor lightGrayColor];
    _titleLabelSelectColor = [UIColor blackColor];
    _titleLabelNormalBgColor = [UIColor clearColor];
    _titleLabelSelectBgColor = [UIColor clearColor];
    _titleScrollEnable = YES;
    _bottomLineEnable = YES;
    _titleMillcolorGradEnable = YES;
}
#pragma mark - 标题的属性
- (CGFloat)titleViewHeight
{
    return _titleViewHeight;
}
- (CGFloat)titleLabelFont
{
    return _titleLabelFont;
}
- (UIColor *)titleLabelNormalColor
{
    return _titleLabelNormalColor;
}
- (UIColor *)titleLabelSelectColor
{
    return _titleLabelSelectColor;
}
- (UIColor *)titleLabelNormalBgColor
{
    return _titleLabelNormalBgColor;
}
- (UIColor *)titleLabelSelectBgColor
{
    return _titleLabelSelectBgColor;
}
- (BOOL)isAverageTitleWidth
{
    return _isAverageTitleWidth;
}
- (BOOL)titleScrollEnable
{
    return _titleScrollEnable;
}
- (BOOL)isTitleClick
{
    return _isTitleClick;
}
- (UIColor *)titleViewBgColor
{
    return _titleViewBgColor;
}
#pragma mark - 标题缩放功能
- (BOOL)titleZoomEnable
{
    return _titleZoomEnable;
}
- (CGFloat)titleZoomMaxScale
{
    return _titleZoomMaxScale;
}
- (BOOL)titleHiddenForOneController
{
    return _titleHiddenForOneController;
}
#pragma mark - 底部线功能
- (BOOL)bottomLineEnable
{
    return _bottomLineEnable;
}
- (UIColor *)bottomLineColor
{
    return _bottomLineColor;
}
- (CGFloat)bottomLineHeight
{
    return _bottomLineHeight;
}
#pragma mark - 颜色渐变
- (BOOL)titleMillcolorGradEnable
{
    return _titleMillcolorGradEnable;
}

- (NSLineBreakMode)labelLineBreakMode
{
    return _labelLineBreakMode;
}
- (BOOL)contentViewScrollEnabled
{
    return _contentViewScrollEnabled;
}
@end
