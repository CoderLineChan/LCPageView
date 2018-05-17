//
//  UIViewController+Category.m
//  LCPageView
//
//  Created by 陈连辰 on 2018/5/12.
//  Copyright © 2018年 复新会智. All rights reserved.
//

#import "UIViewController+Category.h"
#import <objc/runtime.h>
#import "UIScrollView+Category.h"

#define lcScrollViewKey @"lcScrollViewKey"

@implementation UIViewController (Category)


- (void)setLcScrollView:(UIScrollView *)lcScrollView
{
    objc_setAssociatedObject(self, lcScrollViewKey, lcScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIScrollView *)lcScrollView
{
    return objc_getAssociatedObject(self, lcScrollViewKey);
}

@end
