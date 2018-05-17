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
- (void)lc_scrollViewWillBeginDragging:(UIScrollView *)scrollView contentViewOffset:(CGPoint)offset contentViewSize:(CGSize)size;

/// 已经停止拖拽
- (void)lc_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate contentViewOffset:(CGPoint)offset contentViewSize:(CGSize)size;

/// 已经结束拖拽
- (void)lc_scrollViewDidEndDecelerating:(UIScrollView *)scrollView contentViewOffset:(CGPoint)offset contentViewSize:(CGSize)size;

/// 已经滚动结束
- (void)lc_scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView contentViewOffset:(CGPoint)offset contentViewSize:(CGSize)size;

/// 正在滚动
- (void)lc_scrollViewDidScroll:(UIScrollView *)scrollView contentViewOffset:(CGPoint)offset contentViewSize:(CGSize)size;


@end
