//
//  MainScrollView.m
//  LCPageView
//
//  Created by 陈连辰 on 2018/5/13.
//  Copyright © 2018年 lianchen. All rights reserved.
//

#import "MainScrollView.h"

@interface MainScrollView ()<UIGestureRecognizerDelegate>


@end

@implementation MainScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer
{
    return ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] &&
            [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]);
}

@end
