//
//  UIView+LCFrame.h
//  各种分类
//
//  Created by 陈连辰 on 16/8/10.
//  Copyright © 2016年 linechen. All rights reserved.
//

#import <UIKit/UIKit.h>
//屏幕尺寸
#define kScreenBounds [UIScreen mainScreen].bounds
//屏幕高度
#define kScreenH [UIScreen mainScreen].bounds.size.height
//屏幕宽度
#define kScreenW [UIScreen mainScreen].bounds.size.width

/// 消除警告
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wundeclared-selector\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

/// 消除警告
#define SuppressPerformSelectorLeakWarning1(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)



@interface UIView (LCFrame)

@property (nonatomic, assign) CGSize lc_size;
@property (nonatomic, assign) CGFloat lc_x;
@property (nonatomic, assign) CGFloat lc_y;
@property (nonatomic, assign) CGFloat lc_width;
@property (nonatomic, assign) CGFloat lc_height;
@property (nonatomic, assign) CGFloat lc_centerX;
@property (nonatomic, assign) CGFloat lc_centerY;

/** 控件最右边线的位置(最大的X值) */
@property (nonatomic, assign) CGFloat lc_right;
/** 控件最左边线的位置(控件的X值) */
@property (nonatomic, assign) CGFloat lc_left;
/** 控件最顶部线的位置(控件的Y值) */
@property (nonatomic, assign) CGFloat lc_top;
/** 控件最底部线的位置(最大的Y值) */
@property (nonatomic, assign) CGFloat lc_bottom;

/// 设置圆角
- (void)lc_setCornerRadiusWithRadius:(CGFloat)radius;

@end
