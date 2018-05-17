//
//  LCTitleView.h
//  LCPageView
//
//  Created by 复新会智 on 2018/5/15.
//  Copyright © 2018年 复新会智. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPageViewStyle.h"


#pragma mark - 标题视图

@interface LCTitleView : UIView 
/** 样式 */
@property(nonatomic, strong)LCPageViewStyle *style;
/** 标题内容数组 */
@property(nonatomic, strong)NSArray <NSString *>*titles;
/// 创建titleView
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray <NSString *>*)titles
                pageViewStyle:(LCPageViewStyle *)pageViewStyle;



/**
 初始化 默认UI, 不调用则不初始化任何UI
 */
- (void)initSuperTitleView;
#pragma mark - 子控制器调用方法

/**
 滚动内容视图

 @param index index
 */
- (void)scrollCollectionviewWithIndex:(NSInteger)index;

#pragma mark - 内容视图滚动的代理方法
/// 即将开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView contentViewOffset:(CGPoint)offset contentViewSize:(CGSize)size;

/// 已经停止拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate contentViewOffset:(CGPoint)offset contentViewSize:(CGSize)size;

/// 已经结束拖拽
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView contentViewOffset:(CGPoint)offset contentViewSize:(CGSize)size;

/// 已经滚动结束
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView contentViewOffset:(CGPoint)offset contentViewSize:(CGSize)size;

/// 正在滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView contentViewOffset:(CGPoint)offset contentViewSize:(CGSize)size;

@end
