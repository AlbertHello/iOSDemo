//
//  MaskView.h
//
//
//  Created by 王启正 on 16/10/27.
//  Copyright © 2016年 北京对牛文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaskView : UIView


/**
 点击蒙板block回调
 */
@property(nonatomic,copy)void(^maskViewTapBlock)();

/**
 创建蒙板

 @param frame frame
 @return  实例
 */
+(instancetype)makeMaskViewWithFrame:(CGRect)frame;

/**
 添加到父视图，view为nil时代表加到Window上，否则加到view上。

 @param view <#view description#>
 */
-(void)addToSuperView:(UIView *)view;
@end
