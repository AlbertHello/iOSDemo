//
//  MaskView.m
//  
//
//  Created by 王启正 on 16/10/27.
//  Copyright © 2016年 北京对牛文化有限公司. All rights reserved.
//

#import "MaskView.h"
#import "AppDelegate.h" //若工程中的默认的AppDelegate的类名被自定义了，比如加了前缀，在此处改换即可

@implementation MaskView

//初始化View以及添加单击蒙层逻辑
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        //在这里需要用下边的方法设定Alpha值,第一种方法会使子视图的Alpha值和父视图的一样.
        //        self.backgroundColor = [UIColor colorWithRed:(40/255.0f) green:(40/255.0f) blue:(40/255.0f) alpha:1.0f];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

//蒙层
+(instancetype)makeMaskViewWithFrame:(CGRect)frame{
    return [[self alloc]initWithFrame:frame];
}

//单击蒙层remove
-(void)removeView{
    self.maskViewTapBlock();
}

//添加到父视图上
-(void)addToSuperView:(UIView *)view
{
    if (view != nil) {
        [view addSubview:self];
    }else{
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.window addSubview:self];
    }
}


@end
