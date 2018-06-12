//
//  LCHeadView.m
//  Example
//
//  Created by 陈连辰 on 2018/6/11.
//  Copyright © 2018年 linechan. All rights reserved.
//

#import "LCHeadView.h"
#import "LCPageView.h"
#import "LCPageContentViewProtocol.h"

@interface LCHeadView ()

/** <#注释#> */
@property(nonatomic, weak)UIView *superV;

@end

@implementation LCHeadView

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    UIView *superV = [self getLCPageViewWithCurrentView:self];
    if ([superV isKindOfClass:[LCPageView class]]) {
        self.superV = superV;
        [superV addObserver:self forKeyPath:@"mainScrollView.contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"mainScrollView.contentOffset"]) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        [self headViewDidScroll:offset];
    }
}

- (void)dealloc
{
    [self.superV removeObserver:self forKeyPath:@"mainScrollView.contentOffset"];
    NSLog(@"LCHeadView - dealloc");
}
- (void)headViewDidScroll:(CGPoint)offset{}
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
