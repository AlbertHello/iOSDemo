//
//  WDActionSheetView.m
//  WDActionSheet
//
//  Created by 王启正 on 2017/8/18.
//  Copyright © 2017年 文都. All rights reserved.
//

#import "WDActionSheetView.h"
#import "MaskView.h"
#import "WDAlertView.h"
#import "AppDelegate.h"

#define WDScreen [UIScreen mainScreen].bounds
#define WDWIDTH WDScreen.size.width
#define WDHEIGHT WDScreen.size.height
#define WDItem_Height 50.0
#define WDLine_Gap 0.0000
#define WDBottom_Gap 5.0
#define BackgroundHigthLightColor(hex) [self colorWithHexString:hex]
#define TitleHighLightColor(hex) [self colorWithHexString:hex]
#define TitleNormalColor(hex) [self colorWithHexString:hex]
#define IS_iPhoneX (CGSizeEqualToSize(WDScreen.size, CGSizeMake(375, 812)) || CGSizeEqualToSize(WDScreen.size, CGSizeMake(812, 375)))

typedef void  (^ActionBlock)(NSInteger index);

@interface WDActionSheetView ()
///block回调
@property(nonatomic,   copy)ActionBlock          actionBlcok;
@property(nonatomic, strong)NSArray              *titlesArray;
@property(nonatomic, strong)NSArray              *imageTitlesArray;
@property(nonatomic, assign)BOOL                 hideCloseIcon;
@property(nonatomic, assign)double               frameY;
@property(nonatomic, strong)UIColor              *titleColor;
@property(nonatomic, strong)UIColor              *destructBtnTitleColor;
@property(nonatomic, assign)NSUInteger           titleFont;
@property(nonatomic, assign)NSUInteger           buttonTitleFont;
@property(nonatomic, assign)NSUInteger           itemTag;
@property(nonatomic,   copy)NSString             *title;
@property(nonatomic, assign)NSUInteger           cancleBtnTag;
@property(nonatomic, weak  )UIButton             *selectedButton;

///蒙板
@property(nonatomic, strong)MaskView    *mask;
///AppDelegate
@property(nonatomic, strong)AppDelegate *app;

@end

@implementation WDActionSheetView

-(NSArray *)titlesArray{
    
    if (!_titlesArray) {
        _titlesArray=[[NSArray alloc]init];
    }
    return _titlesArray;
}
-(NSArray *)imagesTitleArray{
    if (!_imageTitlesArray) {
        _imageTitlesArray=[[NSArray alloc]init];
    }
    return _imageTitlesArray;
}
-(MaskView *)mask{
    if (!_mask) {
        _mask=[MaskView makeMaskViewWithFrame:CGRectMake(0, 0, WDWIDTH, WDHEIGHT)];
        __weak __typeof(self)weakSelf=self;
        _mask.maskViewTapBlock=^{
            //蒙板点击
            [weakSelf dismiss];
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


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        //默认的属性
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(interfaceOrientationDidChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        self.backgroundColor=[UIColor clearColor];
        self.hideCloseIcon=YES;
        self.frameY=0;
        self.titleColor=[UIColor grayColor];
        self.destructBtnTitleColor=[UIColor redColor];
        self.titleFont=12;
        self.buttonTitleFont=15;
        self.itemTag=0;
        self.cancleBtnTag=101;
        self.autoresizesSubviews=YES;
    }
    return self;
}

///button 生成
-(UIButton *)creatButtonWithTitle:(NSString *)title index:(NSUInteger)index{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    if (self.frameY==0) {
        self.itemTag=index;
        button.tag=self.itemTag;
    }else{
        self.itemTag=index+1;
        button.tag=self.itemTag;
    }
    button.backgroundColor=[UIColor whiteColor];
    [button setTitle:title forState:UIControlStateNormal];
    button.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [button setTitleColor:TitleNormalColor(@"#333333") forState:UIControlStateNormal];
    [button setTitleColor:TitleHighLightColor(@"#ffffff") forState:UIControlStateHighlighted];
    [button setBackgroundImage:[self imageWithColor:BackgroundHigthLightColor(@"#7f92ff")] forState:UIControlStateHighlighted];
    button.titleLabel.font=[UIFont systemFontOfSize:self.buttonTitleFont];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderWidth=0.25;
    button.layer.borderColor=[[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    return button;
    
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

/**
 利用UIColor生成UIimage

 @param color <#color description#>
 @return <#return value description#>
 */
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

///创建标题
-(void)createActionSheetTitle:(NSString *)title{
    
    if (title!=nil) {
        UIView *titleBackView=[[UIView alloc]initWithFrame:CGRectMake(0, self.frameY, WDWIDTH, WDItem_Height)];
        titleBackView.backgroundColor=[UIColor whiteColor];
        titleBackView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frameY, WDWIDTH, WDItem_Height)];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textColor=self.titleColor;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.font=[UIFont systemFontOfSize:self.titleFont];
        titleLabel.text=title;
        titleLabel.layer.borderWidth=0.25;
        titleLabel.layer.borderColor=[[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
        self.frameY=self.frameY+WDItem_Height+WDLine_Gap;
        self.frame=CGRectMake(0, WDHEIGHT, WDWIDTH, self.frameY);
        titleLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [titleBackView addSubview:titleLabel];
        [self addSubview:titleBackView];
    }
}
///创建其他按钮
-(void)createActionSheetItemsWithTitle:(NSString *)title
                                 imageName:(NSString *)imageName
                               indexButton:(NSUInteger)index
                               imageExists:(BOOL)imageExists{
    
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0,self.frameY, WDWIDTH, WDItem_Height)];
    backView.backgroundColor=[UIColor whiteColor];
    backView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    
    UIButton *itemButton=[self creatButtonWithTitle:title index:index];
    if (imageExists) {
        //有icon
    }else{
        //没有icon
        itemButton.frame=CGRectMake(0, 0, WDWIDTH, WDItem_Height);
        [backView addSubview:itemButton];
    }
    
    self.frameY=self.frameY+WDItem_Height+WDLine_Gap;
    self.frame=CGRectMake(0, WDHEIGHT, WDWIDTH, self.frameY);
    [self addSubview:backView];
}

///取消或者Destruct按钮
-(void)createCancleAndDestructButtonItemWithTitle:(NSString *)title
                                            index:(NSUInteger)index
                                      isCancleBtn:(BOOL)isCancle{
    if (title!=nil) {
        UIButton *button=[self creatButtonWithTitle:title index:index];
        if (isCancle) {
            button.frame=CGRectMake(0, self.frameY+WDBottom_Gap, WDWIDTH, WDItem_Height);
            self.frameY=self.frameY+WDItem_Height+WDBottom_Gap;
            self.frame=CGRectMake(0, WDHEIGHT, WDWIDTH, self.frameY);
            self.cancleBtnTag=button.tag;//标记“取消”按钮的
            
        }else{
            
            [button setTitleColor:self.destructBtnTitleColor forState:UIControlStateNormal];
            button.frame=CGRectMake(0, self.frameY, WDWIDTH, WDItem_Height);
            self.frameY=self.frameY+WDItem_Height+WDLine_Gap;
            self.frame=CGRectMake(0, WDHEIGHT, WDWIDTH, self.frameY);
        }
        [self addSubview:button];
    }
}


/**
 标准样式+icon

 @param title <#title description#>
 @param cancleBtnTitle <#cancleBtnTitle description#>
 @param destructiveBtnTitle <#destructiveBtnTitle description#>
 @param otherTitlesArray <#otherTitlesArray description#>
 @param imageTltlesArray <#imageTltlesArray description#>
 @param actionBlock <#actionBlock description#>
 @return <#return value description#>
 */
+(instancetype)showActionSheetWithTitle:(nullable NSString *)title
                         cancleBtnTitle:(nullable NSString *)cancleBtnTitle
                    destructiveBtnTitle:(NSString *)destructiveBtnTitle
                         otherBtnTitles:(NSArray  *)otherTitlesArray
                            imageTitles:(NSArray  *)imageTltlesArray
                            actionBlock:(ActionBlock)actionBlock{
    
    WDActionSheetView *action=[[WDActionSheetView alloc]initWithFrame:CGRectZero];
    //创建UI
    //1、title
    [action createActionSheetTitle:title];

    //2、destructiveButton
    [action createCancleAndDestructButtonItemWithTitle:destructiveBtnTitle index:action.itemTag isCancleBtn:NO];

    //2、有icon时
    NSInteger numbers=imageTltlesArray.count;
    if (numbers>=0 && imageTltlesArray!=nil) {
        //先检测imageTltlesArray的元素个数和otherTitlesArray的元素个数是否相同
        if (imageTltlesArray.count != otherTitlesArray.count){
            [action alertWithError];
            return nil;
        }
        if (otherTitlesArray.count!=0) {
            for (int i=0; i<otherTitlesArray.count; i++) {
                NSString *imageName=imageTltlesArray[i];
                [action createActionSheetItemsWithTitle:otherTitlesArray[i] imageName:imageTltlesArray[i] indexButton:action.itemTag imageExists:imageName.length>0 ? YES : NO];
            }
        }
    }else{
        //没有icon
        for (int i=0; i<otherTitlesArray.count; i++) {
            [action createActionSheetItemsWithTitle:otherTitlesArray[i] imageName:imageTltlesArray[i] indexButton:action.itemTag imageExists:NO];
        }
    }
    //取消按钮
    [action createCancleAndDestructButtonItemWithTitle:cancleBtnTitle index:action.itemTag isCancleBtn:YES];
    //回调
    action.actionBlcok=actionBlock;
    [action show];
    return action;
}
/**
 显示标准的自定义的ActionSheet。
 标准： 标题、“取消”、“Destruct”和其他按钮都存在的样式。
 
 @param title 标题
 @param cancleBtnTitle “取消”按钮的title
 @param destructiveBtnTitle “destruct”按钮的title
 @param otherTitlesArray 其他按钮的title
 @param actionBlock 回调
 */
+(void)showActionSheetWithTitle:(NSString *_Nullable)title
                 cancleBtnTitle:(NSString *_Nullable)cancleBtnTitle
            destructiveBtnTitle:(NSString *_Nullable)destructiveBtnTitle
                 otherBtnTitles:(NSArray  *_Nullable)otherTitlesArray
                    actionBlock:(void (^ _Nullable)(NSInteger index))actionBlock{
    
    [self showActionSheetWithTitle:title
                    cancleBtnTitle:cancleBtnTitle
               destructiveBtnTitle:destructiveBtnTitle
                    otherBtnTitles:otherTitlesArray
                       imageTitles:nil
                       actionBlock:actionBlock];
}
/**
 Sheet样式：没有标题。
 
 @param cancleBtnTitle ”取消“
 @param destructiveBtnTitle destruction
 @param otherTitlesArray 其他
 @param actionBlock 回调
 */
+(void)showActionSheetWithCancleBtnTitle:(NSString *_Nullable)cancleBtnTitle
                     destructiveBtnTitle:(NSString *_Nullable)destructiveBtnTitle
                          otherBtnTitles:(NSArray *_Nullable)otherTitlesArray
                             actionBlock:(void (^_Nullable)(NSInteger index))actionBlock{
    
    [self showActionSheetWithTitle:nil
                    cancleBtnTitle:cancleBtnTitle
               destructiveBtnTitle:destructiveBtnTitle
                    otherBtnTitles:otherTitlesArray
                       imageTitles:nil
                       actionBlock:actionBlock];
}
/**
 Sheet样式：只有取消和其他按钮。
 
 @param cancleBtnTitle 取消
 @param otherTitlesArray 其他
 @param actionBlock 回调
 */
+(void)showActionSheetWithCancleBtnTitle:(NSString *_Nullable)cancleBtnTitle
                          otherBtnTitles:(NSArray *_Nullable)otherTitlesArray
                             actionBlock:(void (^_Nullable)(NSInteger index))actionBlock{
    
    [self showActionSheetWithTitle:nil
                    cancleBtnTitle:cancleBtnTitle
               destructiveBtnTitle:nil
                    otherBtnTitles:otherTitlesArray
                       imageTitles:nil
                       actionBlock:actionBlock];
}
/**
 Sheet样式：只有取消和Destruct。
 
 @param cancleBtnTitle <#cancleBtnTitle description#>
 @param destructiveBtnTitle <#destructiveBtnTitle description#>
 @param actionBlock <#actionBlock description#>
 */
+(void)showActionSheetWithCancleBtnTitle:(NSString *_Nullable)cancleBtnTitle
                     destructiveBtnTitle:(NSString *_Nullable)destructiveBtnTitle
                             actionBlock:(void (^_Nullable)(NSInteger index))actionBlock{
    
    [self showActionSheetWithTitle:nil
                    cancleBtnTitle:cancleBtnTitle
               destructiveBtnTitle:destructiveBtnTitle
                    otherBtnTitles:nil
                       imageTitles:nil
                       actionBlock:actionBlock];
}

/**
 Sheet样式：只有标题、Destruct和取消
 
 @param title 标题
 @param cancleBtnTitle 取消
 @param destructiveBtnTitle Destruct
 @param actionBlock 回调
 */
+(void)showActionSheeetWithTitle:(NSString *_Nullable)title
                  cancleBtnTitle:(NSString *_Nullable)cancleBtnTitle
                  destructiveBtn:(NSString *_Nullable)destructiveBtnTitle
                     actionBlock:(void (^_Nullable)(NSInteger index))actionBlock{
    
    [self showActionSheetWithTitle:title
                    cancleBtnTitle:cancleBtnTitle
               destructiveBtnTitle:destructiveBtnTitle
                    otherBtnTitles:nil
                       imageTitles:nil
                       actionBlock:actionBlock];
}
/**
 Sheet样式：只有标题、其他按钮和取消
 
 @param title 标题
 @param cancleBtnTitle 取消
 @param otherTitlesArray 其他按钮
 @param actionBlock 回调
 */
+(void)showActionSheeetWithTitle:(NSString *_Nullable)title
                  cancleBtnTitle:(NSString *_Nullable)cancleBtnTitle
                  otherBtnTitles:(NSArray *_Nullable)otherTitlesArray
                     actionBlock:(void (^_Nullable)(NSInteger index))actionBlock{
    [self showActionSheetWithTitle:title
                    cancleBtnTitle:cancleBtnTitle
               destructiveBtnTitle:nil
                    otherBtnTitles:otherTitlesArray
                       imageTitles:nil
                       actionBlock:actionBlock];
}
-(void)buttonClicked:(UIButton *)btn{
    if (btn.tag!=self.cancleBtnTag) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.actionBlcok(btn.tag);
        });
    }
    [self dismiss];
}

///弹出
-(void)show{
    [self.mask addToSuperView:nil];
    [self.app.window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        if (IS_iPhoneX) {
            self.frame=CGRectMake(0, WDHEIGHT-self.frameY-34, WDWIDTH, self.frameY);
        }else{
            self.frame=CGRectMake(0, WDHEIGHT-self.frameY, WDWIDTH, self.frameY);
        }
    } completion:^(BOOL finished) {
       
    }];
}
///消失
-(void)dismiss{
    
    [self.mask removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame=CGRectMake(0, WDHEIGHT, WDWIDTH, self.frameY);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

-(void)alertWithError{
    NSString *str=@"WDActionSheet\n两数组元素个数不相等\n请参考注释";
    [WDAlertView showAlertWithMessage:str buttonTitle:@"确定" buttonClickBlock:nil];
}

-(void)interfaceOrientationDidChanged:(NSNotification *)noti{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        {
            NSLog(@"竖屏");
            [self rotateSheetWithInterfaceOrientation:UIInterfaceOrientationPortrait];
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        {
            NSLog(@"横屏，home键在左侧");
            [self rotateSheetWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
            break;
        }
        case UIInterfaceOrientationLandscapeRight:
        {
            NSLog(@"横屏，home键在右侧");
            [self rotateSheetWithInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
            break;
        }
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            NSLog(@"竖屏，倒立");
            [self rotateSheetWithInterfaceOrientation:UIInterfaceOrientationPortraitUpsideDown];
            break;
        }
        default:
            break;
    }
}
-(void)rotateSheetWithInterfaceOrientation:(UIInterfaceOrientation)orientation{
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    self.mask.frame=CGRectMake(0, 0, WDWIDTH, WDHEIGHT);
    [UIView animateWithDuration:duration animations:^{
//        if (orientation == UIInterfaceOrientationPortrait || orientation== UIInterfaceOrientationPortraitUpsideDown) {
//            
//            self.frame=CGRectMake(0,WDHEIGHT-self.frameY, WDWIDTH, self.frameY);
//        }else{
//            self.frame=CGRectMake((WDWIDTH-WDHEIGHT)/2,WDHEIGHT-self.frameY, WDHEIGHT, self.frameY);
//        }
        if (IS_iPhoneX) {
            self.frame=CGRectMake(0,WDHEIGHT-self.frameY-34, WDWIDTH, self.frameY);
        }else{
            self.frame=CGRectMake(0,WDHEIGHT-self.frameY, WDWIDTH, self.frameY);
        }
        [self layoutSubviews];
    }];
    
}

-(void)dealloc{
    NSLog(@"销毁了");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


















@end
