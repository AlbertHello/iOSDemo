//
//  ViewController.m
//  GCD
//
//  Created by 王启正 on 2017/6/9.
//  Copyright © 2017年 王启正. All rights reserved.
//

#import "ViewController.h"
#import "CustomOperation.h"

#define SECONDS_PER_YEAR (60 * 60 * 24 * 365)UL

@interface ViewController ()

@property(nonatomic,strong)NSMutableArray *imageArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    
    
    
    //GCD
//    [self demo1];
//    [self demo2];
//    [self demo3];
//    [self demo4];
//    [self demo_barrier];
//    [self demo_semphore];
    
    
    //NSOperation
//    [self useBlockOperationAddExecutionBlock];
//    [self useCustomOperation];
//    [self addOperationToQueue];
//    [self addOperationWithBlockToQueue];
//    [self setMaxConcurrentOperationCount];
    
    
    //性能调优
//    [self ColorBlendedLayers];
//    [self ColorMisalignedImages];
    [self offScreenRendering];
    
    
}


//混合图层
-(void)ColorBlendedLayers{
    
    ///Blended Layer是因为这些Layer是透明的(Transparent)，系统在渲染这些view时需要将该view和下层view混合(Blend)后才能计算出该像素点的实际颜色.
    
    //把label的背景颜色设置成不透明，并且把设置masksToBounds属性为yes，才能避免混合图层。
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    label.backgroundColor=[UIColor whiteColor];
    label.layer.masksToBounds=YES;
//    label.opaque=YES//iOS8以后label再设置这个值已经没有作用了。
    label.text=@"哈哈哈哈哈哈";
    [self.view addSubview:label];
}
//图片的缩放和像素不对齐
-(void)ColorMisalignedImages{
    //这个选项检查了图片是否被放缩,像素是否对齐。
//    被放缩的图片会被标记为黄色,像素不对齐则会标注为紫色。
//    如果不对齐此时系统需要对相邻的像素点做anti-aliasing反锯齿计算，会增加图形负担
//    通常这种问题出在对某些View的Frame重新计算和设置时产生的。
    
//    当图片的size和显示图片View的size不同 或 图片的scale和屏幕的scale不同，就会发生像素不对齐的问题。要想像素对齐，必须保证image.size和显示图片view.size相等 且 image.scale和 [UIScreen mainScreen].scale相等
    UIImageView *imagev=[[UIImageView alloc]initWithFrame:CGRectMake(100, 250, 100, 100)];
    imagev.image=[self reDrawImageWithCGRect:imagev.frame.size withOldImage:[UIImage imageNamed:@"hackAvatr"]];
    [self.view addSubview:imagev];
}
///根据目标尺寸重绘图片.防止图片的缩放
-(UIImage *)reDrawImageWithCGRect:(CGSize)size withOldImage:(UIImage *)oldimage{
    if (CGSizeEqualToSize(size, oldimage.size)) {
        return oldimage;
    }
    //创建上下文  参数：目标尺寸大小，设置opaque=YES，设置新图片的分辨率和屏幕分辨率相同
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    //绘图
    [oldimage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //获取新图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    return image;
}

///离屏渲染
-(void)offScreenRendering{
    ///离屏渲染，指的是 GPU 或 CPU 在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作。过程中需要切换 contexts (上下文环境),先从当前屏幕切换到离屏的contexts，渲染结束后，又要将 contexts 切换回来，所以这种Offscreen-Rendering会导致app的图形性能下降。大部分Offscreen-Rendering都是和视图Layer的Shadow和Mask相关。
    //下列情况会导致视图的Offscreen-Rendering：
    //使用Core Graphics (CG开头的类)；
    //使用drawRect()方法，即使为空；
    //将CALayer的属性shouldRasterize设置为YES；
    //使用了CALayer的setMasksToBounds(masks)和setShadow*(shadow)方法。
    
    UIImageView *imagev=[[UIImageView alloc]initWithFrame:CGRectMake(100, 400, 100, 100)];
    imagev.image=[UIImage imageNamed:@"3.jpg"];
    [self.view addSubview:imagev];
    
    
    //1、shadow
    // 这种情况下造成离屏渲染
//    imagev.layer.shadowColor = [UIColor greenColor].CGColor;//阴影颜色
//    imagev.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
//    imagev.layer.shadowOpacity = 0.5;//不透明度
//    imagev.layer.shadowRadius = 10.0;//半径
    //解决办法：设置阴影后，设置CALayer的 shadowPath
//    imagev.layer.shadowPath=[UIBezierPath bezierPathWithRect:imagev.bounds].CGPath;

    
    //2、圆角
    //masksToBounds = true +  cornerRadius > 0 (常见的设置圆角手段)
    //使用cornerRadius进行切圆角，在iOS9之前会产生离屏渲染，比较消耗性能，而之后系统做了优化，则不会产生离屏渲染，但是操作最简单
//    imagev.layer.cornerRadius=5;
//    imagev.layer.masksToBounds=YES;
//    [self settingCornerRadiusByMaskWithView:imagev];
    
    
}

//圆角第二种方法
//利用mask设置圆角，利用的是UIBezierPath和CAShapeLayer来完成
-(void)settingCornerRadiusByMaskWithView:(UIView *)targetView{
    CAShapeLayer *mask1 = [[CAShapeLayer alloc] init];
    mask1.opacity = 0.5;
    mask1.path = [UIBezierPath bezierPathWithOvalInRect:targetView.bounds].CGPath;
    targetView.layer.mask = mask1;
}
//圆角第三种方法
- (UIImage *)drawCircleImage:(UIImage*)image{
    CGFloat side = MIN(image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(side, side), false, [UIScreen mainScreen].scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, side, side)].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    CGFloat marginX = -(image.size.width - side) * 0.5;
    CGFloat marginY = -(image.size.height - side) * 0.5;
    [image drawInRect:CGRectMake(marginX, marginY, image.size.width, image.size.height)];
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}







-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}


//串行队列，同步执行
-(void)demo1{
    //串行队列
    dispatch_queue_t qq=dispatch_queue_create("demo1", DISPATCH_QUEUE_SERIAL);
    //同步执行。不会开辟子线程
    dispatch_sync(qq, ^{
        NSLog(@"hello %@",[NSThread currentThread]);
    });
}

//串行队列，异步执行
-(void)demo2{
    //串行队列，任务按顺序执行
    dispatch_queue_t qq=dispatch_queue_create("demo2", DISPATCH_QUEUE_SERIAL);
    //异步执行,开辟子线程
    for (int i=0; i<10; i++) {
        dispatch_async(qq, ^{
            NSLog(@"hello %d %@",i,[NSThread currentThread]);
        });
    }
    
}
//并行队列，同步执行。在主线程中依次执行
-(void)demo3{
    //并行队列，
    dispatch_queue_t qq=dispatch_queue_create("demo3", DISPATCH_QUEUE_CONCURRENT);
    //同步执行
    for (int i=0; i<10; i++) {
        dispatch_sync(qq, ^{
            NSLog(@"hello %d %@",i,[NSThread currentThread]);
        });
    }
    
}
//并行队列，异步执行。开辟多个子线程多个任务不定顺序执行。
-(void)demo4{
    //并行队列，
    dispatch_queue_t qq=dispatch_queue_create("demo4", DISPATCH_QUEUE_CONCURRENT);
    //异步执行
    for (int i=0; i<10; i++) {
        dispatch_async(qq, ^{
            NSLog(@"hello %d %@",i,[NSThread currentThread]);
        });
    }
    
}

//模拟网络下载多张图片，并且把多多张图片添加到mutableArray中。
-(void)demo_barrier
{
    dispatch_queue_t qq=dispatch_queue_create("demo_barrier", DISPATCH_QUEUE_CONCURRENT);
    for (int i=0 ; i<100; i++) {
        dispatch_async(qq, ^{
            
            NSString *file=[NSString stringWithFormat:@"%d",i%8+1];
            NSString *filePath=[[NSBundle mainBundle]pathForResource:file ofType:@"jpg"];
            UIImage *image=[UIImage imageWithContentsOfFile:filePath];
            NSLog(@"下载第%d张",i);
            //等待队列中的所有任务完成后才会执行barrier中的代码
            //dispatch_barrier_async 只能用在异步的并行队列中才有用。
            //在并行队列中，为了保持某些任务的顺序，需要等待一些任务完成后才能继续进行，使用 barrier 来等待之前任务完成，避免数据竞争等问题。
            dispatch_barrier_async(qq, ^{
                
                [self.imageArray addObject:image];
                NSLog(@"保存第%d张",i);
                
            });
        });
    }
    
}

//信号量，防止多线程资源抢夺，控制并发队列线程的个数。
-(void)demo_semphore{
    
    /**
     dispatch_semaphore_create 创建一个semaphore
     dispatch_semaphore_signal 发送一个信号
     dispatch_semaphore_wait 等待信号
     第一个函数有一个整形的参数，我们可以理解为信号的总量，dispatch_semaphore_signal是发送一个信号，自然会让信号总量加1，dispatch_semaphore_wait等待信号，当信号总量少于0的时候就会一直等待，否则就可以正常的执行，并让信号总量-1，
     */
    
    // 创建信号量，并且设置值为10,10代表最多允许的线程个数。
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 100; i++)
    {   // 由于是异步执行的，所以每次循环Block里面的dispatch_semaphore_signal根本还没有执行就会执行dispatch_semaphore_wait，从而semaphore-1.当循环10此后，semaphore等于0，则会阻塞线程，直到执行了Block的dispatch_semaphore_signal 才会继续执行
        NSLog(@"等待%i, %@",i,[NSThread currentThread]);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async( queue, ^{
            NSLog(@"执行%i, %@",i,[NSThread currentThread]);
            sleep(2);
            // 每次发送信号则semaphore会+1，
            dispatch_semaphore_signal(semaphore);
        });
    }
    
}




///NSOperation 实现多线程的使用步骤分为三步：
///1、创建操作：先将需要执行的操作封装到一个 NSOperation 对象中。
///2、创建队列：创建 NSOperationQueue 对象
///3、将操作加入到队列中：将 NSOperation 对象添加到 NSOperationQueue 对象中。
///之后系统就会自动将 NSOperationQueue 中的 NSOperation 取出来，在新线程中执行操作。

///NSOperation 是个抽象类，不能用来封装操作。我们只有使用它的子类来封装操作。我们有三种方式来封装操作。
///1.使用子类 NSInvocationOperation
///2.使用子类 NSBlockOperation
///3.自定义继承自 NSOperation 的子类，通过实现内部相应的方法来封装操作.



/**
  1、 在没有使用 NSOperationQueue、在主线程中单独使用使用子类 NSInvocationOperation 执行一个操作的情况下，操作是在当前线程执行的，并没有开启新线程。
 * 使用子类 NSInvocationOperation
 */
- (void)useInvocationOperation {
    
    // 1.创建 NSInvocationOperation 对象
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    // 2.调用 start 方法开始执行操作
    [op start];
    
    // 在其他线程使用子类 NSInvocationOperation
    //在其他线程中单独使用子类 NSInvocationOperation，操作是在当前调用的其他线程执行的，并没有开启新线程
//    [NSThread detachNewThreadSelector:@selector(useInvocationOperation) toTarget:self withObject:nil];
}
/**
 * 任务1
 */
- (void)task1 {
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
        NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
    }
}
- (void)task2 {
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
        NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
    }
}

/**
 * 使用子类 NSBlockOperation
 */
- (void)useBlockOperation {
    
    // 1.创建 NSBlockOperation 对象
    //在没有使用 NSOperationQueue、在主线程中单独使用 NSBlockOperation 执行一个操作的情况下，操作是在当前线程执行的，并没有开启新线程。
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    // 2.调用 start 方法开始执行操作
    [op start];
    
}
//NSBlockOperation 还提供了一个方法 addExecutionBlock:，通过 addExecutionBlock: 就可以为 NSBlockOperation 添加额外的操作。这些操作（包括 blockOperationWithBlock 中的操作）可以在不同的线程中同时（并发）执行。只有当所有相关的操作已经完成执行时，才视为完成。
/**
 * 使用子类 NSBlockOperation
 * 调用方法 AddExecutionBlock:
 */
- (void)useBlockOperationAddExecutionBlock {
    
    // 1.创建 NSBlockOperation 对象
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    // 2.添加额外的操作. 会开辟新线程
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    //会开辟新线程
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    // 3.调用 start 方法开始执行操作
    [op start];
    
    //一般情况下，如果一个 NSBlockOperation 对象封装了多个操作。NSBlockOperation 是否开启新线程，取决于操作的个数。如果添加的操作的个数多，就会自动开启新线程。当然开启的线程数是由系统来决定的。
}


/**
 * 使用自定义继承自 NSOperation 的子类
 */
- (void)useCustomOperation {
    // 1.创建 YSCOperation 对象
    //：在没有使用 NSOperationQueue、在主线程单独使用自定义继承自 NSOperation 的子类的情况下，是在主线程执行操作，并没有开启新线程。
    CustomOperation *op = [[CustomOperation alloc] init];
    // 2.调用 start 方法开始执行操作
    [op start];
}


///创建队列

//NSOperationQueue 一共有两种队列：主队列、自定义队列。其中自定义队列同时包含了串行、并发功能。

// 主队列获取方法.凡是添加到主队列中的操作，都会放到主线程中执行。
//NSOperationQueue *queue = [NSOperationQueue mainQueue];

// 自定义队列创建方法.
//1.添加到这种队列中的操作，就会自动放到子线程中执行。
//2.同时包含了：串行、并发功能。
//NSOperationQueue *queue = [[NSOperationQueue alloc] init];


/**
 * 使用 addOperation: 将操作加入到操作队列中
 */
- (void)addOperationToQueue {
    
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2.创建操作
    // 使用 NSInvocationOperation 创建操作1
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    
    
    // 使用 NSInvocationOperation 创建操作2
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2) object:nil];
    
    // 使用 NSBlockOperation 创建操作3
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op3 addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    // 3.使用 addOperation: 添加所有操作到队列中
    [queue addOperation:op1]; // [op1 start]
    [queue addOperation:op2]; // [op2 start]
    [queue addOperation:op3]; // [op3 start]
    
//    使用 NSOperation 子类创建操作，并使用 addOperation: 将操作加入到操作队列后能够开启新线程，进行并发执行
}
/**
 * 使用 addOperationWithBlock: 将操作加入到操作队列中
 */

- (void)addOperationWithBlockToQueue {
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2.使用 addOperationWithBlock: 添加操作到队列中
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
//    使用 addOperationWithBlock: 将操作加入到操作队列后能够开启新线程，进行并发执行
}

///NSOperationQueue 控制串行执行

//maxConcurrentOperationCount，叫做最大并发操作数.maxConcurrentOperationCount 控制的不是并发线程的数量，而是一个队列中同时能并发执行的最大操作数。而且一个操作也并非只能在一个线程中运行。
//1.maxConcurrentOperationCount 默认情况下为-1，表示不进行限制，可进行并发执行。
//2.maxConcurrentOperationCount 为1时，队列为串行队列。只能串行执行
//3.maxConcurrentOperationCount 大于1时，队列为并发队列。操作并发执行，当然这个值不应超过系统限制，即使自己设置一个很大的值，系统也会自动调整为 min{自己设定的值，系统设定的默认最大值}。
/**
 * 设置 MaxConcurrentOperationCount（最大并发操作数）
 */
- (void)setMaxConcurrentOperationCount {
    
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2.设置最大并发操作数
//    queue.maxConcurrentOperationCount = 1; // 串行队列
     queue.maxConcurrentOperationCount = 2; // 并发队列
    // queue.maxConcurrentOperationCount = 8; // 并发队列
    
    // 3.添加操作
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    //可以看出：当最大并发操作数为1时，操作是按顺序串行执行的，并且一个操作完成之后，下一个操作才开始执行。当最大操作并发数为2时，操作是并发执行的，可以同时执行两个操作。而开启线程数量是由系统决定的，不需要我们来管理。
    
}























@end
