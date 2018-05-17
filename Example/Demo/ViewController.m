//
//  ViewController.m
//  LCPageView
//
//  Created by 复新会智 on 2018/5/9.
//  Copyright © 2018年 复新会智. All rights reserved.
//

#import "ViewController.h"
#import "LCPageView.h"
#import "TestViewController1.h"
#import "TestViewController2.h"

#import <objc/runtime.h>

@interface ViewController ()

/** <#注释#> */
@property(nonatomic, strong) LCPageView *pageView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupExample];
    NSLog(@"完成");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    TestViewController2 *vc = [[TestViewController2 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupExample
{
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(150, 100, 120, 35);
    btn1.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn1 setTitle:@"示例1:整体刷新" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor redColor];
    btn1.tag = 1;
    [btn1 addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(150, 170, 120, 35);
    [btn2 setTitle:@"示例2:内部刷新" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor orangeColor];
    btn2.titleLabel.font = [UIFont systemFontOfSize:14];
    btn2.tag = 2;
    [btn2 addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}
- (void)btnDidClick:(UIButton *)btn
{
    if (btn.tag == 1) {
        TestViewController2 *vc = [[TestViewController2 alloc] initWithOverallRefresh:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.tag == 2) {
        TestViewController2 *vc = [[TestViewController2 alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
