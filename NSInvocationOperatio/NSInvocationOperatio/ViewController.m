//
//  ViewController.m
//  NSInvocationOperatio
//
//  Created by 王启正 on 2017/6/9.
//  Copyright © 2017年 王启正. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong)NSOperationQueue *queue;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
//    [self demo1];
//    [self demo2];
//    [self demo3];
//    [self demo4];
    
}

-(NSOperationQueue *)queue{
    
    if (_queue==nil) {
        
        _queue=[[NSOperationQueue alloc]init];
        //设置最大并发数
        _queue.maxConcurrentOperationCount=2;
        
    }
    return _queue;
}

-(void)demo1{
    
    //1、创建操作
    NSInvocationOperation *op=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(fun1) object:nil];
//    [op start];//不开辟新线程，只会在当前线程同步执行操作，只有将nsoperation 放入到NSOperationQueue中，才会异步执行操作
    
    
    //2、创建队列
    NSOperationQueue *qu=[[NSOperationQueue alloc]init];
    
    //3、把操作添加到队列
    [qu addOperation:op];
    
}
-(void)fun1
{
    NSLog(@"hello %@",[NSThread currentThread]);
}

-(void)demo2{
    NSBlockOperation *blockOP=[NSBlockOperation blockOperationWithBlock:^{
       
        NSLog(@"blockOperation %@",[NSThread currentThread]);
    }];
    NSOperationQueue *que=[[NSOperationQueue alloc]init];
    [que addOperation:blockOP];
                               
}

-(void)demo3{
    
    
    [self.queue addOperationWithBlock:^{
        
        //异步执行任务
        NSLog(@"queueBlockOperation %@",[NSThread currentThread]);
        
        //线程间通信。回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"更新UI %@",[NSThread currentThread]);
        }];
    }];
    
}

-(void)demo4{
    
    for (int i=0; i<20; i++) {
        [self.queue addOperationWithBlock:^{
            
            [NSThread sleepForTimeInterval:2];
            //异步执行任务
            NSLog(@"第%d个任务 %@",i,[NSThread currentThread]);
        }];
    }
}

//继续
- (IBAction)continueAction:(id)sender {
    
    if (self.queue.isSuspended) {
        [self.queue setSuspended:NO];
    }
}
//暂停
- (IBAction)pauseAction:(id)sender {
    if (!(self.queue.isSuspended)) {
        [self.queue setSuspended:YES];
    }
}

//取消
- (IBAction)cancleAction:(id)sender {
    [self.queue cancelAllOperations];
}



//摇奖机
- (IBAction)startBtnAction:(id)sender {
    
    if (self.queue.operationCount==0) {
        [self runRondom];
        [self.startBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [self.queue setSuspended:NO];
        
    }else if (self.queue.isSuspended) {
        //继续
        [self.startBtn setTitle:@"继续" forState:UIControlStateNormal];
        [self.queue setSuspended:NO];
        
    }else{
        //暂停
        [self.startBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [self.queue setSuspended:YES];
        
    }
    
}

-(void)runRondom
{
    
    [self.queue addOperationWithBlock:^{
        
        while (!self.queue.isSuspended) {
            
            [NSThread sleepForTimeInterval:0.05];
            int a=arc4random_uniform(10);//产生0-9的随机数
            int b=arc4random_uniform(10);//产生0-9的随机数
            int c=arc4random_uniform(10);//产生0-9的随机数
            
            //回到主线程更新UI
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                
                self.label1.text=[NSString stringWithFormat:@"%d",a];
                self.label2.text=[NSString stringWithFormat:@"%d",b];
                self.label3.text=[NSString stringWithFormat:@"%d",c];
            }];
        }
    }];
}








@end
