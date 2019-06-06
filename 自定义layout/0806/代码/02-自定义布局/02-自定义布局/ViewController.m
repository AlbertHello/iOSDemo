//
//  ViewController.m
//  02-自定义布局
//
//  Created by xiaomage on 15/8/6.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGLineLayout.h"
#import "XMGPhotoCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@end

@implementation ViewController

static NSString * const XMGPhotoId = @"photo";

- (void)viewDidLoad {
    [super viewDidLoad];
    
//
//    UIImageView *ima=[[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    ima.image=[UIImage imageNamed:@"1"];
//    [self.view addSubview:ima];
//
//    ima.layer.shadowColor = [UIColor blackColor].CGColor;
//    ima.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
//    ima.layer.shadowOpacity = 1.0f;
//    ima.layer.shadowRadius=4.0;
    
    
    
    
    
    
    // 创建布局
    XMGLineLayout *layout = [[XMGLineLayout alloc] init];
    layout.itemSize = CGSizeMake(190, 190);
    
    
//    UICollectionViewFlowLayout *lal=[[UICollectionViewFlowLayout alloc]init];
//    lal.itemSize=CGSizeMake(200, 200);
//    lal.minimumInteritemSpacing=10;
//    lal.scrollDirection=UICollectionViewScrollDirectionHorizontal;

    // 创建CollectionView
    CGFloat collectionW = self.view.frame.size.width;
    CGFloat collectionH = 200;
    CGRect frame = CGRectMake(0, 150, collectionW, collectionH);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:collectionView];

    // 注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGPhotoCell class]) bundle:nil] forCellWithReuseIdentifier:XMGPhotoId];
    
    // 继承UICollectionViewLayout
    // 继承UICollectionViewFlowLayout
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XMGPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XMGPhotoId forIndexPath:indexPath];
    
    cell.imageName = [NSString stringWithFormat:@"%zd", indexPath.item + 1];
    
    cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(2.0,2.0);
    cell.layer.shadowRadius = 4.0f;
    cell.layer.shadowOpacity = 1.0f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"------%zd", indexPath.item);
}
@end
