//
//  UserAccountManagerVC.m
//  CLWsdht
//
//  Created by clish on 16/4/14.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "UserAccountManagerVC.h"
#import "UserInfo.h"
#import "UserEditTelVC.h"
#import "UserEditPasswordVC.h"  
#import "UserEditUserInfoVC.h"

@interface UserAccountManagerVC ()<UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray * title;
    NSMutableArray * titleValue;
    UITableView * TV;
    UserInfo * user;
}
@end

@implementation UserAccountManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"账号管理";
    UIBarButtonItem * btnBarItem = [[UIBarButtonItem alloc]init];
    [btnBarItem setTitle:@""];
    [self.navigationController.navigationBar.backItem setBackBarButtonItem:btnBarItem];
    [self initData];
    [self initUI];
    
    //设置弹出页返回按钮文字
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]init];
    [cancelButton setTitle:@""];
    self.navigationItem.backBarButtonItem = cancelButton;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent=NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(void) initData
{
   // UserInfo = ApplicationDelegate.UserInfo;
    title = [[NSMutableArray alloc] initWithObjects:@"已绑定手机",@"修改密码",@"修改用户信息",nil];
    if(ApplicationDelegate.userInfo.Mobile && ApplicationDelegate.userInfo.Mobile.length==11)
    {
        NSString * telLeft = [ApplicationDelegate.userInfo.Mobile substringWithRange:NSMakeRange(0, 3)];
        NSString * telRight = [ApplicationDelegate.userInfo.Mobile substringWithRange:NSMakeRange(6,4)];
        titleValue = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@****%@",telLeft,telRight],@"",@"",nil];
    }
    else
    {
        title = [[NSMutableArray alloc] initWithObjects:@"绑定手机",@"修改密码",@"修改用户信息",nil];
        titleValue = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",nil];
    }
    
}
-(void)initUI
{
    TV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    TV.dataSource = self;
    TV.delegate = self;
    [self.view addSubview:TV];
}
#pragma mark - Table事件
/*
 1.多少分区
 2.每个分区名称是什么
 3.每个分区下有多少行
 4.每一行的高度
 5.每一行的样式
 */
//指定有多少个分区(Section)，默认为1

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;//返回标题数组中元素的个数来确定分区的个数
    
}

//指定每个分区中有多少行，默认为1
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    
}
/**
 *  单元格显示事件
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath indexPath description
 *
 *  @return <#return value description#>
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置标识符
    UITableViewCell * cell = [TV dequeueReusableCellWithIdentifier:@"mycell"];
    if(cell ==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mycell"];
    }
    cell.textLabel.text = [title objectAtIndex:indexPath.item];
    cell.detailTextLabel.text =[titleValue objectAtIndex:indexPath.item];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
//当一行被选中进执行此事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;
    switch (indexPath.item) {
        case 0://已绑定手机
        {
//            //由storyboard根据myView的storyBoardID来获取我们要切换的视图
            UserEditTelVC *TelVC = [[UserEditTelVC alloc]init];
//            //由navigationController推向我们要推向的view
           [self.navigationController pushViewController:TelVC animated:YES];
            break;
        }
        case 1://修改密码
        {
            //UserAccountManagerVC * UserAccountVC=[[UserAccountManagerVC alloc]init];
            //UIViewController *UserAccountVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserAccountManagerVC"];
            UserEditPasswordVC *PwdVC = [[UserEditPasswordVC alloc]init];
            [self.navigationController pushViewController:PwdVC animated:NO];
            break;
        }
        case 2://修改用户信息
        {
            //            UserMsgVC * usermsg=[[UserMsgVC alloc]init];
            //UIViewController *usermsg = [self.storyboard instantiateViewControllerWithIdentifier:@"UserMsgVC"];
            UserEditUserInfoVC * UserifoVC  = [[UserEditUserInfoVC alloc]init];
            [self.navigationController pushViewController:UserifoVC animated:NO];
            break;
        }
        
        default:
            break;
    }
    self.hidesBottomBarWhenPushed = NO;
    
}

@end
