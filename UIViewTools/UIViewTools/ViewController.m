//
//  ViewController.m
//  UIViewTools
//
//  Created by 王启正 on 2017/8/22.
//  Copyright © 2017年 老王. All rights reserved.
//

#import "ViewController.h"
#import "UIView+ZZFrame.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor redColor];
    UIImageView *iV=[[UIImageView alloc]init];
    
    iV.x=10;
    iV.y=70;
    iV.width=100;
    iV.height=100;
    
    iV.image=[UIImage imageNamed:@"avatr03.JPG"];
    iV.backgroundColor=[UIColor blackColor];
    [self.view addSubview:iV];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
