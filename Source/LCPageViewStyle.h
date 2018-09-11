//
//  LCPageViewStyle.h
//  LCPageView
//
//  Created by 陈连辰 on 2018/5/9.
//  Copyright © 2018年 复新会智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCPageViewStyle : NSObject

/** title标题高度 */
@property(nonatomic, assign)CGFloat titleViewHeight;
/** titleLabel的字体大小 */
@property(nonatomic, assign)CGFloat titleLabelFont;
/** titleLabel正常颜色 */
@property(nonatomic, strong)UIColor *titleLabelNormalColor;
/** titleLabel选中颜色 */
@property(nonatomic, strong)UIColor *titleLabelSelectColor;
/** titleLabel正常背景颜色 */
@property(nonatomic, strong)UIColor *titleLabelNormalBgColor;
/** titleLabel选中背景颜色 */
@property(nonatomic, strong)UIColor *titleLabelSelectBgColor;


@end
