//
//  ViewController.m
//  子线程的Runloop
//
//  Created by 王启正 on 2017/6/9.
//  Copyright © 2017年 王启正. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor brownColor];
    //开辟子线程
    NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(demo) object:nil];
    thread.name=@"sub1";
    [thread start];
    
    //往子线程的runloop中添加输入源
    [self performSelector:@selector(childThreadRunloopDemo) onThread:thread withObject:nil waitUntilDone:NO modes:@[NSRunLoopCommonModes]];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    /**
     runloop 
     1、主线程的的runloop默认开启，子线程的消息循环默认不开启
     2.runloop的目的 
     保证程序的不退出，负责处理输入事件。
     3、输入事件的模式必须跟当前runloop的模式相同输入事件才会执行。
     
     */
}


-(void)demo {
    
    NSLog(@"我在子线程中运行");
    //开启子线程的runloop,开启后会一直循环运行，所以“end”不会打印。
    //当runloop中没有添加输入源或者定时源，run这个方法会立即结束。
    [[NSRunLoop currentRunLoop] run];
    
    //这个开启runloop的方法表示，开启后多长时间停止运行。
//    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];//此处是开启runloop后3秒停止运行
    NSLog(@"end");
    
    
    /**
     当子线程的runloop没有开启时，子线程执行完任务后就会被销毁，但是开启了runloop，子线程执行任务后不会被销毁，而是别加入了一个线程池，当需要让子线程执行新任务的时候使用performSelector让指定的方法在指定的线程中运行。
     */
    
    
    
}

-(void)childThreadRunloopDemo{
    NSLog(@"i am running on runloop");
}





















@end
