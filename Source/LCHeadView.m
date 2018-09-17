//
//  LCHeadView.m
//  Example
//
//  Created by lianchen on 2018/5/18.
//  Copyright © 2018年 linechan. All rights reserved.
//

#import "LCHeadView.h"
#import "LCPageView.h"
#import "UIView+LCFrame.h"

@interface LCHeadView ()


@end

@implementation LCHeadView


- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    UIView *superV = [self getLCPageViewWithCurrentView:self];
    if ([superV isKindOfClass:[LCPageView class]]) {
        SuppressPerformSelectorLeakWarning([superV performSelector:@selector(addDelegate:) withObject:self]);
    }
}



#pragma mark - 代理方法
/// 正在滚动
- (void)lc_scrollViewDidVerticalScroll:(UIScrollView *)scrollView
{
    [self headViewDidScroll:scrollView];
}

- (void)headViewDidScroll:(UIScrollView *)scrollview{}

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
@end
