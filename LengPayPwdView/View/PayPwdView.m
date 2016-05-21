//
//  PayPwdView.m
//  ParkedCars
//
//  Created by 冷求慧 on 16/5/4.
//  Copyright © 2016年 gdd. All rights reserved.
//


#import "PayPwdView.h"
#import "MBProgressHUD+MJ.h"

#define screenWidthW      [[UIScreen mainScreen] bounds].size.width
#define screenHeightH     [[UIScreen mainScreen] bounds].size.height
#define cusColor(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define sureColor         cusColor(46,147,221, 1.0)      // 选中的颜色
#define sureBGColor       cusColor(222, 222, 222, 1.0) // 固定的背景颜色
#define cusFont(font)     [UIFont systemFontOfSize:font]


#define Iphone4                  screenWidthW==320&&screenHeightH==480

#define showSetPayPwdNil         @"请您设置支付密码"
#define showSetPayPwdError       @"设置支付密码错误"
#define showSetPayPwdSuccess     @"设置支付密码成功"


#define leftDistance 24        // 左边距
#define labelTopDistance  6   // 上边距
#define secLabelH 12          // 第二个label的高度
#define lineLeftDistance 8
#define pwdDistance 1       // 密码的边距

#define cirImageWH 24      // 黑色图片的宽高


#define keyBoardH   200           //键盘的高度
#define keyBoardButtonDistance 4 // 键盘按钮边距
#define rowNumWithRow  3        // 键盘每一行的个数

@interface PayPwdView (){
    UIView *bg;
    NSInteger clickNum;
    NSString *strFinaPwd;
    NSArray *arrKeyboardNum;
}
@property (nonatomic,strong) NSMutableArray *arrAddPwd; // 添加密码视图
@property (nonatomic,strong) UIView *kbView;
@end
@implementation PayPwdView
-(NSMutableArray *)arrAddPwd{
    if (_arrAddPwd==nil) {
        _arrAddPwd=[NSMutableArray array];
    }
    return _arrAddPwd;
}
#pragma mark xib 类关联的时候调用
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [self createUI];
        [self createCustomKeyboard];
    }
    return self;
}
#pragma mark init的时候调用
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self createUI]; // 创建相关UI
        [self createCustomKeyboard]; // 创建自定义键盘
    }
    return self;
}
#pragma mark 创建相关的UI
-(void)createUI{
    
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];  // 设置透明
    bg=[[UIView alloc] initWithFrame:CGRectMake(0,0,screenWidthW,screenHeightH)]; //蒙版视图的Frame
    
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc] init];
    CGRect maskRect=CGRectMake(0,0,screenWidthW,screenHeightH); //蒙版所有遮住的W和H
    CGMutablePathRef path=CGPathCreateMutable();
    CGPathAddRect(path, nil, maskRect);
    [maskLayer setPath:path];
    CGPathRelease(path);
    bg.layer.mask = maskLayer;
    [self addSubview:bg];
    
    UIView *showView=[[UIView alloc]initWithFrame:CGRectMake(leftDistance, screenHeightH/2-screenHeightH/4/2, screenWidthW-leftDistance*2, screenHeightH/4)];
    [bg addSubview:showView];
//    showView.sd_layout.leftSpaceToView(bg,leftDistance).rightSpaceToView(bg,leftDistance).centerYEqualToView(bg).heightIs(screenHeightH/4); // 自己原项目中使用的第三方布局框架:SDAutoLayout 建议开发者使用,不比Masonry差
    [showView setBackgroundColor:[UIColor whiteColor]];
    showView.layer.cornerRadius=5.0;
    showView.layer.masksToBounds=YES;
    
    UILabel *labelTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidthW-leftDistance*2, screenHeightH/4/6)];
    [showView addSubview:labelTitle];
//    labelTitle.sd_layout.leftSpaceToView(showView,0).rightSpaceToView(showView,0).topSpaceToView(showView,labelTopDistance).heightIs(screenHeightH/4/6);
    labelTitle.text=@"请设置支付密码";
    labelTitle.font=cusFont(15);
    labelTitle.textAlignment=NSTextAlignmentCenter;
    
    
    UILabel *labelSmallTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, screenHeightH/4/6+labelTopDistance, screenWidthW-leftDistance*2, secLabelH)];
    [showView addSubview:labelSmallTitle];
    labelSmallTitle.textAlignment=NSTextAlignmentCenter;
//    labelSmallTitle.sd_layout.leftSpaceToView(showView,0).rightSpaceToView(showView,0).topSpaceToView(labelTitle,labelTopDistance).heightIs(secLabelH);
    labelSmallTitle.text=@"消费和充值需要验证此密码";
    labelSmallTitle.font=cusFont(10);
    labelSmallTitle.textColor=[UIColor darkGrayColor];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(labelTopDistance, screenHeightH/4/6+labelTopDistance+secLabelH+4, screenWidthW-leftDistance*2-labelTopDistance*2, 1)];
    [showView addSubview:lineView];
//    lineView.sd_layout.leftSpaceToView(showView,lineLeftDistance).rightSpaceToView(showView,lineLeftDistance).topSpaceToView(labelSmallTitle,4).heightIs(1);
    lineView.backgroundColor=sureBGColor;
    
    CGFloat pwdViewY=screenHeightH/4/6+labelTopDistance+secLabelH+4+labelTopDistance+4;
    CGFloat pwdViewH=screenHeightH/4/4;
    UIView *pwdView=[[UIView alloc]initWithFrame:CGRectMake(labelTopDistance, pwdViewY, screenWidthW-leftDistance*2-labelTopDistance*2,pwdViewH)];
    [showView addSubview:pwdView];
    [pwdView setBackgroundColor:sureBGColor];
//    pwdView.sd_layout.leftEqualToView(lineView).rightEqualToView(lineView).topSpaceToView(lineView,labelTopDistance+4).heightIs(screenHeightH/4/4);
    pwdView.layer.cornerRadius=3.0;
    pwdView.layer.masksToBounds=YES;
    pwdView.layer.borderWidth=1.0;
    pwdView.layer.borderColor=[[UIColor darkGrayColor]CGColor];

    CGFloat imageW=((screenWidthW-leftDistance*2-labelTopDistance*2)-pwdDistance*5)/6;
    CGFloat imageDistance=0;
    for (int i=0; i<6; i++) {
        UIView *cirBGView=[[UIView alloc]initWithFrame:CGRectMake((imageW+pwdDistance)*i, imageDistance, imageW, pwdViewH)];
        [cirBGView setBackgroundColor:[UIColor whiteColor]];
//        [cirBGView setBackgroundColor:arcColor]; // 测试的随机颜色
        [pwdView addSubview:cirBGView];
        UIImageView *pwdImage=[[UIImageView alloc]initWithFrame:CGRectMake(imageW/2-cirImageWH/2, pwdViewH/2-cirImageWH/2,cirImageWH,cirImageWH)];
        [cirBGView addSubview:pwdImage];
        pwdImage.contentMode=UIViewContentModeCenter;
        [self.arrAddPwd addObject:pwdImage];
        pwdImage.contentMode=UIViewContentModeScaleAspectFit;
        
        pwdImage.userInteractionEnabled=YES;
        UITapGestureRecognizer *myTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inputPwdAction)];
        [pwdImage addGestureRecognizer:myTap];
    }
    CGFloat buttonW=((screenWidthW-leftDistance*2-labelTopDistance*2)-pwdDistance)/2;
    UIButton *cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(labelTopDistance, pwdViewY+pwdViewH+lineLeftDistance/2, buttonW,screenHeightH/4-pwdViewY-pwdViewH)];
    [showView addSubview:cancelButton];
//    cancelButton.sd_layout.leftEqualToView(pwdView).topSpaceToView(pwdView,0).bottomSpaceToView(showView,0).widthIs(buttonW);
    [cancelButton addTarget:self action:@selector(cancelAcion:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateHighlighted];

    UIButton *sureButton=[[UIButton alloc]initWithFrame:CGRectMake(labelTopDistance+buttonW+pwdDistance, pwdViewY+pwdViewH+lineLeftDistance/2, buttonW, screenHeightH/4-pwdViewY-pwdViewH)];
    [showView addSubview:sureButton];
//    sureButton.sd_layout.leftSpaceToView(cancelButton,pwdDistance).rightSpaceToView(showView,0).topSpaceToView(pwdView,0).bottomSpaceToView(showView,0);
    [sureButton addTarget:self action:@selector(sureAcion:) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitle:@"确定" forState:UIControlStateHighlighted];
    
    if (Iphone4) {
        cancelButton.titleLabel.font=cusFont(13);
        sureButton.titleLabel.font=cusFont(13);
    }
}
#pragma mark  点击图片输入密码的操作(创建自定义键盘)
-(void)inputPwdAction{
//    [self createCustomKeyboard];
}
#pragma mark 取消操作
-(void)cancelAcion:(UIButton *)sender{
    [self removeFromSuperview];
}
#pragma mark 确定操作(确定才传值)
-(void)sureAcion:(UIButton *)sender{
    if(strFinaPwd.length==6&&clickNum==6){
        if ([self.delegate respondsToSelector:@selector(finaInputPwd:surePwd:)]) {  // 确定才传值
            [self.delegate finaInputPwd:self surePwd:strFinaPwd];
        }
        [MBProgressHUD showSuccess:showSetPayPwdSuccess];
        [self removeFromSuperview];
    }
    else{
        if (strFinaPwd.length==0) {
            [MBProgressHUD showError:showSetPayPwdNil];
        }
        else{
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@,只设置了%zi个密码",showSetPayPwdError,strFinaPwd.length]];
        }
    }
}
#pragma mark  创建自定义的键盘
-(void)createCustomKeyboard{
    strFinaPwd=@"";
    UIView *keyboardView=[[UIView alloc]initWithFrame:CGRectMake(0, screenHeightH-keyBoardH, screenWidthW, keyBoardH)];
    [bg addSubview:keyboardView];
    self.kbView=keyboardView;
//    keyboardView.sd_layout.leftSpaceToView(bg,0).rightSpaceToView(bg,0).bottomSpaceToView(bg,0).heightIs(keyBoardH);
    [keyboardView setBackgroundColor:[UIColor darkGrayColor]];
//    keyboardView.layer.cornerRadius=5.0;
//    keyboardView.layer.masksToBounds=YES;
    
    CGFloat buttonW=(screenWidthW-keyBoardButtonDistance*(rowNumWithRow-1))/rowNumWithRow; // 按钮的宽度
    CGFloat buttonH=(keyBoardH-keyBoardButtonDistance*rowNumWithRow)/(rowNumWithRow+1);   // 按钮的高德
    
    arrKeyboardNum=@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"清空",@"X"]; //题外话:这里用的是大写的字母 X 并不是数学中的乘以符号x
    for(int i=0;i<arrKeyboardNum.count;i++){
        NSInteger rowNum=i/rowNumWithRow;
        NSInteger colNum=i%rowNumWithRow;
        
        UIButton *keyboardBtn=[[UIButton alloc]initWithFrame:CGRectMake((buttonW+keyBoardButtonDistance)*colNum, (buttonH+keyBoardButtonDistance)*rowNum, buttonW, buttonH)];
        keyboardBtn.tag=i;
        [keyboardView addSubview:keyboardBtn];
        [keyboardBtn setBackgroundColor:[UIColor whiteColor]];
        [keyboardBtn setTitle:arrKeyboardNum[i] forState:UIControlStateNormal];
        [keyboardBtn setTitle:arrKeyboardNum[i] forState:UIControlStateHighlighted];
        [keyboardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [keyboardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [keyboardBtn addTarget:self action:@selector(clickButtonWithKeyboard:) forControlEvents:UIControlEventTouchUpInside];
//        keyboardBtn.layer.cornerRadius=5.0;
//        keyboardBtn.layer.masksToBounds=YES;
    }
}
#pragma mark 点击了键盘上的按钮
-(void)clickButtonWithKeyboard:(UIButton *)sender{
    NSString *btnTitle=sender.titleLabel.text; //得到Button上面的Title
    if([btnTitle isEqualToString:[arrKeyboardNum lastObject]]){ // 删除按钮
        if (clickNum>=0&&strFinaPwd.length>0) {
            strFinaPwd=[strFinaPwd substringToIndex:strFinaPwd.length-1];
            clickNum-=1;
            [self addPwdImage];
        }
    }
    else if ([btnTitle isEqualToString:arrKeyboardNum[10]]) { // 清空按钮
        strFinaPwd=@"";
        clickNum=0;
        for (int i=0; i<self.arrAddPwd.count; i++) {
            UIImageView *imageView=self.arrAddPwd[i];
            imageView.image=nil;
        }
    }
    else{ // 点击了数字按钮(只能被点击6次)
        if (clickNum<=6) {
            if(clickNum<6){
                clickNum+=1;
                NSInteger eachNum=0;
                if(sender.tag==9){
                    eachNum=0;
                }
                else{
                    eachNum=sender.tag+1;
                }
                strFinaPwd=[strFinaPwd stringByAppendingString:btnTitle]; // 拼接数字和代理传值
                if([self.delegate respondsToSelector:@selector(eachInputPwd:eachClickPwd:)]){
                    [self.delegate eachInputPwd:self eachClickPwd:btnTitle];
                }
            }
            [self addPwdImage]; // 添加密码图片
        }
    }
}
#pragma mark 添加密码图片
-(void)addPwdImage{
    for (int i=0; i<self.arrAddPwd.count; i++) {
        UIImageView *imageView=self.arrAddPwd[i];
        if (i<clickNum) {
            imageView.image=[UIImage imageNamed:@"Produce"];
        }
        else{
            imageView.image=nil;
        }
    }
}
@end
