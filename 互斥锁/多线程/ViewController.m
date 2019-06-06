//
//  ViewController.m
//  多线程
//
//  Created by 王启正 on 2017/6/6.
//  Copyright © 2017年 王启正. All rights reserved.
//

#import "ViewController.h"
#import <string.h>
@interface ViewController ()

@property(nonatomic,assign)NSInteger ticketCount;

//atomic 原子属性。线程安全，自旋锁，下面是它的setter和getter方法
@property(atomic,copy)NSString *name;
/**
 atomic:原子属性，线程安全，针对多线程设计，保证同一时间只有一个线程写入，可以多个线程读取。
 nonatomic： 非原子属性，非线程安全，适合内存小的移动设备。
 iOS开发中属性都设置nonatomic，尽量避免多线程抢夺同一块资源；尽量将加锁和资源抢夺的业务逻辑交给服务端处理，减少客户端的压力。
 */

@end

@implementation ViewController

//为属性生成对应的成员变量
@synthesize name=_name;





- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor brownColor];
    //总票数
    self.ticketCount=10;
    //nsthread
    [self test_NSThread];
    
}

//当同时重写属性的getter和setter时，不会自动生成_name成员变量，需要@synthesize生成属性的成员变量
//getter
-(NSString *)name
{
    return _name;
}
//setter
-(void)setName:(NSString *)name{
    //这是院子属性的setter方法，加了锁，所以是线程安全的。但是效率低，所以一般用nonatomic。
    @synchronized (self) {
        _name=name;
    }
}


-(void)test_NSThread
{
    //方式1.
    NSThread *th1=[[NSThread alloc]initWithTarget:self selector:@selector(demo) object:nil];
    //设置线程名称
    th1.name=@"name_";
    //设置线程的优先级
//    th1.threadPriority=1.0;//范围时0-1，设置这个属性也只是让CPU调度该线程的几率大一些。
    //手动管理线程的生命周期，开始暂停结束等
    [th1 start];
    
    
    //创建第二个线程，测试多线程访问同一资源的问题
    NSThread *th2=[[NSThread alloc]initWithTarget:self selector:@selector(demo) object:nil];
    th2.name=@"name_2";
    [th2 start];
    
    
    
    //方式2. 此方法会不用手挡执行线程
//    [NSThread detachNewThreadSelector:@selector(demoFunc1) toTarget:self withObject:nil];
    
    
    //方式3
//    [self performSelectorInBackground:@selector(demoFunc1) withObject:nil];
    
}


//测试多线程访问共享资源的问题。
//多个线程同事访问同一块资源很容易造成数据错乱或者数据安全问题
-(void)demo {
    
    while (YES) {
        
        [NSThread sleepForTimeInterval:1];
        //加互斥锁，保证线程同步，有效防止多线程抢夺资源造成的数据安全问题。否则self.ticketCount数据会错乱。
        @synchronized (self) {
            
            if (self.ticketCount>0) {
                self.ticketCount=self.ticketCount-1;
                NSLog(@"剩余%ld张票",self.ticketCount);
            }else{
                NSLog(@"票卖完了");
                break;
            }
        }
    }
    
    /**
     
     互斥锁原理：
     如果发现其他线程正在执行锁定的代码，线程会进入休眠。等其他线程的时间片到打开锁后，线程会被唤醒。
     
     每一个对象（NSObject）内部都有一个锁（变量），当有线程要进入@synchronized到代码块中时会先检查对象的锁是否处于打开状态，默认锁的状态是打开（1）。如果线程执行到代码块内部会先上锁（0），如果锁被关闭，再有其他线程要执行代码就要先等待，直到锁打开才能进入。
     加锁后的执行效率要比不加锁是的执行效率低，因为线程要等待。但是锁保证了多线程同时操作同一资源的安全性。
     
     
     原子属性的自旋锁：
     如果发现有其他线程正在锁定代码，线程会用死循环的方式一直等待锁定的代码执行完成。自旋锁更适合执行不耗时的代码。
     
     */
    
}




-(void)demoFunc1{
    
    NSLog(@"hello, %@",[NSThread currentThread]);
    
    [NSThread exit];//线程退出／
    
}




















@end
