//
//  ViewController.m
//  深拷贝和浅拷贝
//
//  Created by 王启正 on 2017/6/5.
//  Copyright © 2017年 王启正. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor redColor];
    [self test_1];
//    [self test_2];
//    [self test_3];
//    [self test_4];
//    [self test_5];//测试可变容器的完全拷贝
    
    
    
}

-(void)test_1
{
    NSLog(@"非容器类不可变对象拷贝NSString");
    NSString *str = @"测试字符串";
     NSLog(@" str = %@,     init_s_retainCount = %d", str, (int)str.retainCount);
    //init_s_retainCount = -1
    

    //把str通过retain方式把值赋给str1
    NSString *str1 = [str retain];
     NSLog(@" str1 = %@,     retain_str1_retainCount = %d", str1, (int)str1.retainCount);
    //retain_str1_retainCount = -1
    
    
    
    //把str通过copy的方式把值赋给str2
    NSString *str2 = [str copy];
    NSLog(@" str2 = %@,     copy_str2_retainCount = %d", str2, (int)str2.retainCount);
    //copy_str2_retainCount = -1
    
    
    
    //把str通过mutableCopy的方式把值赋给str3
    NSMutableString *str3 = [str mutableCopy];
    NSLog(@" str3 = %@,  mutableCopy_str3_retainCount = %d", str3, (int)str3.retainCount);
    //mutableCopy_str3_retainCount = 1

    
    
    //分别输出每个字符串的内存地址
    NSLog(@" str-p = %p", str);//0x1008b8088
    NSLog(@"str1-p = %p", str1);//0x1008b8088
    NSLog(@"str2-p = %p", str2);//0x1008b8088
    NSLog(@"str3-p = %p", str3);//0x60000007fb00
    
    
//    代码运行结果分析：
//    //retainCount=-1 是因为str为字符串常量，系统会用UINT_MAX来标记，系统不收回，也不做引用计数
//    1. 对于非容器类的不可变对象retain和copy为浅拷贝，mutableCopy为深拷贝
//    
//    2. 浅拷贝获得的对象的地址和原有对象retainCount=-1的地址一致
//    
//    3.而深拷贝返回新的内存地址，并且返回的对象为可变对象
}
-(void)test_2
{
    NSLog(@"非容器类的可变对象的拷贝");
    NSMutableString *s = [NSMutableString stringWithFormat:@"ludashi"];
    NSLog(@" s = %@,     init_s_retainCount = %d", s, (int)s.retainCount);
    //init_s_retainCount = 1
    
    
    //把s通过retain的方式把值 赋给s1;
    NSMutableString *s1 = [s retain];
    NSLog(@"s1 = %@,  retain_s1_retainCount = %d", s1, (int)s1.retainCount);
    //retain_s1_retainCount = 2
    
    //把s通过copy的方式把值赋给s2;
    NSMutableString *s2 = [s copy];
    NSLog(@"s2 = %@,    copy_s2_retianCount = %d", s2, (int)s2.retainCount);
    //copy_s2_retianCount = -1
    
    
    //把s通过mutableCopy的方式把值赋给s3
    NSMutableString *s3 = [s mutableCopy];
    NSLog(@"s3 = %@ mutable_s3_retainCount = %d", s3, (int)s3.retainCount);
    //mutable_s3_retainCount = 1
    
    
    
    
    
    //打印每个非容器类可变对象的地址
    NSLog(@" s_p = %p", s);//s_p = 0x608000076200
    NSLog(@"s1_p = %p", s1);//s1_p = 0x608000076200
    NSLog(@"s2_p = %p", s2);//s2_p = 0xa6968736164756c7
    NSLog(@"s3_p = %p", s3);//s3_p = 0x600000079280
    
//    运行结果分析：
//    
//    1.retian对可变对象为浅拷贝,使源对象的retainCount加一
//    
//    2.copy对可变对象非容器类为深拷贝。
//    
//    3.mutableCopy对可变非容器类为深拷贝
}


-(void)test_3
{
    //第二种：容器类不可变对象的拷贝
    NSMutableString *string = [NSMutableString stringWithFormat:@"ludashi"];
    NSLog(@"容器类不可变对象拷贝");
    NSArray *array = [NSArray arrayWithObjects:string, @"b", nil];
    NSLog(@" array[0] = %@,</a>    init_array.retainCount = %d", array[0], (int)array.retainCount);
    //init_array.retainCount = 1
    
          
      //把array通过retain方式把值赋给array1
      NSArray *array1 = [array retain];
      NSLog(@"array1[0] = %@,retain_array1.retainCount = %d", array1[0], (int)array1.retainCount);
    //retain_array1.retainCount = 2
    
    
                
    //把array通过copy的方式把值赋给array2
    NSArray *array2 = [array copy];
    NSLog(@"array2[0] = %@,</a>    copy_array.retainCount = %d", array2[0], (int)array2.retainCount);
    //copy_array.retainCount = 3
    
      //把array通过mutableCopy方式把值赋给array3
      NSArray *array3 = [array mutableCopy];
      NSLog(@"array3[0] = %@,</a> mutableCopy_array3.retainCount = %d", array3[0], (int)array3.retainCount);
    //mutableCopy_array3.retainCount = 1
    
    
    //分别输出每个地址
    NSLog(@"分别输出每个地址");
    NSLog(@" array_p = %p", array);//0x600000022fc0
    NSLog(@"array1_p = %p", array1);//0x600000022fc0
    NSLog(@"array2_p = %p", array2);//0x600000022fc0
    NSLog(@"array3_p = %p", array3);//0x608000057850
    
    //分别输出每个地址
    NSLog(@"分别输出拷贝后数组中第一个元素的地址");
    NSLog(@" array_p[0] = %p", array[0]);//0x60800006e380
    NSLog(@"array1_p[0] = %p", array1[0]);//0x60800006e380
    NSLog(@"array2_p[0] = %p", array2[0]);//0x60800006e380
    NSLog(@"array3_p[0] = %p", array3[0]);//0x60800006e380
    
    ///对容器类的非可变对象进行测试，有程序的运行结果可知当使用mutableCopy时确实返回了一个新的容器（由内存地址可以看出），但从容器对象看而言是容器的深拷贝，但从输出容器中的元素是容器的浅拷贝
}

-(void)test_4
{
    NSLog(@"********************************************nnnn");
    //第四种：容器类的可变对象的拷贝，用NSMutableArray来实现
    NSLog(@"容器类的可变对象的拷贝");
//    NSString *string = [NSString stringWithFormat:@"ludashi"];
    NSString *string = @"ludashi";
    NSMutableArray *m_array = [NSMutableArray arrayWithObjects:string, nil];
    NSLog(@" m_array[0] = %@,</a>     init_m_array_retainCount = %d", m_array[0], (int)m_array.retainCount);
    //init_m_array_retainCount = 1
    
          
  //把m_array通过retain把值赋给m_array1
  NSMutableArray *m_array1 = [m_array retain];
  NSLog(@"m_array1[0] = %@,</a>  retain_m_array1_retainCount = %d", m_array1[0], (int)m_array1.retainCount);
    //retain_m_array1_retainCount = 2
    
    
    
    //把m_array通过copy把值赋给m_array2
    NSMutableArray *m_array2 = [m_array copy];
    NSLog(@"m_array2[0] = %@,</a>    copy_m_array2_retainCount = %d", m_array2[0], (int)m_array2.retainCount);
    //copy_m_array2_retainCount = 1
    
    
      //把m_array通过mytableCopy把值赋给m_array3
      NSMutableArray *m_array3 = [m_array mutableCopy];
      NSLog(@"m_array3[0] = %@,</a> mutable_m_array3_retainCount = %d", m_array3[0], (int)m_array3.retainCount );
    //mutable_m_array3_retainCount = 1
    
    //打印输出每个可变容器对象的地址
    NSLog(@"打印输出每个可变容器对象的地址");
    NSLog(@" m_array_p = %p", m_array);//0x600000046ff0
    NSLog(@"m_array_p1 = %p", m_array1);//0x600000046ff0
    NSLog(@"m_array_p2 = %p", m_array2);//0x608000012b80
    NSLog(@"m_array_p3 = %p", m_array3);//0x600000046ea0
    
    //打印输出每个可变容器中元素的地址
    NSLog(@"打印输出每个可变容器中元素的地址");
    NSLog(@" m_array_p[0] = %p", m_array[0]);//0x600000076440
    NSLog(@"m_array_p1[0] = %p", m_array1[0]);//0x600000076440
    NSLog(@"m_array_p2[0] = %p", m_array2[0]);//0x600000076440
    NSLog(@"m_array_p3[0] = %p", m_array3[0]);//0x600000076440
    
    
    
    ///对容器类的可变对象进行测试，copy和mutableCopy对于容器本身是深拷贝，原因是返回了一个新的容器地址，但对于容器中的元素仍然是浅拷贝。
}

/**
     1.retain：始终是浅复制。引用计数每次加一。返回对象是否可变与被复制的对象保持一致。
     2.copy：对于可变对象为深复制，引用计数不改变;对于不可变对象是浅复制， 引用计数每次加一。始终返回一个不可变对象。
     3.mutableCopy：始终是深复制，引用计数不改变。始终返回一个可变对象。
 */


//测试可变容器的完全拷贝
-(void)test_5
{
    //新建一个测试字符串
    NSMutableString * str = [NSMutableString stringWithFormat:@"ludashi__"];
    
    //新建一个测试字典
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:str forKey:@"key1"];
    
    //把字典存入数组中
    NSMutableArray *oldArray = [NSMutableArray arrayWithObject:dic];
    
    //用就得数组生成新的数组
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:oldArray];
    
    //用copyItems拷贝数组中的元素
    NSMutableArray *copyItems = [[NSMutableArray alloc] initWithArray:oldArray copyItems:YES];
    
    //把数组归档成一个NSData,然后再实现完全拷贝
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:oldArray];
    NSMutableArray *multable = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    //往字典中加入新的值
    [dic setObject:@"new_value1" forKey:@"key2"];
    //改变str的值
    [str appendString:@"update"];
    NSLog(@"%@", oldArray);
    /**
     {
     key1 = "ludashi__update";
     key2 = "new_value1";
     }
     */
    NSLog(@"%@", newArray);
    /**
     {
     key1 = "ludashi__update";
     key2 = "new_value1";
     }
     */
    
    NSLog(@"%@", copyItems);
    /**
     {
     key1 = "ludashi__update";
     }
     */
    
    NSLog(@"%@", multable);
    /**
     {
     key1 = "ludashi__";
     }
     */
    
    //每个数组的地址为：
    NSLog(@"%p", oldArray);//0x60800005e060
    NSLog(@"%p", newArray);//0x60800005e4e0
    NSLog(@"%p", copyItems);//0x60800005e510
    NSLog(@"%p", multable);//0x60800005e360
    
}















@end
