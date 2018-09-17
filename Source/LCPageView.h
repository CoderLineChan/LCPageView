//
//  LCPageView.h
//  LCPageView
//
//  Created by lianchen on 2018/5/9.
//  Copyright © 2018年 lianchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPageViewStyle.h"
#import "MainScrollView.h"
#import "LCTitleView.h"
#import "LCHeadView.h"
#import "UIViewController+Category.h"
#import "LCPageViewProtocol.h"

@interface LCPageView : UIView

/**
 最底部滚动视图
 主要用于整个PageView添加下拉刷新功能
 bounces 默认为NO
 */
@property(nonatomic, strong, readonly)MainScrollView *mainScrollView;

/**
 初始化一个pageView
 使用注意(重要): 需要在内容控制器里面把主滚动视图赋值给 lcScrollView
               例如:  self.lcScrollView = self.tableView;

 @param frame frame
 @param headView 头部视图
 @param childControllers 内容控制器(需要设置控制器的title)
 @param parentController 当前控制器
 @param customTitleView 自定义标题的View
 @param pageViewStyle pageView的样式(有默认的样式)
 @return pageView
 */
- (instancetype)initWithFrame:(CGRect)frame
                     headView:(LCHeadView *)headView
             childControllers:(NSArray <UIViewController *>*)childControllers
             parentController:(UIViewController *)parentController
              customTitleView:(LCTitleView *)customTitleView
                pageViewStyle:(id <LCPageViewStyleProtocol>)pageViewStyle;


@end
