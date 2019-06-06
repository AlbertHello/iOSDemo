//
//  ViewController.m
//  单例
//
//  Created by 王启正 on 2017/6/5.
//  Copyright © 2017年 王启正. All rights reserved.
//

#import "ViewController.h"
#import "Tools.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blueColor];

    
//    //1、自己写的单例
//    Tools *tool=[[Tools alloc]init];
//    NSLog(@"%p",tool);
//    
//    Tools *tool2=[[Tools alloc]init];
//    NSLog(@"%p",tool2);
//    
//    Tools *tool3=[Tools sharedInstance];
//    NSLog(@"%p",tool3);
    
    
    //单例提取成宏的写法
    Tools *t2=[[Tools alloc]init];
    NSLog(@"t2=%p",t2);
    Tools *t1=[Tools shareTools];
    NSLog(@"t1=%p",t1);
    //t1 和 t2 地址一样，因为单例宏覆写了allocWithZone的方法，就是为了防止不使用shareTools方法，而是用allocinit的方法创建实例对象。
    
    
    
//    NSString *str1=@"hello";//不会初始化内存空间,所以使用结束后不会释放内存
//    NSString *str2=[NSString stringWithString:@"hello"];//autorelease类型,内存由系统释放
//    NSString *str3=[[NSString alloc]initWithString:@"hello"];//必须手动释放
//    NSString *str4=[[NSString alloc]initWithFormat:@"hello"];//用Format初始化的字符串，需要初始化一段动态内存空间,用String声明的字符串，初始化的是常量内存区,常量内存区的地址，只要值相同，占用的地址空间是一致的.
    
//    NSLog(@"%p",str1);//0x10b03f0c0
//    NSLog(@"%p",str2);//0x10b03f0c0
//    NSLog(@"%p",str3);//0x10b03f0c0
//    NSLog(@"%p",str4);//0xa00006f6c6c65685
    
    
}





@end
