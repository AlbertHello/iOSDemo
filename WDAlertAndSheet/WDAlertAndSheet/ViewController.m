//
//  ViewController.m
//  WDActionSheet
//
//  Created by 王启正 on 2017/8/18.
//  Copyright © 2017年 文都. All rights reserved.
//

#import "ViewController.h"
#import "WDAlertAndSheet.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSString *_title;
    NSString *_message;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableDictionary *dataSourse;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"Alert And Sheet";
    
    _title=@"静夜思";
    _message=@"窗前明月光\n疑是地上霜\n举头望明月\n低头思故乡";
    
    NSArray *alertArray=@[@"有标题有两个按钮",
                          @"没有标题有两个按钮",
                          @"没有标题有一个按钮",
                          @"没有标题没有按钮",
                          @"有标题有内容",
                          @"系统"
                          ];
    
    NSArray *sheetArray=@[@"title和destructBtn和其他按钮和取消按钮",
                          @"destructBtn和其他按钮和取消按钮",
                          @"其他按钮和取消按钮",
                          @"DestructBtn和取消按钮",
                          @"title和DestructBtn和取消按钮",
                          @"title和其他按钮和取消按钮",
                          @"系统"];
    NSArray *multiMenuArr=@[@"有标题有内容的多级菜单",@"有标题无内容的多级菜单",@"无标题有内容的多级菜单",@"无标题无内容的多级菜单",];
    [self.dataSourse setObject:alertArray forKey:@"alert"];
    [self.dataSourse setObject:sheetArray forKey:@"sheet"];
    [self.dataSourse setObject:multiMenuArr forKey:@"multiMenu"];
    [self.view addSubview:self.tableView];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(interfaceOrientationDidChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
}

-(NSMutableDictionary *)dataSourse{
    
    if (!_dataSourse) {
        _dataSourse=[[NSMutableDictionary alloc]init];
    }
    return _dataSourse;
}

-(UITableView *)tableView{
    if (!_tableView) {
        
        _tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor brownColor];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=[[UIView alloc]init];
    }
    return _tableView;
}


#pragma mark - tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"AlertView";
    }else if(section==1){
        return @"ActionSheetView";
    }else{
        return @"多级菜单Alert";
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return [self.dataSourse[@"alert"] count];
    }else if(section==1){
        return [self.dataSourse[@"sheet"] count];
    }else{
        return [self.dataSourse[@"multiMenu"] count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.section==0) {
        
        cell.textLabel.text=self.dataSourse[@"alert"][indexPath.row];
    } else if(indexPath.section==1){
        cell.textLabel.text=self.dataSourse[@"sheet"][indexPath.row];
        if ([self.dataSourse[@"sheet"] count]-1 == indexPath.row) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                cell.textLabel.text=nil;
            }
        }
        
    }else{
        cell.textLabel.text=self.dataSourse[@"multiMenu"][indexPath.row];
    }
    cell.textLabel.numberOfLines=0;
    cell.textLabel.font=[UIFont boldSystemFontOfSize:17];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        [self dealDifferentStyleOfAlertViewWithIndex:indexPath.row];
    } else if(indexPath.section==1){
        if ([self.dataSourse[@"sheet"] count]-1 == indexPath.row) {
            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
                [self dealDifferentStyleOfActionSheetWithIndex:indexPath.row];
            }
        }else{
            [self dealDifferentStyleOfActionSheetWithIndex:indexPath.row];
        }
    }else{
        
        [self dealMultiMenuAlertWithIndex:indexPath.row];
    }
}
//AlertView
-(void)dealDifferentStyleOfAlertViewWithIndex:(NSInteger)index{
    
    __weak __typeof(self)weakSelf=self;
    switch (index) {
        case 0:{
            [WDAlertView showAlertWithTitle:@"我们是谁" message:@"我们是程序猿☺️" cancleButtonTitle:@"取消" confirmButtonTitle:@"确定" cancleBlock:^{
                NSLog(@"取消");
            } confirmBlcok:^{
                NSLog(@"确定");
            }];
            break;
        }
        case 1:{
            [WDAlertView showAlertWithMessage:@"将从您的个人账户扣十几来块钱" cancleButtonTitle:@"别介啊" confirmButtonTitle:@"您随便" cancleBlock:^{
                NSLog(@"cancle");
            } confirmBlcok:^{
                NSLog(@"confirm");
            }];
            break;
        }
        case 2:{
            [WDAlertView showAlertWithMessage:@"获取图像资源" buttonTitle:@"嗯呐" buttonClickBlock:^{
                NSLog(@"ok.");
                [weakSelf getPhotos];
            }];
            break;
        }
        case 3:{
            [WDAlertView showToastWithText:@"一句话的事儿"];
            break;
        }
        case 4:{
            [WDAlertView showToastWithTitle:@"听说这儿是标题" message:@"咦，你这弄啥嘞，可不标题呀！"];
            break;
        }
        case 5:{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:_title message:_message delegate:nil cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            [alert show];
            break;
        }
        default:
            break;
    }
}
//actionSheet
-(void)dealDifferentStyleOfActionSheetWithIndex:(NSInteger)index{
    
    NSArray *otherBtnTitle=@[@"只看女生",@"只看男生",@"查看全部"];
    __weak __typeof(self)weakSelf=self;
    switch (index) {
        case 0:{
            
            [WDActionSheetView showActionSheetWithTitle:@"标题" cancleBtnTitle:@"取消" destructiveBtnTitle:@"删除" otherBtnTitles:otherBtnTitle actionBlock:^(NSInteger index) {
                NSLog(@"第%ld个button",index);
            }];
        }
            break;
        case 1:
        {
            [WDActionSheetView showActionSheetWithCancleBtnTitle:@"取消" destructiveBtnTitle:@"删除" otherBtnTitles:otherBtnTitle actionBlock:^(NSInteger index) {
                NSLog(@"第%ld个button",index);
                if (index==0) {
                    [weakSelf deleteAction];
                }
            }];
            break;
        }
        case 2:
        {
            [WDActionSheetView showActionSheetWithCancleBtnTitle:@"取消" otherBtnTitles:otherBtnTitle actionBlock:^(NSInteger index) {
                [WDActionSheetView showActionSheetWithCancleBtnTitle:@"取消" otherBtnTitles:@[@"啥也不给看，哈哈😄"] actionBlock:^(NSInteger index) {
                    
                }];
            }];
            break;
        }
        case 3:
        {
            [WDActionSheetView showActionSheetWithCancleBtnTitle:@"取消" destructiveBtnTitle:@"删除" actionBlock:^(NSInteger index) {
                
            }];
            break;
        }
        case 4:
        {
            [WDActionSheetView showActionSheeetWithTitle:@"标题" cancleBtnTitle:@"取消" destructiveBtn:@"删除" actionBlock:^(NSInteger index) {
                
            }];
            break;
        }
        case 5:
        {
            [WDActionSheetView showActionSheeetWithTitle:@"标题" cancleBtnTitle:@"取消" otherBtnTitles:otherBtnTitle actionBlock:^(NSInteger index) {
                
            }];
            break;
        }
        case 6:
        {
            [self actionSheetOfSystem];
            break;
        }
        default:
            break;
    }
}
-(void)dealMultiMenuAlertWithIndex:(NSInteger)idnex{
    
    
    switch (idnex) {
        case 0:{
            
            [[[WDAlertView alloc]initWithTitle:@"这是标题" message:@"请选择" multiMenusBtnTitle:@[@"刷脸",@"指纹",@"取消"] multiMenuBlock:^(NSInteger btnIndex) {
                
                NSLog(@"index==%ld",btnIndex);
                
            }] show];
        }
            break;
        case 1:
        {
            [[[WDAlertView alloc]initWithTitle:@"这是标题" message:nil multiMenusBtnTitle:@[@"刷脸",@"指纹",@"取消"] multiMenuBlock:^(NSInteger btnIndex) {
                
                NSLog(@"index==%ld",btnIndex);
                
            }] show];
            break;
        }
        case 2:
        {
            [[[WDAlertView alloc]initWithTitle:nil message:@"请选择" multiMenusBtnTitle:@[@"刷脸",@"指纹",@"取消"] multiMenuBlock:^(NSInteger btnIndex) {
                
                NSLog(@"index==%ld",btnIndex);
                
            }] show];
            break;
        }
        case 3:
        {
            [[[WDAlertView alloc]initWithTitle:nil message:nil multiMenusBtnTitle:@[@"刷脸",@"指纹",@"取消"] multiMenuBlock:^(NSInteger btnIndex) {
                
                NSLog(@"index==%ld",btnIndex);
                
            }] show];
            break;
        }
        
        default:
            break;
    }
}
-(void)interfaceOrientationDidChanged:(NSNotification *)noti{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        {
            NSLog(@"竖屏");
            [self rotation];
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        {
            NSLog(@"横屏，home键在左侧");
            [self rotation];
            break;
        }
        case UIInterfaceOrientationLandscapeRight:
        {
            NSLog(@"横屏，home键在右侧");
            [self rotation];
            break;
        }
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            NSLog(@"竖屏，倒立");
            [self rotation];
            break;
        }
        default:
            break;
    }
}
-(void)rotation{
    
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    
    [UIView animateWithDuration:duration animations:^{
        self.tableView.frame=self.view.bounds;
    }];
}
-(void)actionSheetOfSystem{
    
    UIAlertController *alertCon=[UIAlertController alertControllerWithTitle:@"标题" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"默认" style:UIAlertActionStyleDefault handler:nil];
    [alertCon addAction:action1];
    UIAlertAction *action2=[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"确认" message:@"确定删除？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }];
    [alertCon addAction:action2];
    UIAlertAction *action3=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertCon addAction:action3];
    [self presentViewController:alertCon animated:YES completion:nil];
    
    //在ipad上的特殊处理， 以点击触发的地方 为锚点。弹出ActionSheet，否则会出现崩溃
    /**
     *  在常规宽度的设备上，上拉菜单是以弹出框的形式展现。弹出框必须要有一个能够作为源视图或者栏按钮项目的描点(anchor point)。由于在本例中我们是使用了常规的UIButton来触发上拉菜单的，因此我们就将其作为描点。
     */
//    UIPopoverPresentationController *popover = alertCon.popoverPresentationController;
//    if (popover) {
//        popover.sourceView = sender;
//        popover.sourceRect = sender.bounds;
//        popover.permittedArrowDirections=UIPopoverArrowDirectionAny;
//    }
//    //显示弹框
//    [self presentViewController:alertCon animated:YES completion:nil];
}


-(void)deleteAction{
    //删除
    [WDAlertView showAlertWithMessage:@"确定要删除吗？" cancleButtonTitle:@"算了吧" confirmButtonTitle:@"删了吧" cancleBlock:^{
        [WDAlertView showToastWithText:@"怂了吧👎"];
    } confirmBlcok:^{
        [WDAlertView showToastWithText:@"你厉害👍"];
    }];
}

-(void)getPhotos{
    [WDActionSheetView showActionSheetWithCancleBtnTitle:@"取消" otherBtnTitles:@[@"拍照",@"相册"] actionBlock:^(NSInteger index) {
        if (index!=2) {
            [WDAlertView showToastWithText:@"啥也木有😄"];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
