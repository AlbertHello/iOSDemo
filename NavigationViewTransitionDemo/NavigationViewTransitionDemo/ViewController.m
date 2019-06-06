//
//  ViewController.m
//  NavigationViewTransitionDemo
//
//  Created by 王启正 on 2017/7/17.
//  Copyright © 2017年 王启正. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *headerView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blueColor];
     //设置 导航条透明度为alpha  不影响其他按钮
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:0];
    
    UIButton *leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"search_close"] forState:UIControlStateNormal];
    [leftButton sizeToFit];
    UIBarButtonItem *lef=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=lef;
    
    UILabel *label=[[UILabel alloc]init];
    label.text=@"测试";
    [label sizeToFit];
    self.navigationItem.titleView=label;
    
    self.tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor=[UIColor blueColor];
    
    self.headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    self.headerView.backgroundColor=[UIColor brownColor];
    
    self.tableView.tableHeaderView=self.headerView;
    
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text=[NSString stringWithFormat:@"第%ld个cell",indexPath.row];
    
    
    return cell;
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==self.tableView) {
        CGFloat offset=self.tableView.contentOffset.y+64;
        NSLog(@"偏移量：%.f",offset);
        
        if (offset<200) {
            [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:offset/200.0];
        }else{
            [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:1];
        }
        
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
