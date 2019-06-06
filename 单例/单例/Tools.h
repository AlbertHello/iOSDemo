//
//  Tools.h
//  深拷贝和浅拷贝
//
//  Created by 王启正 on 2017/6/5.
//  Copyright © 2017年 王启正. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface Tools : NSObject


//1、把单例提取成宏的用法
SingleH(Tools)

//2、自己写单例。提供类方法实例化单例
//+(instancetype)sharedInstance;

@end
