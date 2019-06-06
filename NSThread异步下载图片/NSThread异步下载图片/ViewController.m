//
//  ViewController.m
//  NSThread异步下载图片
//
//  Created by 王启正 on 2017/6/8.
//  Copyright © 2017年 王启正. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong)UIScrollView *scrollV;
@property(nonatomic,strong)UIImageView *imageV;

@end

@implementation ViewController

//改变控制器原本的view
-(void)loadView{
    [super loadView];
    self.scrollV=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view=self.scrollV;
    self.imageV=[[UIImageView alloc]init];
    [self.scrollV addSubview:self.imageV];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //开子线程下载图片
    NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(downloadImge) object:nil];
    [thread start];
    
}

-(void)downloadImge
{
    NSURL *url=[NSURL URLWithString:@"http://sc.jb51.net/uploads/allimg/150801/14-150P11H222500.jpg"];
    
    NSData *data=[NSData dataWithContentsOfURL:url];
    
    UIImage *image=[UIImage imageWithData:data];
    
    //主线程更新UI 县线程间的通信
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:NO];
}

-(void)updateUI:(UIImage *)ima
{
    self.imageV.image=ima;
    [self.imageV sizeToFit];
    self.scrollV.contentSize=ima.size;
    
}



@end
