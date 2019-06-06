//
//  WDActionSheetView.h
//  WDActionSheet
//
//  Created by 王启正 on 2017/8/18.
//  Copyright © 2017年 文都. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WDActionSheetView : UIView


/**
 显示标准的自定义的ActionSheet
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
                    actionBlock:(void (^ _Nullable)(NSInteger index))actionBlock;


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
                             actionBlock:(void (^_Nullable)(NSInteger index))actionBlock;


/**
 Sheet样式：只有取消和其他按钮。

 @param cancleBtnTitle 取消
 @param otherTitlesArray 其他
 @param actionBlock 回调
 */
+(void)showActionSheetWithCancleBtnTitle:(NSString *_Nullable)cancleBtnTitle
                          otherBtnTitles:(NSArray *_Nullable)otherTitlesArray
                             actionBlock:(void (^_Nullable)(NSInteger index))actionBlock;


/**
 Sheet样式：只有取消和Destruct。

 @param cancleBtnTitle <#cancleBtnTitle description#>
 @param destructiveBtnTitle <#destructiveBtnTitle description#>
 @param actionBlock <#actionBlock description#>
 */
+(void)showActionSheetWithCancleBtnTitle:(NSString *_Nullable)cancleBtnTitle
                     destructiveBtnTitle:(NSString *_Nullable)destructiveBtnTitle
                             actionBlock:(void (^_Nullable)(NSInteger index))actionBlock;


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
                     actionBlock:(void (^_Nullable)(NSInteger index))actionBlock;



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
                     actionBlock:(void (^_Nullable)(NSInteger index))actionBlock;
/**
 标准样式 + icon
 这个。。。暂时未实现，后续更新。
 @param title <#title description#>
 @param cancleBtnTitle <#cancleBtnTitle description#>
 @param destructiveBtnTitle <#destructiveBtnTitle description#>
 @param otherTitlesArray <#otherTitlesArray description#>
 @param imageTltlesArray <#imageTltlesArray description#>
 @param actionBlock <#actionBlock description#>
 @return <#return value description#>
 */
+(instancetype _Nullable )showActionSheetWithTitle:(NSString *_Nullable)title
                                    cancleBtnTitle:(NSString *_Nullable)cancleBtnTitle
                               destructiveBtnTitle:(NSString *_Nullable)destructiveBtnTitle
                                    otherBtnTitles:(NSArray  *_Nullable)otherTitlesArray
                                       imageTitles:(NSArray  *_Nullable)imageTltlesArray
                                       actionBlock:(void (^ _Nullable)(NSInteger index))actionBlock;








@end


