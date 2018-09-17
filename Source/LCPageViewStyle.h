//
//  LCPageViewStyle.h
//  LCPageView
//
//  Created by 陈连辰 on 2018/5/9.
//  Copyright © 2018年 lianchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPageViewProtocol.h"

@interface LCPageViewStyle : NSObject<LCPageViewStyleProtocol>
/**
 普通模式:没有任何特效
 背景平均填满整个TitleView
 只有字体与背景各两种颜色
 */
- (void)initNormalStyle;

/**
 默认模式
 */
- (void)initDefaulStyle;

/**
 渐变模式
 */
- (void)initGradientStyle;

@end
