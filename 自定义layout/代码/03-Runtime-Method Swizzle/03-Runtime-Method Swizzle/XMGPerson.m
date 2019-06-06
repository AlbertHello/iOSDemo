//
//  XMGPerson.m
//  03-Runtime-Method Swizzle
//
//  Created by xiaomage on 15/8/7.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGPerson.h"

@implementation XMGPerson

- (void)run
{
    NSLog(@"%s", __func__);
}

- (void)study
{
    NSLog(@"%s", __func__);
}
@end
