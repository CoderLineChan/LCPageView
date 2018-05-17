//
//  UIScrollView+Category.m
//  LCPageView
//
//  Created by 陈连辰 on 2018/5/12.
//  Copyright © 2018年 复新会智. All rights reserved.
//

#import "UIScrollView+Category.h"
#import <objc/runtime.h>


#define LCScrollHandleKey @"scrollHandle"


@interface UIScrollView ()


@end

@implementation UIScrollView (Category)

- (void)scrollDidScroll
{
    [self scrollDidScroll];
    self.scrollHandle ? self.scrollHandle(self) : nil;
}
- (LCScrollHandle)scrollHandle
{
    return objc_getAssociatedObject(self, LCScrollHandleKey);
}
- (void)setScrollHandle:(LCScrollHandle)scrollHandle
{
    objc_setAssociatedObject(self, LCScrollHandleKey, scrollHandle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (void)load
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        SEL originSel = @selector(_notifyDidScroll);
        SEL newSel = @selector(scrollDidScroll);
        [self associationScrollWethodWithClass:[self class] originSel:originSel associationSel:newSel];
    });
}
+ (void)associationScrollWethodWithClass:(Class)cls
                               originSel:(SEL)originSel
                          associationSel:(SEL)associationSel
{
    Method originMethod = class_getInstanceMethod(cls, originSel);
    Method associationMethod = class_getInstanceMethod(cls, associationSel);
    
    BOOL isSucceed = class_addMethod(cls, originSel, method_getImplementation(associationMethod), method_getTypeEncoding(associationMethod));
    if (isSucceed) {
        class_replaceMethod(cls, associationSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }else {
        method_exchangeImplementations(originMethod, associationMethod);
    }
}
@end
