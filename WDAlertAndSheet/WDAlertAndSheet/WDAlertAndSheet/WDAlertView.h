//
//  WDAlertView.h
//  WDAlertView
//
//  Created by 王启正 on 2017/8/17.
//  Copyright © 2017年 隔壁老王. All rights reserved.
//

#import <UIKit/UIKit.h>

/// NOTE:
/// 使用时 import "WDAlertView.h" 之后调用下面的类方法即可。


@interface WDAlertView : UIView

///标题字体颜色
@property(nonatomic,strong)UIColor      * _Nullable  titleColor;
///内容字体颜色
@property(nonatomic,strong)UIColor      * _Nullable  contentColor;
///“取消”按钮字体颜色
@property(nonatomic,strong)UIColor      * _Nullable  cancleButtonColor;
///“确定”按钮字体颜色
@property(nonatomic,strong)UIColor      * _Nullable  confirmButtonColor;



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
+(instancetype _Nullable )showAlertWithTitle:(nullable NSString *)title
                                     message:(nullable NSString *)message
                           cancleButtonTitle:(nullable NSString *)cancleButtonTitle
                          confirmButtonTitle:(nullable NSString *)confirmButtonTitle
                                 cancleBlock:(void (^_Nullable)())cancle
                                confirmBlcok:(void (^_Nullable)())confirm;


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
               confirmBlcok:(void (^_Nullable)())confirm;


/**
 只展示内容和一个按钮的AlertView

 @param message 内容
 @param buttonTitle 按钮标题
 @param clicked 回调
 */
+(void)showAlertWithMessage:(nullable NSString *)message
                buttonTitle:(nullable NSString *)buttonTitle
           buttonClickBlock:(void (^_Nullable)())clicked;


/**
 只展示文字的Toast
 
 @param message 内容
 */
+(void)showToastWithText:(NSString * _Nullable)message;



/**
 带有标题和内容的Toast，额。。。这个情况基本不用吧。因为Toast样子太丑。😝

 @param title 标题
 @param message 内容
 */
+(void)showToastWithTitle:(NSString *_Nullable)title
                  message:(NSString *_Nullable)message;



/**
 Alert样式的多级菜单。这里做了限制，至少是三个选择按钮
 
 @param title 标题，不需要时置为nil
 @param message 内容，不需要时置为nil
 @param btnTitlesArr 多级菜单按钮的标题数组
 @param multiMenuBlock 回调
 @return <#return value description#>
 */
-(instancetype _Nullable )initWithTitle:(NSString *_Nullable)title
                                message:(NSString *_Nullable)message
                     multiMenusBtnTitle:(NSArray *_Nullable)btnTitlesArr
                         multiMenuBlock:(void (^_Nullable)(NSInteger btnIndex))multiMenuBlock;

///显示alert 
-(void)show;

@end
