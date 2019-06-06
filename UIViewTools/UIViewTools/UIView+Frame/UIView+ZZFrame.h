//
//  UIView+ZZFrame.h
//  UIViewTools
//
//  Created by ZZ on 2017/8/22.
//  Copyright © 2017年 隔壁老王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZZFrame)

/// x坐标
@property (nonatomic, assign) CGFloat x;
/// y坐标
@property (nonatomic, assign) CGFloat y;
/// 宽度
@property (nonatomic, assign) CGFloat width;
/// 高度
@property (nonatomic, assign) CGFloat height;
/// 中心坐标X
@property (nonatomic, assign) CGFloat centerX;
/// 中心坐标Y
@property (nonatomic, assign) CGFloat centerY;
/// 大小
@property (nonatomic, assign) CGSize  size;
/// 位置
@property (nonatomic, assign) CGPoint origin;


@end
