//
//  LCPageViewStyle.m
//  LCPageView
//
//  Created by 陈连辰 on 2018/5/9.
//  Copyright © 2018年 复新会智. All rights reserved.
//

#import "LCPageViewStyle.h"

@implementation LCPageViewStyle


- (CGFloat)titleViewHeight
{
    if (_titleViewHeight <= 0) {
        _titleViewHeight = 38;
    }
    return _titleViewHeight;
}
- (CGFloat)titleLabelFont
{
    if (_titleLabelFont <= 5) {
        _titleLabelFont = 14;
    }
    return _titleLabelFont;
}
- (UIColor *)titleLabelNormalColor
{
    if (_titleLabelNormalColor == nil) {
        _titleLabelNormalColor = [UIColor whiteColor];
    }
    return _titleLabelNormalColor;
}
- (UIColor *)titleLabelNormalBgColor
{
    if (_titleLabelNormalBgColor == nil) {
        _titleLabelNormalBgColor = [UIColor darkGrayColor];
    }
    return _titleLabelNormalBgColor;
}

- (UIColor *)titleLabelSelectColor
{
    if (_titleLabelSelectColor == nil) {
        _titleLabelSelectColor = [UIColor blackColor];
    }
    return _titleLabelSelectColor;
}
- (UIColor *)titleLabelSelectBgColor
{
    if (_titleLabelSelectBgColor == nil) {
        _titleLabelSelectBgColor = [UIColor blueColor];
    }
    return _titleLabelSelectBgColor;
}
@end
