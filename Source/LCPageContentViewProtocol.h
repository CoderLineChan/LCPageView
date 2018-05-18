//
//  LCPageContentViewProtocol.h
//  LCPageView
//
//  Created by 复新会智 on 2018/5/15.
//  Copyright © 2018年 复新会智. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCPageContentViewProtocol <NSObject>

/// 即将开始拖拽
- (void)lc_scrollViewWillBeginDragging:(UICollectionView *)collectionView;

/// 已经停止拖拽
- (void)lc_scrollViewDidEndDragging:(UICollectionView *)collectionView willDecelerate:(BOOL)decelerate;

/// 已经结束拖拽
- (void)lc_scrollViewDidEndDecelerating:(UICollectionView *)collectionView;

/// 已经滚动结束
- (void)lc_scrollViewDidEndScrollingAnimation:(UICollectionView *)collectionView;

/// 正在滚动
- (void)lc_scrollViewDidScroll:(UICollectionView *)collectionView;


@end
