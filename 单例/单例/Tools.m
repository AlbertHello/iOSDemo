//
//  Tools.m
//  深拷贝和浅拷贝
//
//  Created by 王启正 on 2017/6/5.
//  Copyright © 2017年 王启正. All rights reserved.
//

#import "Tools.h"


@implementation Tools
// 1 单例提取成宏的用法
SingleM(Tools)

//2、自己实现单例的写法
//static id sharedSingleton = nil;
//+ (id)allocWithZone:(struct _NSZone *)zone
//{
//    if (sharedSingleton == nil) {
//
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            sharedSingleton = [super allocWithZone:zone];
//        });
//    }
//    NSLog(@"%s",__FUNCTION__);
//    return sharedSingleton;
//}
//
//+ (instancetype)sharedInstance
//{
//    NSLog(@"%s",__FUNCTION__);
//    return [[self alloc]init];
//}
//
//+ (id)copyWithZone:(struct _NSZone *)zone
//{
//    return sharedSingleton;
//}
//+ (id)mutableCopyWithZone:(struct _NSZone *)zone
//{
//    return sharedSingleton;
//}

@end
