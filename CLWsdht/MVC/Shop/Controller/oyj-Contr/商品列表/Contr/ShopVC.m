//
//  ShopVC.m
//  CLW
//
//  Created by majinyu on 16/1/9.
//  Copyright © 2016年 cn.com.cucsi. All rights reserved.
//

#import "ShopVC.h"
#import "CityListVC.h"//城市选择
#import "SearchBarViewController.h"
#import "AFNetworking.h"//主要用于网络请求方法
#import "UIKit+AFNetworking.h"//里面有异步加载图片的方法
#import "ChoseSparePartsViewController.h"
#import "GoodsDetailsViewController.h"
#import "MJExtension.h"
#import "PartsListData.h"
#import "PartsModal.h"
#import "UsrStoreTableViewCell.h"
#import "UserStoreModel.h"
#import "CategoryModal.h"
#import "CategoryButton.h"
#import "ChoseSparePartsViewController.h"


//商品详情页
#import "ScrollViewTestViewController.h"
#import "ProductInfoViewController.h"

#import "ProductDetailContr.h"

#define  Cell_Height (self.view.frame.size.height-((25+( self.view.frame.size.width-70)/4)+(5+20+( self.view.frame.size.width-70)/4)+20+40))*2/5.0
@interface ShopVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    UITableView *userStoreTableView;
    NSString *userSeletedCity;//用户选择的城市(默认用户当前位置所在城市)
    NSString *userSeletedCityID;//用户选择的城市ID(默认用户当前位置所在城市
    //    NSMutableArray *carSparePartsArray;//汽车配件
    NSArray *CategoryArray;
    int page;
    
    
}
@property(nonatomic,strong) NSMutableArray *CategoryIdArray;//七个分类数组id
@property(nonatomic,strong) NSMutableArray *CategoryNameArray;//七个分类数组名字
@property(nonatomic,strong) NSMutableArray *CategoryImgUrlArray;//七个分类数组image地址

@property(nonatomic,strong) NSMutableArray *carSparePartsArray;//汽车配件


@end

@implementation ShopVC


-(NSMutableArray *)CategoryIdArray
{
    if (!_CategoryIdArray) {
        self.CategoryIdArray=[NSMutableArray array];
    }
    return _CategoryIdArray;
}
-(NSMutableArray *)CategoryNameArray
{
    if (!_CategoryNameArray) {
        self.CategoryNameArray=[NSMutableArray array];
    }
    return _CategoryNameArray;
}
-(NSMutableArray *)CategoryImgUrlArray
{
    if (!_CategoryImgUrlArray) {
        self.CategoryImgUrlArray=[NSMutableArray array];
    }
    return _CategoryImgUrlArray;
}
-(NSMutableArray *)carSparePartsArray
{
    if (!_carSparePartsArray) {
        self.carSparePartsArray=[NSMutableArray array];
    }
    return _carSparePartsArray;
}



#pragma mark - Life Cycle

-(void)viewDidLoad
{
    
    [super viewDidLoad];

    
    [self initData];
    
    //    [self initUI];
    //    [self AddOrderByNetwork];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    userSeletedCity = ApplicationDelegate.currentCity;
    userSeletedCityID = ApplicationDelegate.currentCityID;
    [self initRightButtonItemWithCityName:userSeletedCity];
}


#pragma mark - Data & UI
/**
 *   初始化左右按钮
 */
- (void)initRightButtonItemWithCityName:(NSString *)cityName
{
    
    // Do any additional setup after loading the view.
    
    UIBarButtonItem * leftBarButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"车自联" style:UIBarButtonItemStylePlain target:self action:nil];
    //设置
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    // btn.backgroundColor=[UIColor redColor];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn setTitle:cityName forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(seleteCityAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

/**
 *  选择城市的方法
 */
- (void) seleteCityAction
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    CityListVC *vc = [sb instantiateViewControllerWithIdentifier:@"CityListVC"];
    vc.vcType = 2;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{}];
    
}

//数据
-(void)initData
{
    [self getSevenCategoryFromNetwork];
    [self getMoreGoodsInfoFromNetwork];
    //    carSparePartsArray = [NSMutableArray array];
    
    
    
    
}

//
#pragma mark--searchBar响应事件
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    SearchBarViewController *searchBarVC=[[SearchBarViewController alloc]init];
    [self presentViewController:searchBarVC animated:YES completion:^{} ];
}
-(void)clickedBtn:(CategoryButton *)btn{
    [self setHidesBottomBarWhenPushed:YES];
    UIStoryboard *ShopSB = [UIStoryboard storyboardWithName:@"Shop" bundle:nil];
    ChoseSparePartsViewController *Contr = [ShopSB instantiateViewControllerWithIdentifier:@"ChoseSparePartsViewController"];
    Contr.categoryID=btn.stringID;
    [self.navigationController pushViewController:Contr animated:YES];
    
    [self setHidesBottomBarWhenPushed:NO];
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//
//    return userStoreTableView.mj_header;
//}


#pragma mark - Target & Action

#pragma mark - Functions Custom

/**
 *  刷新
 */
- (void)loadFirstPage
{
    
    page = 0 ;
    [self getMoreGoodsInfoFromNetwork];
    [userStoreTableView.mj_header endRefreshing];
    
}

/**
 *  加载下一页
 */
- (void)loadNextPage
{
    [userStoreTableView.mj_header beginRefreshing];
    
    page ++ ;
    [self getMoreGoodsInfoFromNetwork];
    [userStoreTableView.mj_footer endRefreshing];
    
}

#pragma mark - Networking
/**
 *  @author oyj, 16-02-29
 *
 *  获取商品列表
 */

-(void)getMoreGoodsInfoFromNetwork
{
    
    [SVProgressHUD showWithStatus:k_Status_Load];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"UsrStore.asmx/GetPartsList"];
    
    
    
    NSDictionary *paramDict = @{
                                @"partsJson":@"",
                                @"sortJson":@"",
                                @"start":[NSString stringWithFormat:@"%d",page],
                                @"limit":[NSString stringWithFormat:@"%d",30]
                                };
    
    [ApplicationDelegate.httpManager POST:urlStr
                               parameters:paramDict
                                 progress:^(NSProgress * _Nonnull uploadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      if (task.state == NSURLSessionTaskStateCompleted) {
                                          NSError* error;
                                          NSDictionary* jsonDic = [NSJSONSerialization
                                                                   JSONObjectWithData:responseObject
                                                                   options:kNilOptions
                                                                   error:&error];
                                          PartsListData *data=[PartsListData mj_objectWithKeyValues:jsonDic];
                                          if (data.Success) {
                                              [self.carSparePartsArray removeAllObjects];
                                              
                                              for(PartsModal *modal in data.Data.Data)
                                              {
                                                  UserStoreModel *zm = [[UserStoreModel alloc] init];
                                                  zm.title = modal.Name;
                                                  
                                                  zm.price =  [NSString stringWithFormat:@"%f",modal.Price ];
                                                  zm.imageUrl = modal.Url;
                                                  zm.storeName = modal.StoreName;
                                                  zm.partsSrcName = modal.PartsSrcName;
                                                  zm.purityName = modal.PurityName;
                                                  zm.goodID=modal.Id;
                                                  zm.storeMobile=modal.Mobile;
                                                  [self.carSparePartsArray addObject:zm];
                                              }
                                              [SVProgressHUD dismiss];
                                              [userStoreTableView reloadData];
                                              
                                          } else {
                                              [SVProgressHUD showErrorWithStatus:k_Error_WebViewError];
                                              
                                          }
                                          
                                      } else {
                                          [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                      }
                                      
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      //请求异常
                                      [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                  }];
    
}

/**
 *  @author oyj, 16-04-27
 *
 *  获取七个分类接口
 */

-(void)getSevenCategoryFromNetwork
{
    
    [SVProgressHUD showWithStatus:k_Status_Load];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"Dic.asmx/GetDisplayPartsUseFor"];
    
    NSDictionary *paramDict = @{};
    
    [ApplicationDelegate.httpManager POST:urlStr
                               parameters:paramDict
                                 progress:^(NSProgress * _Nonnull uploadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      if (task.state == NSURLSessionTaskStateCompleted) {
                                          NSError* error;
                                          NSDictionary* jsonDic = [NSJSONSerialization
                                                                   JSONObjectWithData:responseObject
                                                                   options:kNilOptions
                                                                   error:&error];
                                          //                                          CategoryModal *data=[CategoryModal mj_objectWithKeyValues:jsonDic];
                                          if ([[jsonDic objectForKey:@"Success"]boolValue]) {
                                              CategoryArray=[[jsonDic objectForKey:@"Data"]componentsSeparatedByString:@"\""];
                                              NSString *string;
                                              for(int i=0;i<CategoryArray.count;i++)
                                              {
                                                  string=[CategoryArray objectAtIndex:i ];
                                                  if([string rangeOfString:@"Id"].location !=NSNotFound)
                                                  {
                                                      [self.CategoryIdArray addObject:[CategoryArray objectAtIndex:i+2]];
                                                  }
                                                  if([string rangeOfString:@"Name"].location !=NSNotFound)
                                                  {
                                                      [self.CategoryNameArray addObject:[CategoryArray objectAtIndex:i+2]];
                                                  }
                                                  if([string rangeOfString:@"ImgUrl"].location !=NSNotFound)
                                                  {
                                                      [self.CategoryImgUrlArray addObject:[CategoryArray objectAtIndex:i+2]];
                                                  }
                                                  
                                              }
                                              
                                              [SVProgressHUD dismiss];
                                              [self initUI];
                                              [MJYUtils mjy_hiddleExtendCellForTableView:userStoreTableView];
                                          } else {
                                              [SVProgressHUD showErrorWithStatus:k_Error_WebViewError];
                                              
                                          }
                                          
                                      } else {
                                          [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                      }
                                      
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      //请求异常
                                      [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                  }];
    
}



//页面
-(void)initUI
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0,( SCREEN_WIDTH-40)/2, 35)];//allocate titleView
    // UIColor *color =  self.navigationController.navigationBar.tintColor;
    [titleView setBackgroundColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:205/255.0 alpha:1]];
    //搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.frame = CGRectMake(0, 0, (SCREEN_WIDTH-40)/2, 35);
    searchBar.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
    searchBar.layer.cornerRadius = 18;
    searchBar.layer.masksToBounds = YES;
    searchBar.placeholder=@"搜索：配件/商店";
    [titleView addSubview:searchBar];
    
    //Set to titleView
    self.navigationItem.titleView = titleView;
    for (NSInteger i=0; i<self.CategoryIdArray.count; i++) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(5+((SCREEN_WIDTH-70)/4+20)*(i%4),NAVIGATIONBARHEIGHT+10+(25+(SCREEN_WIDTH-70)/4)*(i/4), (SCREEN_WIDTH-70)/4, (SCREEN_WIDTH-70)/4)];
        imageView.backgroundColor=[UIColor whiteColor];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[self.CategoryImgUrlArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"rc_ic_picture"]];
        CategoryButton *button=[[CategoryButton alloc]initWithFrame:CGRectMake(5+((SCREEN_WIDTH-70)/4+20)*(i%4),NAVIGATIONBARHEIGHT+10+(25+(SCREEN_WIDTH-70)/4)*(i/4), (SCREEN_WIDTH-70)/4, (SCREEN_WIDTH-70)/4)];
        button.stringID=[self.CategoryIdArray objectAtIndex:i];
        button.tag=100+i;
        [button addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(5+((SCREEN_WIDTH-70)/4+20)*(i%4),NAVIGATIONBARHEIGHT+ (15+(SCREEN_WIDTH-70)/4)+(5+20+(SCREEN_WIDTH-70)/4)*(i/4), (SCREEN_WIDTH-70)/4, 20)];
        label.backgroundColor=[UIColor whiteColor];
        label.text=[self.CategoryNameArray objectAtIndex:i];
        label.textColor=[UIColor lightGrayColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:13];
        [self.view addSubview:imageView];
        [self.view addSubview:label];
        UILabel *hotLable=[[UILabel alloc]initWithFrame:CGRectMake(0, NAVIGATIONBARHEIGHT+(25+(SCREEN_WIDTH-70)/4)+(5+20+(SCREEN_WIDTH-70)/4)+20,  SCREEN_WIDTH, 40)];
        hotLable.backgroundColor=[UIColor colorWithRed:246/255.0 green:247/255.0 blue:242/255.0 alpha:1];
        hotLable.text=@"  热门推荐";
        [self.view addSubview:hotLable];
        userStoreTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBARHEIGHT+(25+(SCREEN_WIDTH-70)/4)+(5+20+(SCREEN_WIDTH-70)/4)+20+40, SCREEN_WIDTH, SCREEN_HEIGHT-((25+(SCREEN_WIDTH-70)/4)+(5+20+(SCREEN_WIDTH -70)/4)+20+40)-110)];
        userStoreTableView.delegate=self;
        userStoreTableView.dataSource=self;
        [userStoreTableView registerNib:[UINib nibWithNibName:@"UsrStoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"userStoreCellIdentifer"];
        [self.view addSubview:userStoreTableView];
        
    }
    userStoreTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadFirstPage];
        
    }];
    [userStoreTableView.mj_header beginRefreshing];
}
#pragma mark -- UITableViewDelegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //设置标识符
    static NSString *userStoreCellIdentifer = @"userStoreCellIdentifer";
    UsrStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userStoreCellIdentifer"];
    if (cell == nil) {
        cell = [[UsrStoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userStoreCellIdentifer];
    }
    [cell setDataWithModel:self.carSparePartsArray[indexPath.row]];
    
    return cell;
}

//返回section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100 ;
}
//选中cell时调起的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中cell要做的操作
    [self setHidesBottomBarWhenPushed:YES];
    ProductInfoViewController *ScrollViewTestVC=[[ProductInfoViewController alloc]init];
    UserStoreModel *good=[self.carSparePartsArray objectAtIndex:indexPath.row];
    ScrollViewTestVC.goodID=good.goodID;
    ScrollViewTestVC.storeMobile=good.storeMobile;
    [self.navigationController pushViewController:ScrollViewTestVC animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
//    PictureInfController *contr=[[PictureInfController alloc]init];
//    [self.navigationController pushViewController:contr animated:YES];
//    [self setHidesBottomBarWhenPushed:NO];
  
    
}

//返回某个section中rows的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.carSparePartsArray.count;
}



@end
