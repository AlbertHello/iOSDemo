//
//  ViewController.m
//  01-瀑布流
//
//  Created by xiaomage on 15/8/7.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGWaterflowLayout.h"

@interface ViewController () <UICollectionViewDataSource>

@end

@implementation ViewController

static NSString * const XMGShopId = @"shop";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建布局
    XMGWaterflowLayout *layout = [[XMGWaterflowLayout alloc] init];
    
    // 创建CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    // 注册
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:XMGShopId];
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XMGShopId forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor orangeColor];

    NSInteger tag = 10;
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:tag];
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.tag = tag;
        [cell.contentView addSubview:label];
    }

    label.text = [NSString stringWithFormat:@"%zd", indexPath.item];
    [label sizeToFit];
    
    return cell;
}
@end
