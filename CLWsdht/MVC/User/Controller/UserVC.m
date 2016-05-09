//
//  UserVC.m
//  CLW
//
//  Created by majinyu on 16/1/9.
//  Copyright © 2016年 cn.com.cucsi. All rights reserved.
//

#import "UserVC.h"
#import <QuartzCore/QuartzCore.h>
#import "UserInfo.h"
#import "UserDemandVC.h"
#import "UserAccountManagerVC.h"
#import "UserAddressVC.h"
#import "UserAccountManagerVC.h"
#import "UserMsgVC.h"
#import "LoginViewController.h"

@interface UserVC ()<UITableViewDataSource,UITableViewDelegate>
{
    //NSArray * OptionList;=[NSArray allo] //  NSArray alloc]initWithObjects:@"",@"",@"",@"",nil];
    NSArray * OptionList ;
    UITableView *tbvOption;
}
@end

@implementation UserVC

#pragma mark - Life Cycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
    //NSLog(@"我的信息%@:%@:%@:%@:%@",ApplicationDelegate.userInfo.Url,ApplicationDelegate.userInfo.Img,ApplicationDelegate.userInfo.Url,ApplicationDelegate.userInfo.Url,ApplicationDelegate.userInfo.Url);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
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

#pragma mark - Data & UI
//数据
-(void)initData
{
    OptionList = [[NSArray alloc]initWithObjects:@"我的需求",@"账户管理",@"我的消息",@"收货地址",@"退出登录", nil];
}
//页面
-(void)initUI
{
    //不显示导航栏
    self.navigationController.navigationBarHidden = YES;
    
    //背景图片
    UIImage * img_backGround = [UIImage imageNamed:@"per_buyers"];
    CGFloat BGIW_Base = img_backGround.size.width;//原始宽
    CGFloat BGIH_Base = img_backGround.size.height;//原始高
    CGFloat scaleSize = self.view.frame.size.width/BGIW_Base;//比例
    CGFloat BGIH = BGIH_Base*scaleSize*0.65;//全屏宽的高度
    UIImageView * imgV_backGroud = [[UIImageView alloc]initWithImage:img_backGround ];
    imgV_backGroud.frame = CGRectMake(0, 20, self.view.frame.size.width, BGIH);
    [imgV_backGroud setUserInteractionEnabled:YES];//设置此视图上的控件可以响应事件，很必要！！！！
    [self.view addSubview:imgV_backGroud];
    
    //头像 按钮
    CGFloat MyImgSize = BGIH/3.0f;
    NSString *url =ApplicationDelegate.userInfo.Url;  //头像地址，需要修改 *************************************************************************
    UIImage *UImgMyImg = [[UIImage  alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL  URLWithString:url]]];
    UIButton * btnMyImg = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-MyImgSize)/2,(BGIH-MyImgSize)/8,MyImgSize,MyImgSize)];
    [btnMyImg setBackgroundImage:UImgMyImg forState:UIControlStateNormal];
    btnMyImg.layer.masksToBounds = YES;
    btnMyImg.layer.cornerRadius =MyImgSize/2;
    [btnMyImg addTarget:self action:@selector(BtnAction:) forControlEvents:UIControlEventTouchUpInside ];
    btnMyImg.tag = 0;
    [imgV_backGroud addSubview:btnMyImg];
    
    
    
    //级别
    NSInteger ileve = 3;//用户级别   需要修改*****************************
    UIView * vleve = [[UIView alloc]init];
    CGFloat vleveW =0;
    CGFloat leveImgSize = 5;//钻石的大小 需要时进行修改***************
    for(NSInteger i=0;i<ileve;i++)
    {
        vleveW +=leveImgSize+1;//每个级别加24+1+1 图片24左右间距2
        UIImage *imgleve = [UIImage  imageNamed:@"s_rate_blue"];
        UIImageView * imgvleve = [[UIImageView alloc]initWithImage:imgleve];
        imgvleve.frame = CGRectMake(i*(leveImgSize+1+1)+1, 0, leveImgSize, leveImgSize);
        NSLog(@"%f",imgvleve.frame.origin.x);
        [vleve addSubview:imgvleve];
    }
    vleve.frame = CGRectMake((imgV_backGroud.frame.size.width-vleveW)/2, (BGIH-MyImgSize)/8+MyImgSize+(BGIH-MyImgSize)/8, vleveW, leveImgSize);
    [imgV_backGroud addSubview:vleve];
    //收藏的商家
    //    UIImage *imgscsj = [UIImage  imageNamed:@"s_rate_blue"];
    //    UIButton * btnscsj = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-MyImgSize)/2,(BGIH-MyImgSize)/8+MyImgSize+(BGIH-MyImgSize)/8+leveImgSize+(BGIH-MyImgSize)/8,100 ,100)];
    //    [btnscsj setBackgroundImage:imgscsj forState:UIControlStateNormal];
    //    [btnscsj addTarget:self action:@selector(MyImgAction:) forControlEvents:UIControlEventTouchUpInside ];
    //    [imgV_backGroud addSubview:btnscsj];
    //收藏的修理厂
    //收藏的商品
    
    
    //下面表格的View
    UIView *VDonw = [[UIView alloc]initWithFrame:CGRectMake(0, imgV_backGroud.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height-BGIH-20)];
    VDonw.backgroundColor = [UIColor blackColor];
    [self.view addSubview:VDonw];
    
    //表格
    NSLog(@"tb%@",tbvOption);
    tbvOption = [[UITableView alloc]init];
    //不显示表头
    //tbvOption.tableHeaderView.hidden = YES;
    tbvOption.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-imgV_backGroud.frame.size.height-65);
    [VDonw addSubview:tbvOption];
    tbvOption.dataSource=self;
    tbvOption.delegate=self;
}

#pragma mark - Target & Action
//所有本页按钮事件
-(void) BtnAction:(id)sender
{
    switch ([sender tag]) {
        case 0://头像点击事件
            NSLog(@"头像点击事件");
            break;
            
        default:
            break;
    }
    
}


#pragma mark - Functions Custom

#pragma mark - TableView DataSource
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
    return 5;
    
}
/**
 *  单元格显示事件
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置标识符
    UITableViewCell * cell = [tbvOption dequeueReusableCellWithIdentifier:@"mycell"];
    if(cell ==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
    }
    cell.textLabel.text = [OptionList objectAtIndex:indexPath.item];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
//当一行被选中进执行此事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;
    switch (indexPath.item) {
        case 0://我的需求
        {
            //由storyboard根据myView的storyBoardID来获取我们要切换的视图
            //UIViewController *DemandVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserDemandVC"];
            UserDemandVC *DemandVC = [[UserDemandVC alloc]init];
            //由navigationController推向我们要推向的view
            [self.navigationController pushViewController:DemandVC animated:YES];
            break;
        }
        case 1://账号管理
        {
            //            UserAccountManagerVC * UserAccountVC=[[UserAccountManagerVC alloc]init];
            UIViewController *UserAccountVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserAccountManagerVC"];
            [self.navigationController pushViewController:UserAccountVC animated:NO];
            break;
        }
        case 2://我的消息
        {
            //            UserMsgVC * usermsg=[[UserMsgVC alloc]init];
            UIViewController *usermsg = [self.storyboard instantiateViewControllerWithIdentifier:@"UserMsgVC"];
            [self.navigationController pushViewController:usermsg animated:NO];
            break;
        }
        case 3://收货地址
        {
            //            UserAddressVC * useraddress=[[UserAddressVC alloc]init];
            UIViewController *useraddress = [self.storyboard instantiateViewControllerWithIdentifier:@"UserAddressVC"];
            [self.navigationController pushViewController:useraddress animated:NO];
            break;
        }
        case 4://退出登录
        {
            [[NSUserDefaults standardUserDefaults]  removeObjectForKey:k_UD_username];
            [[NSUserDefaults standardUserDefaults]  removeObjectForKey:k_UD_password];
            [[NSUserDefaults standardUserDefaults] synchronize];
            ApplicationDelegate.isLogin = NO ;
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            LoginViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
            vc.ifAllowAutoLogin = false;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            break;

        }
        default:
            break;
    }
    self.hidesBottomBarWhenPushed = NO;
    
}

#pragma mark - Networking

@end
