//
//  UserAddressVC.m
//  CLWsdht
//
//  Created by clish on 16/4/14.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "UserAddressVC.h"
#import "userInfo.h"
#import "UserAddressEditVC.h"

@interface UserAddressVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * TV;
    NSMutableArray * AddressList;
}
@end

@implementation UserAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置弹出页返回按钮文字
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]init];
    [cancelButton setTitle:@""];
    self.navigationItem.backBarButtonItem = cancelButton;
    // Do any additional setup after loading the view.

    [self initData];
    //[self initUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent=NO;
    [self initData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initData];
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
-(void)initData
{
    [self getData];
}
-(void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
    self.navigationItem.title = @"收货地址管理";
    UIBarButtonItem * btnBarItem = [[UIBarButtonItem alloc]init];
    [btnBarItem setTitle:@""];
    [self.navigationController.navigationBar.backItem setBackBarButtonItem:btnBarItem];
    
    
    TV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40) ];//style:<#(UITableViewStyle)#>
    TV.dataSource = self;
    TV.delegate = self;
    [self.view addSubview:TV];
    //地址添加按钮
    UIButton * btnAdressAdd= [[UIButton alloc]initWithFrame:CGRectMake(13, self.view.frame.size.height-35, self.view.frame.size.width - 26, 30)];
    [btnAdressAdd setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [btnAdressAdd addTarget:self action:@selector(AddNewAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    btnAdressAdd.backgroundColor = [UIColor grayColor];
    btnAdressAdd.layer.cornerRadius = 5.0;
    [self.view addSubview:btnAdressAdd];
}
-(void) AddNewAddressAction:(id)sender
{
    self.hidesBottomBarWhenPushed = YES;
    UserAddressEditVC * addressVc = [[UserAddressEditVC alloc]init];
    [self.navigationController pushViewController:addressVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
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
    return AddressList.count;
    
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"mycell"];
    }
    NSDictionary * cellInfo = [AddressList objectAtIndex:indexPath.item];
    cell.textLabel.text = [cellInfo objectForKey:@"Name"]; //标题
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%@%@%@%@",
        [cellInfo objectForKey:@"ProvincialName"],
        [cellInfo objectForKey:@"CityName"],
        [cellInfo objectForKey:@"DistrictName"],
        [cellInfo objectForKey:@"DetailAddress"]] ;//详细
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UILabel * lblTel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 135, 3, 125, 25          )];
    lblTel.text =[cellInfo objectForKey:@"Telephone"];
    //NSLog(@"状态%@",[cellInfo objectForKey:@"IsDefault"]);
    if([[cellInfo objectForKey:@"IsDefault"] isEqualToString:@"True"])
    {
        //NSString * a = @"";
        cell.detailTextLabel.text =[@"         " stringByAppendingString:cell.detailTextLabel.text];
        //cell.detailTextLabel.frame.origin.x = cell.detailTextLabel.frame.origin.x +30;
        cell.detailTextLabel.frame = CGRectMake(cell.detailTextLabel.frame.origin.x+34, cell.detailTextLabel.frame.origin.y, cell.detailTextLabel.frame.size.width, cell.detailTextLabel.frame.size.height);
        UILabel * lblDefault = [[UILabel alloc]initWithFrame:CGRectMake(16, 22, 40, 20)];
        lblDefault.text = @"[默认]";
        lblDefault.textColor = [UIColor redColor];
        lblDefault.font= [UIFont systemFontOfSize:11];
        [cell addSubview:lblDefault];
    
    }
    [cell addSubview:lblTel];
    return cell;
}
//当一行被选中进执行此事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;
    UserAddressEditVC * addressVc = [[UserAddressEditVC alloc]init];
    NSDictionary * item = [AddressList objectAtIndex:indexPath.item];
    addressVc.Id = [item objectForKey:@"Id"];
    
    addressVc.ProvincialName  = [item objectForKey:@"ProvincialName"];
    addressVc.CityName = [item objectForKey:@"CityName"];
    addressVc.DistrictName = [item objectForKey:@"DistrictName"];
    addressVc.DetailAddress = [item objectForKey:@"DetailAddress"];
    addressVc.ZipCode = [item objectForKey:@"ZipCode"];
    addressVc.Name = [item objectForKey:@"Name"];
    addressVc.Telephone = [item objectForKey:@"Telephone"];
    addressVc.IsDefault = [item objectForKey:@"IsDefault"];
    
    [self.navigationController pushViewController:addressVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 *  获取我的店铺列表信息接口数据
 */
- (void)getData
{
    [SVProgressHUD showWithStatus:k_Status_Load];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,k_url_GetAddressList];
    
    NSDictionary *paramDict = @{
                                @"UsrId":ApplicationDelegate.userInfo.user_Id
                                };
    
    [ApplicationDelegate.httpManager POST:urlStr parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
            //NSLog(@"返回结果%@",jsonDic);
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                //成功返回
               // NSArray *jsonDic2 = [JYJSON dictionaryOrArrayWithJSONSString:[jsonDic objectForKey:@"Data"]];

               //NSLog(@"ttt:%@",jsonDic2);
                AddressList = [JYJSON dictionaryOrArrayWithJSONSString:[jsonDic objectForKey:@"Data"]];
            
                [self initUI];
                [SVProgressHUD dismiss];
            } else {
                [SVProgressHUD showErrorWithStatus:jsonDic[@"Message"]];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:k_Error_Network];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求异常
        [SVProgressHUD showErrorWithStatus:k_Error_Network];
    }];
    
}
@end
