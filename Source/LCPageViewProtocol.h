//
//  LCPageViewProtocol.h
//  Example
//
//  Created by 陈连辰 on 2018/9/16.
//  Copyright © 2018年 linechan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCPageContentViewProtocol <NSObject>

#pragma mark - 滚动代理
/// 即将开始拖拽
- (void)lc_scrollViewWillBeginDragging:(UIScrollView *)scrollView;

/// 已经停止拖拽
- (void)lc_scrollViewDidEndDragging:(UICollectionView *)collectionView willDecelerate:(BOOL)decelerate;

/// 已经结束拖拽
- (void)lc_scrollViewDidEndDecelerating:(UICollectionView *)collectionView;

/// 已经滚动结束
- (void)lc_scrollViewDidEndScrollingAnimation:(UICollectionView *)collectionView;

/// 水平滚动
- (void)lc_scrollViewDidHorizontalScroll:(UIScrollView *)scrollView;

/// 垂直滚动
- (void)lc_scrollViewDidVerticalScroll:(UIScrollView *)scrollView;


@end


@protocol LCPageViewStyleProtocol <NSObject>
#pragma mark - 标题的属性
/** title标题高度 */
- (CGFloat)titleViewHeight;
/** titleLabel的字体大小 */
- (CGFloat)titleLabelFont;
/** 标题视图背景颜色 */
- (UIColor *)titleViewBgColor;
/** titleLabel正常颜色 */
- (UIColor *)titleLabelNormalColor;
/** titleLabel选中颜色 */
- (UIColor *)titleLabelSelectColor;
/** titleLabel正常背景颜色 */
- (UIColor *)titleLabelNormalBgColor;
/** titleLabel选中背景颜色 */
- (UIColor *)titleLabelSelectBgColor;
/** 是否平均标题的宽度 */
- (BOOL)isAverageTitleWidth;
/** 标题滚动功能 */
- (BOOL)titleScrollEnable;
/** 是否能点击标题 */
- (BOOL)isTitleClick;
#pragma mark - 标题缩放功能
/** 是否启用缩放 */
- (BOOL)titleZoomEnable;
/** 缩放大小0~1 */
- (CGFloat)titleZoomMaxScale;
/** 是否隐藏标题,当只有一个子控制器的时候 */
- (BOOL)titleHiddenForOneController;
#pragma mark - 底部线功能
/** 是否启用底部线 */
- (BOOL)bottomLineEnable;
/** 底部线颜色 */
- (UIColor *)bottomLineColor;
/** 底部线高度 */
- (CGFloat)bottomLineHeight;
#pragma mark - 颜色渐变
/** 是否启用颜色渐变 */
- (BOOL)titleMillcolorGradEnable;
/** 标题label超过长度忽略方式 */
- (NSLineBreakMode)labelLineBreakMode;

/** 内容视图是否能滚动 */
- (BOOL)contentViewScrollEnabled;

@end
