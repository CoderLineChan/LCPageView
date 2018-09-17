//
//  UIView+LCFrame.m
//  各种分类
//
//  Created by 陈连辰 on 16/8/10.
//  Copyright © 2016年 linechen. All rights reserved.
//

#import "UIView+LCFrame.h"


@implementation UIView (LCFrame)
- (CGFloat)lc_x {
    return self.frame.origin.x;
}

- (void)setLc_x:(CGFloat)lc_x {
    CGRect frame = self.frame;
    frame.origin.x = lc_x;
    self.frame = frame;
}

- (CGFloat)lc_y {
    return self.frame.origin.y;
}

- (void)setLc_y:(CGFloat)lc_y{
    CGRect frame = self.frame;
    frame.origin.y = lc_y;
    self.frame = frame;
}

- (CGFloat)lc_width {
    return  self.frame.size.width;
}

- (void)setLc_width:(CGFloat)lc_width {
    CGRect frame = self.frame;
    frame.size.width = lc_width;
    self.frame = frame;
}

- (CGFloat)lc_height {
    return self.frame.size.height;
}

- (void)setLc_height:(CGFloat)lc_height {
    CGRect frame = self.frame;
    frame.size.height = lc_height;
    self.frame = frame;
}

- (void)setLc_size:(CGSize)lc_size {
    CGRect frame = self.frame;
    frame.size = lc_size;
    self.frame = frame;
}


- (CGSize)lc_size {
    return self.frame.size;
}

- (void)setLc_centerX:(CGFloat)lc_centerX {
    CGPoint center = self.center;
    center.x = lc_centerX;
    self.center = center;
}

- (CGFloat)lc_centerX {
    return self.center.x;
}

- (void)setLc_centerY:(CGFloat)lc_centerY {
    CGPoint center = self.center;
    center.y = lc_centerY;
    self.center = center;
}

- (CGFloat)lc_centerY {
    return self.center.y;
}

- (void)setLc_right:(CGFloat)lc_right {
    CGRect frame = self.frame;
    frame.origin.x = lc_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)lc_right {
    return CGRectGetMaxX(self.frame);
}

- (void)setLc_left:(CGFloat)lc_left {
    self.lc_x = lc_left;
}
- (CGFloat)lc_left {
    return self.lc_x;
}

- (void)setLc_bottom:(CGFloat)lc_bottom {
    CGRect frame = self.frame;
    frame.origin.y = lc_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)lc_bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setLc_top:(CGFloat)lc_top {
    self.lc_y = lc_top;
}

- (CGFloat)lc_top {
    return self.lc_y;
}


- (void)lc_setCornerRadiusWithRadius:(CGFloat)radius
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
@end
