//
//  TestCopy.m
//  深拷贝和浅拷贝
//
//  Created by 王启正 on 2017/6/5.
//  Copyright © 2017年 王启正. All rights reserved.
//

#import "TestCopy.h"

//自定义的类拷贝，需要遵守NSCopying，NSMutableCopying协议
@interface TestCopy ()<NSCopying,NSMutableCopying>

@property(nonatomic,strong)NSString *pro;

@end

@implementation TestCopy


//浅拷贝
-(id) copyWithZone:(NSZone *) zone
{
    return [self retain];
}
//深拷贝
-(id) mutableCopyWithZone:(NSZone *) zone
{
    TestCopy *test = [[TestCopy allocWithZone : zone] init];
    test.pro = self.pro;//次数的self就是要被拷贝的对象
    return test;
}

@end
