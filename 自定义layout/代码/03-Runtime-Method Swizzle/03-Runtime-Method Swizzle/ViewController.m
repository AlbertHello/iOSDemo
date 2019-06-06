//
//  ViewController.m
//  03-Runtime-Method Swizzle
//
//  Created by xiaomage on 15/8/7.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGPerson.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    Method method1 = class_getInstanceMethod([XMGPerson class], @selector(run));
//    Method method2 = class_getInstanceMethod([XMGPerson class], @selector(study));
//    method_exchangeImplementations(method1, method2);
//    
//    
//    XMGPerson *p = [[XMGPerson alloc] init];
//    [p run];
//    
//    [p study];
    
    NSString *value = nil;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"name"] = value;
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:value];
    array[0] = value;
}

- (void)dealloc
{
    NSLog(@"-------dealloc");
    
//    self.data = nil;
//    self.images = nil;
//    
//    [self cancel];
}

@end
