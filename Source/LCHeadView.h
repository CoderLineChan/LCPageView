//
//  LCHeadView.h
//  Example
//
//  Created by lianchen on 2018/5/18.
//  Copyright © 2018年 linechan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCHeadView : UIView


/// 子类重写获取offset方法
- (void)headViewDidScroll:(UIScrollView *)scrollview;

@end
