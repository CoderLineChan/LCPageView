//
//  LCTitleView.h
//  LCPageView
//
//  Created by lianchen on 2018/5/15.
//  Copyright © 2018年 lianchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPageViewStyle.h"


#pragma mark - 标题视图

@interface LCTitleView : UIView
/** 样式 */
@property(nonatomic, strong)id <LCPageViewStyleProtocol>style;
/** 标题内容数组 */
@property(nonatomic, strong, readonly)NSArray <NSString *>*titles;

#pragma mark - 接口
/// 创建titleView
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray <NSString *>*)titles
                pageViewStyle:(id <LCPageViewStyleProtocol>)pageViewStyle;

/**
 更新标题内容
 */
- (void)updateTitles:(NSArray <NSString *>*)titles;

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

#pragma mark - 内容视图滚动的代理方法(子类重写)

/**
 正在滚动
 
 @param collectionView 内容滚动视图
 */
- (void)collectionViewDidScroll:(UICollectionView *)collectionView;

/// 即将开始拖拽
- (void)collectionViewWillBeginDragging:(UICollectionView *)collectionView;

/// 已经停止拖拽
- (void)collectionViewDidEndDragging:(UICollectionView *)collectionView willDecelerate:(BOOL)decelerate;

/// 已经结束拖拽
- (void)collectionViewDidEndDecelerating:(UICollectionView *)collectionView;

/// 已经滚动结束
- (void)collectionViewDidEndScrollingAnimation:(UICollectionView *)collectionView;



@end
