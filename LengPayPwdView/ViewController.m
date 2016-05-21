//
//  ViewController.m
//  LengPayPwdView
//
//  Created by 冷求慧 on 16/5/21.
//  Copyright © 2016年 gdd. All rights reserved.
//

#import "ViewController.h"
#import "PayPwdView.h"
@interface ViewController ()<PayPwdViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)action:(UIButton *)sender {
    PayPwdView *myPayPwdView=[[PayPwdView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:myPayPwdView];
    myPayPwdView.delegate=self;
}
#pragma mark -支付视图的Delegate
// 每次输入的密码
-(void)eachInputPwd:(PayPwdView *)payView eachClickPwd:(NSString *)eachClickPwd{
    NSLog(@"这次输入的是:%@",eachClickPwd);
}
// 最终的密码(点击了确认按钮才回调用这个方法)
-(void)finaInputPwd:(PayPwdView *)payView surePwd:(NSString *)surePwd{
    NSLog(@"最终的密码是:%@",surePwd);
}
@end
