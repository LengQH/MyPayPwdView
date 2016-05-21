//
//  PayPwdView.h
//  ParkedCars
//
//  Created by 冷求慧 on 16/5/4.
//  Copyright © 2016年 gdd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  PayPwdView;
@protocol PayPwdViewDelegate <NSObject>
@required
/**
 *  最终输入的密码
 *
 *  @param payView PayPwdView对象
 *  @param surePwd 最终的密码
 */
-(void)finaInputPwd:(PayPwdView *)payView surePwd:(NSString *)surePwd;
/**
 *  每次输入的密码
 *
 *  @param payView      PayPwdView对象
 *  @param eachClickPwd 每次输入的密码
 */
-(void)eachInputPwd:(PayPwdView *)payView eachClickPwd:(NSString *)eachClickPwd;
@end
@interface PayPwdView : UIView
@property (nonatomic,weak)id<PayPwdViewDelegate> delegate;  
@end
