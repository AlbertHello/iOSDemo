//
//  UIImage+MutiFuctional.m
//  GCD
//
//  Created by 王启正 on 2018/3/9.
//  Copyright © 2018年 王启正. All rights reserved.
//

#import "UIImage+MutiFuctional.h"

@implementation UIImage (MutiFuctional)

-(UIImage *)imageWithSize:(CGSize)size fillColor:(UIColor *)fillColor{
    
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [[UIBezierPath bezierPathWithRoundedRect:rect
                                cornerRadius:5] addClip];
    [self drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
