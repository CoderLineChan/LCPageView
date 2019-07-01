//
//  UIScrollView+Category.h
//  LCPageView
//
//  Created by 陈连辰 on 2018/5/12.
//  Copyright © 2018年 复新会智. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LCScrollHandle)(UIScrollView *);

@interface UIScrollView (Category)
/** 滚动代理 */
@property(nonatomic, copy) LCScrollHandle scrollHandle;
@end
