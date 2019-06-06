//
//  ViewController.m
//  属性修饰符
//
//  Created by 王启正 on 2017/6/8.
//  Copyright © 2017年 王启正. All rights reserved.
//

#import "ViewController.h"

//此时本控制器是mrc环境
@interface ViewController ()

//block 为什么用copy修饰
///默认情况下，block是存档在栈中，可能被随时回收，通过copy操作可以使其在堆中保留一份, 相当于一直强引用着,
@property(nonatomic,copy)void (^myBlock)();
//字符串为什么用copy修饰
@property(nonatomic,strong)NSString *strongedStr;
@property(nonatomic,copy)NSString *copyedStr;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self demo1];
    [self demo2];
}

-(void)demo1{
    
    //第一种block 全局block 存在内存的代码区。
    void (^demoBlock1)()=^{
        
        NSLog(@"aa");
    };
    NSLog(@"%@",demoBlock1);// <__NSGlobalBlock__: 0x1033a6090>
    
    //第二种block 栈block 存在内存的栈区。block访问外部变量，而此时的block出了作用域就会被释放 。
    ///在ARC环境下编译器自动给block 拷贝了一份。所以要是在ARC环境下打印block2 则block2 存在堆区。但是MRC环境下的block才是本质。
    int number=3;
    void (^demoBlock2)()=^{
        
        NSLog(@"bb--%d",number);//block内部引用了外部的变量。
    };
    NSLog(@"%@",demoBlock2); // <__NSStackBlock__: 0x7fff5803b9d0>
    
    
    //第三种block 栈block 存在内存的堆区
    int num=3;
    void (^demoBlock3)()=^{
        
        NSLog(@"cc--%d",num);//block内部引用了外部的变量。
    };
    NSLog(@"%@",[demoBlock3 copy]);//经copy后 <__NSMallocBlock__: 0x600000054850>
    
    
    NSLog(@"******************************************");
    //下面开始测试block属性的修饰符 assign 和 copy
    [self testblock];
    
    //执行block
    self.myBlock();
    self.myBlock();
}

-(void)testblock
{
    int num=10;
    //给属性myBlock赋值
    [self setMyBlock:^{
       
        NSLog(@"%d",num);
    }];
    NSLog(@"%@",self.myBlock);//当修饰符是assign时是栈block，执行完block的作用域之后就会系统释放了。myBlock成了野指针。所以第二次执行self.myBlock();就会报错。当把修饰符改成copy，此时就是堆block，就不会报错了。
}


-(void)demo2
{
    NSMutableString *sourceStr=[NSMutableString string];
    [sourceStr appendString:@"hello"];
    
    self.strongedStr=sourceStr;//sourceStr 是可变字符串。他指向[NSMutableString string]这句代码产生的内存空间。的当用strong修饰符修饰时，self.strongedStr的就是指向了跟sourceStr指向的同一个地址，所以改变sourceStr，则self.strongedStr也会跟着变。
    self.copyedStr=sourceStr;//sourceStr 是可变字符串，copy修饰符会先把sourceStr 进行深拷贝，之后sourceStr再怎么变也不会影响self.copyedStr的值
    [sourceStr appendString:@" world"];
    
    NSLog(@"%@",self.strongedStr);
    NSLog(@"%@",self.copyedStr);
}
























@end
