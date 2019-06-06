//
//  XMGPhotoCell.m
//  02-自定义布局
//
//  Created by xiaomage on 15/8/6.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGPhotoCell.h"

@interface XMGPhotoCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation XMGPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.imageV.bounds];
//    self.imageV.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.imageV.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
//    self.imageV.layer.shadowOpacity = 0.8f;
//    self.imageV.layer.shadowRadius=5.0;
//    self.imageV.layer.shadowPath = shadowPath.CGPath;
//    self.imageV.layer.cornerRadius=5;
//    self.imageV.layer.masksToBounds=YES;
    
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
//    self.layer.shadowOpacity = 0.8f;
//    self.layer.shadowRadius=5.0;
    
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = [imageName copy];
    
    self.imageV.image = [UIImage imageNamed:imageName];
}

@end
