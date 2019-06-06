//
//  WDAlertView.m
//  WDAlertView
//
//  Created by 王启正 on 2017/8/17.
//  Copyright © 2017年 隔壁老王. All rights reserved.
//

#import "WDAlertView.h"
#import "MaskView.h"
#import "AppDelegate.h" //若工程中的默认的AppDelegate的类名被自定义了，比如加了前缀，在此处改换即可

#define WDWIDTH [UIScreen mainScreen].bounds.size.width
#define WDHEIGHT [UIScreen mainScreen].bounds.size.height
#define ConfirmBtnColor(hex) [self colorWithHexString:hex]
#define ContentColor(hex) [self colorWithHexString:hex]   //十六进制颜色
#define CancleBtnColor(hex) [self colorWithHexString:hex]
#define AlertViewWidth 270.0
#define HideDelayTime 1.50  //秒
#define ButtonHeight 45.0



typedef void  (^ConfirmBlock)();
typedef void  (^CancleBlock)();
typedef void  (^MultiMenuBlock)(NSInteger);

@interface WDAlertView ()

///蒙板
@property(nonatomic, strong)MaskView        *mask;
///AppDelegate
@property(nonatomic, strong)AppDelegate     *app;
///标题
@property(nonatomic, strong)UILabel         *titleLabel;
///内容
@property(nonatomic, strong)UILabel         *contentLabel;
///取消按钮
@property(nonatomic, strong)UIButton        *cancleButton;
///确认按钮
@property(nonatomic, strong)UIButton        *confirmButton;
///“确定”回调
@property(nonatomic,   copy)ConfirmBlock    confirmBlock;
///“取消”回调
@property(nonatomic,   copy)CancleBlock     cancleBlock;
///多级菜单alert的点击回调
@property(nonatomic,   copy)MultiMenuBlock  multiMenuBlock;
///提示框的边距
@property(nonatomic, assign)NSUInteger      margin;
///标题字体大小
@property(nonatomic, assign)NSUInteger      titleFont;
///内容字体大小
@property(nonatomic, assign)NSUInteger      contentFont;
///“取消”按钮字体大小
@property(nonatomic, assign)NSUInteger      cancleBtnFont;
///“确定”按钮字体大小
@property(nonatomic, assign)NSUInteger      confirmBtnFont;
///alert高度
@property(nonatomic, assign)CGFloat         alertViewHeight;

@end

@implementation WDAlertView

-(void)drawRect:(CGRect)rect{
    
    //监听屏幕方向
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(interfaceOrientationDidChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        //默认的一些属性
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=8;
        self.backgroundColor=[UIColor whiteColor];
        self.titleFont=15;
        self.contentFont=15;
        self.cancleBtnFont=15;
        self.confirmBtnFont=15;
        self.titleColor=[UIColor blackColor];
        self.contentColor=ContentColor(@"#333333");
        self.cancleButtonColor=CancleBtnColor(@"#7f92ff");
        self.confirmButtonColor=ConfirmBtnColor(@"#7f92ff");
        [self settingAlertUI];
        self.alertViewHeight=self.frame.size.height;
    }
    return self;
}
///初始化alertView的UI
-(void)settingAlertUI{
    //titleLabel
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.titleLabel.numberOfLines=0;
    self.titleLabel.textColor=self.titleColor;
    self.titleLabel.text=@"";
    self.titleLabel.font=[UIFont boldSystemFontOfSize:self.titleFont];
    [self addSubview:self.titleLabel];
//    self.titleLabel.backgroundColor=[UIColor redColor];
    
    //contentLabel
    self.contentLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    self.contentLabel.textAlignment=NSTextAlignmentCenter;
    self.contentLabel.numberOfLines=0;
    self.contentLabel.textColor=self.contentColor;
    self.contentLabel.text=@"";
    self.contentLabel.font=[UIFont systemFontOfSize:self.contentFont];
    [self addSubview:self.contentLabel];
//    self.contentLabel.backgroundColor=[UIColor greenColor];
    
    //confirmBtn
    self.confirmButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:self.confirmButtonColor forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font=[UIFont boldSystemFontOfSize:self.confirmBtnFont];
    self.confirmButton.layer.borderWidth=0.5;
    self.confirmButton.layer.borderColor=[[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    [self.confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.backgroundColor=[UIColor clearColor];
    [self addSubview:self.confirmButton];
    
    //cancleBtn
    self.cancleButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleButton setTitleColor:self.cancleButtonColor forState:UIControlStateNormal];
    [self.cancleButton addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancleButton.titleLabel.font=[UIFont boldSystemFontOfSize:self.cancleBtnFont];
    self.cancleButton.layer.borderWidth=0.5;
    self.cancleButton.layer.borderColor=[[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    self.cancleButton.backgroundColor=[UIColor clearColor];
    [self addSubview:self.cancleButton];
}
/**
 类方法 展示自定义AlertView。
 
 标题，传入nil时标没有标题。
 “取消”按钮标题，传入nil时此按钮不显示。若两个按钮标题都传入nil时,两个按钮都消失。
 “确定”按钮标题，传入nil时此按钮不显示。若两个按钮标题都传入nil时,两个按钮都消失。
 下面的四个方法其实都可以直接通过此方法实现，就是对不需要的参数传入nil即可。
 
 @param title 标题，传入nil时没有标题
 @param message 内容，传入nil或者空值时显示为空
 @param cancleButtonTitle “取消”按钮标题，传入nil时此按钮不显示。
 @param confirmButtonTitle “确定”按钮标题，传入nil时此按钮不显示。
 @param cancle 取消回调
 @param confirm 确定回调
 */
+(instancetype)showAlertWithTitle:(nullable NSString *)title
                          message:(nullable NSString *)message
                cancleButtonTitle:(nullable NSString *)cancleButtonTitle
               confirmButtonTitle:(nullable NSString *)confirmButtonTitle
                      cancleBlock:(CancleBlock)cancle
                     confirmBlcok:(ConfirmBlock)confirm{
    
    CGFloat titleLabelHeight=[self returnHeightWithString:title];
    if (titleLabelHeight<=25 && title!=nil) titleLabelHeight=25;
    CGFloat contentLabelHeight=[self returnHeightWithString:message];
    if (contentLabelHeight<=40) contentLabelHeight=40;
    CGFloat alertHeight=0.0;
    if (title!=nil && (cancleButtonTitle!=nil || confirmButtonTitle!=nil)) {
        //有title，确定和取消按钮都有或者有其一
        alertHeight=10+titleLabelHeight+5+contentLabelHeight+10+ButtonHeight;
    }else if (cancleButtonTitle!=nil || confirmButtonTitle!=nil){
        //没有title，确定和取消按钮都有或者有其一
        alertHeight=10+contentLabelHeight+10+ButtonHeight;
    }else{
        //确定和取消按钮都没有，但是可能有title也可能没有title
        alertHeight=10+contentLabelHeight+10+((title!=nil ? (5+titleLabelHeight):(0)));
    }
    WDAlertView *alertView=[[WDAlertView alloc]initWithFrame:CGRectMake((WDWIDTH-AlertViewWidth)/2,(WDHEIGHT-alertHeight)/2, AlertViewWidth, alertHeight)];
    
    if (title!=nil) {
        alertView.titleLabel.text=title;
        alertView.titleLabel.frame=CGRectMake(10, 10, AlertViewWidth-20, titleLabelHeight);
    }
    if (message!=nil) {
        alertView.contentLabel.text=message;
        if (title!=nil) {
            alertView.contentLabel.frame=CGRectMake(10, CGRectGetMaxY(alertView.titleLabel.frame)+5, AlertViewWidth-20, contentLabelHeight);
        }else{
            alertView.contentLabel.frame=CGRectMake(10, 10, AlertViewWidth-20, contentLabelHeight);
        }
    }
    BOOL cancleHidden=NO;
    BOOL confirmHidden=NO;
    //确定
    if (confirmButtonTitle!=nil) {
        [alertView.confirmButton setTitle:confirmButtonTitle forState:UIControlStateNormal];
    }else{
        //“确定”按钮的标题为nil或者为空时，该按钮不显示
        alertView.confirmButton.hidden=YES;
        confirmHidden=YES;
    }
    //取消
    if (cancleButtonTitle!=nil) {
        [alertView.cancleButton setTitle:cancleButtonTitle forState:UIControlStateNormal];
    }else{
        //“取消”按钮的标题为nil或者为空时，该按钮不显示
        alertView.cancleButton.hidden=YES;
        cancleHidden=YES;
    }
    if (cancleHidden && !confirmHidden) {
        //只有确定按钮
        alertView.confirmButton.frame=CGRectMake(-1, CGRectGetMaxY(alertView.contentLabel.frame)+10, CGRectGetWidth(alertView.frame)+2, ButtonHeight);
    }else if(confirmHidden && !cancleHidden){
        //只有取消按钮
        alertView.cancleButton.frame=CGRectMake(-1, CGRectGetMaxY(alertView.contentLabel.frame)+10, CGRectGetWidth(alertView.frame)+2, ButtonHeight);
    }else if (confirmHidden && cancleHidden) {
        //两个按钮都没有
        
    }else{
        //两个按钮都有
        alertView.confirmButton.hidden=NO;
        alertView.cancleButton.hidden=NO;
        alertView.cancleButton.frame=CGRectMake(-1, CGRectGetMaxY(alertView.contentLabel.frame)+10, CGRectGetWidth(alertView.frame)/2+1, ButtonHeight);
        alertView.confirmButton.frame=CGRectMake(CGRectGetWidth(alertView.frame)/2, CGRectGetMaxY(alertView.contentLabel.frame)+10, CGRectGetWidth(alertView.frame)/2+1, ButtonHeight);
    }
    //俩回调
    alertView.cancleBlock=cancle;
    alertView.confirmBlock=confirm;
    [alertView show];
    return alertView;
}
/**
 只展示内容和两个按钮的AlertView
 
 @param message 内容
 @param cancleButtonTitle "取消"按钮标题
 @param confirmButtonTitle “确定”按钮标题
 @param cancle 回调
 @param confirm 回调
 */
+(void)showAlertWithMessage:(nullable NSString *)message
          cancleButtonTitle:(nullable NSString *)cancleButtonTitle
         confirmButtonTitle:(nullable NSString *)confirmButtonTitle
                cancleBlock:(void (^_Nullable)())cancle
               confirmBlcok:(void (^_Nullable)())confirm{
    [self showAlertWithTitle:nil message:message cancleButtonTitle:cancleButtonTitle confirmButtonTitle:confirmButtonTitle cancleBlock:cancle confirmBlcok:confirm];
}


/**
 只展示内容和一个按钮的AlertView
 
 @param message 内容
 @param buttonTitle 按钮标题
 @param clicked 回调
 */
+(void)showAlertWithMessage:(nullable NSString *)message
                buttonTitle:(nullable NSString *)buttonTitle
           buttonClickBlock:(void (^_Nullable)())clicked{
    [self showAlertWithTitle:nil message:message cancleButtonTitle:buttonTitle confirmButtonTitle:nil cancleBlock:clicked confirmBlcok:nil];
}
/**
 展示内容的Toast
 
 @param message <#message description#>
 */
+(void)showToastWithText:(NSString * _Nullable)message{
  WDAlertView *toast=[self showAlertWithTitle:nil message:message cancleButtonTitle:nil confirmButtonTitle:nil cancleBlock:nil confirmBlcok:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HideDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toast dismiss];
    });
}


/**
 带有标题和内容的Toast，这个情况基本不用吧。因为Toast样子太丑。😝
 
 @param title <#title description#>
 @param message <#message description#>
 */
+(void)showToastWithTitle:(NSString *_Nullable)title
                  message:(NSString *_Nullable)message{
    WDAlertView *toast=[self showAlertWithTitle:title message:message cancleButtonTitle:nil confirmButtonTitle:nil cancleBlock:nil confirmBlcok:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HideDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toast dismiss];
    });
    
}
///根据字符串计算label的高度
+(CGFloat)returnHeightWithString:(NSString *)string{
    
    CGRect rect=[string boundingRectWithSize:CGSizeMake(AlertViewWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]} context:nil];
    return rect.size.height;
}
///弹出
-(void)show{
    [self.mask addToSuperView:nil];
    [self animationWithView:self duration:0.2];
}
//弹出动画
-(void)animationWithView:(UIView *)view duration:(CFTimeInterval)duration {
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];;
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [view.layer addAnimation:animation forKey:nil];
    [self.app.window addSubview:view];
}
///消失
-(void)dismiss{
    [self.mask removeFromSuperview];
    [self removeFromSuperview];
}
///确定
-(void)confirmButtonAction:(UIButton *)btn{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.confirmBlock();
    });
    [self dismiss];
}
///取消
-(void)cancleButtonAction:(UIButton *)btn{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.cancleBlock();
    });
    [self dismiss];
}
-(MaskView *)mask{
    if (!_mask) {
        _mask=[MaskView makeMaskViewWithFrame:CGRectMake(0, 0, WDWIDTH, WDHEIGHT)];
        _mask.maskViewTapBlock=^{
            //            NSLog(@"蒙板点击了");
        };
    }
    return _mask;
}
-(AppDelegate *)app{
    if (!_app) {
        _app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return _app;
}
/**
 十六进制颜色转换
 
 @param color <#color description#>
 @return <#return value description#>
 */
-(UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

///更改字体颜色
-(void)setTitleColor:(UIColor *)titleColor{
    _titleColor=titleColor;
    self.titleLabel.textColor=_titleColor;
}
-(void)setContentColor:(UIColor *)contentColor{
    _contentColor=contentColor;
    self.contentLabel.textColor=_contentColor;
}
-(void)setConfirmButtonColor:(UIColor *)confirmButtonColor{
    _confirmButtonColor=confirmButtonColor;
    [self.confirmButton setTitleColor:_confirmButtonColor forState:UIControlStateNormal];
}
-(void)setCancleButtonColor:(UIColor *)cancleButtonColor{
    _cancleButtonColor=cancleButtonColor;
    [self.cancleButton setTitleColor:_cancleButtonColor forState:UIControlStateNormal];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)interfaceOrientationDidChanged:(NSNotification *)noti{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        {
            [self rotationAlert];
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        {
            [self rotationAlert];
            break;
        }
        case UIInterfaceOrientationLandscapeRight:
        {
            [self rotationAlert];
            break;
        }
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            [self rotationAlert];
            break;
        }
        default:
            break;
    }
}
-(void)rotationAlert{
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    self.mask.frame=CGRectMake(0, 0, WDWIDTH, WDHEIGHT);
    [UIView animateWithDuration:duration animations:^{
        self.frame=CGRectMake((WDWIDTH-AlertViewWidth)/2,(WDHEIGHT-self.alertViewHeight)/2, AlertViewWidth, self.alertViewHeight);
    }];
    
}

/**
 Alert样式的多级菜单。这里做了限制，至少是三个选择按钮

 @param title 标题，不需要时置为nil
 @param message 内容，不需要时置为nil
 @param btnTitlesArr 多级菜单按钮的标题数组
 @param multiMenuBlock 回调
 @return <#return value description#>
 */
-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
          multiMenusBtnTitle:(NSArray *)btnTitlesArr
              multiMenuBlock:(MultiMenuBlock)multiMenuBlock{
    if (self=[super init]) {
        if (btnTitlesArr.count<3) {
            [WDAlertView showAlertWithTitle:@"多级菜单使用提示" message:@"Alert样式的多级菜单提示框必须至少有三个选项按钮" cancleButtonTitle:@"好的" confirmButtonTitle:nil cancleBlock:^{
            } confirmBlcok:^{
            }];
            return nil;
        }
        CGFloat titleLabelHeight=[WDAlertView returnHeightWithString:title];
        if (titleLabelHeight<=40 && title!=nil) titleLabelHeight=40;//titleLabel高度
        CGFloat contentLabelHeight=[WDAlertView returnHeightWithString:message];
        if (contentLabelHeight<=40 && message!=nil) contentLabelHeight=40;//内容Label高度
        CGFloat alertHeight=0.0;
        if (title==nil){
            titleLabelHeight=0;//没有title时titleLabel高度设置为0
        }
        if (message==nil) {
            contentLabelHeight=0;//没有message时的contentLabel的高度
        }
        alertHeight=titleLabelHeight+contentLabelHeight+ButtonHeight*btnTitlesArr.count+4*1;//alertView的高度
        self.frame=CGRectMake((WDWIDTH-AlertViewWidth)/2,(WDHEIGHT-alertHeight)/2, AlertViewWidth, alertHeight);
        self.alertViewHeight=self.frame.size.height;
        //设置标题label的frame
        if (title!=nil) {
            //titleLabel
            self.titleLabel=[[UILabel alloc]initWithFrame:CGRectZero];
            self.titleLabel.textAlignment=NSTextAlignmentCenter;
            self.titleLabel.numberOfLines=0;
            self.titleLabel.textColor=self.titleColor;
            self.titleLabel.font=[UIFont boldSystemFontOfSize:self.titleFont];
            self.titleLabel.text=title;
            self.titleLabel.frame=CGRectMake(0, 0, AlertViewWidth, titleLabelHeight);
            [self addSubview:self.titleLabel];
        }
        //设置内容label的frame
        if (message!=nil) {
            //contentLabel
            self.contentLabel=[[UILabel alloc]initWithFrame:CGRectZero];
            self.contentLabel.textAlignment=NSTextAlignmentCenter;
            self.contentLabel.numberOfLines=0;
            self.contentLabel.textColor=self.contentColor;
            self.contentLabel.font=[UIFont systemFontOfSize:self.contentFont];
            [self addSubview:self.contentLabel];
            self.contentLabel.text=message;
            if (title!=nil) {
                self.contentLabel.frame=CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), AlertViewWidth, contentLabelHeight);
            }else{
                self.contentLabel.frame=CGRectMake(0, 0, AlertViewWidth, contentLabelHeight);
            }
        }
        CGFloat xStart=5;//按钮的x坐标起始点
        
        CGFloat yStart=titleLabelHeight+contentLabelHeight+1;//按钮的y坐标起始点
        CGFloat btnWidth=CGRectGetWidth(self.frame)-2*xStart;//按钮的宽度
        CGFloat btnHeight=ButtonHeight;//按钮的高度
        for (int i=0; i<btnTitlesArr.count; i++) {
            UIView *lineView=[[UIView alloc]init];
            lineView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.1];
            lineView.frame=CGRectMake(xStart, yStart-1+i*(btnHeight+1), btnWidth, 1);
            [self addSubview:lineView];
            
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(xStart, yStart+i*(btnHeight+1), btnWidth, btnHeight);
            btn.titleLabel.font=[UIFont systemFontOfSize:self.confirmBtnFont];
            [btn setTitle:btnTitlesArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:self.confirmButtonColor forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(multiMenuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor=[UIColor whiteColor];
//            [btn setBackgroundImage:[self imageWithColor:[self colorWithHexString:@"#7f92ff"]] forState:UIControlStateHighlighted];
            btn.tag=100+i;
            [self addSubview:btn];
            if (i==btnTitlesArr.count-1) {
                i+=1;
                UIView *lineView=[[UIView alloc]init];
                lineView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.1];
                lineView.frame=CGRectMake(xStart, yStart-1+i*(btnHeight+1), btnWidth, 1);
                [self addSubview:lineView];
            }
        }
        //回调
        self.multiMenuBlock =multiMenuBlock;
    }
    
    return self;
}

-(void)multiMenuBtnAction:(UIButton *)btn{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.multiMenuBlock(btn.tag-100);
    });
    [self dismiss];
    
    
}
- (UIImage *)imageWithColor:(UIColor *)color{
    NSParameterAssert(color != nil);
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




@end
