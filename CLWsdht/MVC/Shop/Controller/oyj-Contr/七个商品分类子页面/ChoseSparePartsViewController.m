//
//  ChoseSparePartsViewController.m
//  CLWsdht
//
//  Created by tom on 16/1/21.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "ChoseSparePartsViewController.h"
#import "PartsListData.h"
#import "MJExtension.h"
#import "PartsModal.h"
#import "UserStoreModel.h"
#import "UsrStoreTableViewCell.h"

//商品详情页
#import "ScrollViewTestViewController.h"
#import "ProductInfoViewController.h"

@interface ChoseSparePartsViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property(assign,nonatomic)int page;
@property(strong,nonatomic)NSArray *districtArray;
//地区选择
@property(assign,nonatomic)NSInteger selectComponent1;
@property(assign,nonatomic)NSInteger selectComponent2;
@property(strong,nonatomic)UIPickerView *districtPicker;
@property(strong,nonatomic)UIView *pickerParentView;//tag=1
@property(copy,nonatomic)NSString *selectDistrictAreaID;

//排序选择
@property(assign,nonatomic)NSInteger selectSortComponent;
@property(strong,nonatomic)UIPickerView *sortPicker;
@property(strong,nonatomic)UIView *sortParentView;//tag=2
@property(copy,nonatomic)NSString *selectSortID;//1时间 2价格 3数量


//品牌车型

//修理包

//汽车配件
@property(nonatomic,strong) NSMutableArray *carSparePartsArray;

@end

@implementation ChoseSparePartsViewController
-(NSMutableArray *)carSparePartsArray
{
    if (!_carSparePartsArray) {
        self.carSparePartsArray=[NSMutableArray array];
    }
    return _carSparePartsArray;
}
-(NSArray *)districtArray
{
    if (!_districtArray) {
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [docPath stringByAppendingPathComponent:@"Provincial.plist"];
        self.districtArray=[NSArray arrayWithContentsOfFile:filePath];
    }
    return _districtArray;
}
-(UIView *)pickerParentView
{
    if (!_pickerParentView) {
        self.pickerParentView=[[UIView alloc]init];
        
        _districtPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 260)];
        _districtPicker.delegate=self;
        _districtPicker.dataSource=self;
        _districtPicker.showsSelectionIndicator=YES;
        _districtPicker.backgroundColor=[UIColor whiteColor];
        _districtPicker.tag=1;
        UIToolbar   *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        
        pickerDateToolbar.barStyle = UIBarStyleDefault;
        [pickerDateToolbar sizeToFit];
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarCanelClick)];
        [barItems addObject:cancelBtn];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:flexSpace];
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(toolBarDoneClick)];
        [barItems addObject:doneBtn];
        [pickerDateToolbar setItems:barItems animated:YES];
        [self.pickerParentView addSubview:pickerDateToolbar];
        [self.pickerParentView addSubview:_districtPicker];
        
    }
    return _pickerParentView;
}

-(UIPickerView *)sortPicker
{
    if (!_sortPicker) {
        self.sortPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 260)];;
        _sortPicker.delegate=self;
        _sortPicker.dataSource=self;
        _sortPicker.showsSelectionIndicator=YES;
        _sortPicker.backgroundColor=[UIColor whiteColor];
        _districtPicker.tag=2;
        UIToolbar   *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        
        pickerDateToolbar.barStyle = UIBarStyleDefault;
        [pickerDateToolbar sizeToFit];
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarSortCanelClick)];
        [barItems addObject:cancelBtn];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:flexSpace];
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(toolBarSortDoneClick)];
        [barItems addObject:doneBtn];
        [pickerDateToolbar setItems:barItems animated:YES];
        [self.sortParentView addSubview:pickerDateToolbar];
        [self.sortParentView addSubview:_districtPicker];
    }
    return _sortPicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"商品详情"];
    self.selectComponent1=0;
    self.selectComponent2=0;
    self.page=0;
    self.selectDistrictAreaID=@"50b06cb7-e881-4206-aebf-0a83062d1810";
    
    [self getMoreGoodsInfoFromNetwork];
    //    [self.districtPicker setHidden:YES];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
- (IBAction)districtAction:(id)sender {
    self.pickerParentView.frame=CGRectMake(0, self.view.frame.size.height-300, self.view.frame.size.width, 300);
    [self.view addSubview:self.pickerParentView];
}
- (IBAction)sortAction:(id)sender {
    self.sortParentView.frame=CGRectMake(0, self.view.frame.size.height-300, self.view.frame.size.width, 300);
    [self.view addSubview:self.sortParentView];
}

- (IBAction)carBrandAction:(id)sender {
}
- (IBAction)repairKitAction:(id)sender {
}
#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (pickerView.tag) {
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
            
        default:
            break;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (pickerView.tag) {
        case 1:
        {
            if (component == 0) {
                return self.districtArray.count;
            } else{
                NSArray *array= [[self.districtArray objectAtIndex:self.selectComponent1 ]objectForKey:@"T_DicCity"];
                return array.count;
            }
        }
            break;
        case 2:
            return 3;
            break;
            
        default:
            break;
    }
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (pickerView.tag) {
        case 1:
        {
            if (component == 0) {
                return [[self.districtArray objectAtIndex:row ]objectForKey:@"Name"];
            } else{
                NSArray *array= [[self.districtArray objectAtIndex:self.selectComponent1 ]objectForKey:@"T_DicCity"];
                return [[array objectAtIndex:row]objectForKey:@"Name" ];
            }
        }
            break;
        case 2:
        {
            if(row==0) {
                return @"时间";
            }else if(row==1){
                return @"价格";
            }else if(row==2){
                return @"数量";
            }
        }
            break;
            
        default:
            break;
    }
    
    return @"error";
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch (pickerView.tag) {
        case 1:
        {
            if (component == 0) {
                return self.view.frame.size.width/2;
            }else {
                return self.view.frame.size.width/2;
            }
        }
            break;
        case 2:
            return self.view.frame.size.width;
            break;
            
        default:
            break;
    }
    return self.view.frame.size.width;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (pickerView.tag) {
        case 1:
        {
            if (component == 0) {
                self.selectComponent1=row;
                [pickerView selectRow:self.selectComponent1 inComponent:0 animated:YES];
                [pickerView reloadComponent:1];
                
            }
            //    [pickerView selectedRowInComponent:0];
            //    [pickerView reloadComponent:1];
            //    [pickerView selectedRowInComponent:2];
            
            if (component == 1) {
                self.selectComponent2=row;
                [pickerView selectRow:self.selectComponent2 inComponent:1 animated:YES];
                
            }
            
        }
            break;
        case 2:
            self.selectSortComponent=row;
            break;
            
        default:
            break;
    }
    
}
-(void)setSelectDistrictID
{
    NSArray *array=[[self.districtArray objectAtIndex:self.selectComponent1]objectForKey:@"T_DicCity"];
    self.selectDistrictAreaID=[[array objectAtIndex:self.selectComponent2]objectForKey:@"Id"];
    [self.districtButton setTitle:[[array objectAtIndex:self.selectComponent2]objectForKey:@"Name"] forState:UIControlStateNormal];
    
}
//地区的取消完成按钮
-(void)toolBarCanelClick{
    [self.pickerParentView removeFromSuperview];
}
-(void)toolBarDoneClick{
    [self setSelectDistrictID];
    [self.pickerParentView removeFromSuperview];
    [self getMoreGoodsInfoFromNetwork];
    
}
//排序的取消完成按钮
-(void)toolBarSortCanelClick{
    [self.sortParentView removeFromSuperview];
    [self getMoreGoodsInfoFromNetwork];
    
}
-(void)toolBarSortDoneClick{
    //    [self setSelectDistrictID];
    switch (self.selectSortComponent) {
        case 0:
            self.selectSortID=@"1";
            break;
        case 1:
            self.selectSortID=@"2";
            
            break;
        case 2:
            self.selectSortID=@"3";
            
            break;
            
        default:
            break;
    }
    [self.sortParentView removeFromSuperview];
    [self getMoreGoodsInfoFromNetwork];
    
    
}

#pragma mark - Networking
/**
 *  @author oyj, 16-04-29
 *
 *  检索商品列表
 */

-(void)getMoreGoodsInfoFromNetwork
{
    
    [SVProgressHUD showWithStatus:k_Status_Load];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"UsrStore.asmx/GetPartsList"];
    
    
    NSDictionary *paramDictBasic = @{
                                     @"State":@"1",
                                     @"PartsUseForId":self.categoryID,
                                     //                                @"PartsTypeId":@"",
                                     @"CityId":self.selectDistrictAreaID,
                                     //                                @"CarModelSIG":@"",
                                     
                                     
                                     };
    NSError *error;
    NSData *partsLstJsonArrayData = [NSJSONSerialization dataWithJSONObject:paramDictBasic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *partsLstJsonArrayDataJsonString = [[NSString alloc] initWithData:partsLstJsonArrayData encoding:NSUTF8StringEncoding];
    
    
    NSDictionary *paramDict = @{
                                @"partsJson":partsLstJsonArrayDataJsonString,
                                @"sortJson":@"",
                                @"start":[NSString stringWithFormat:@"%d",self.page],
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
                                              [self.tableView reloadData];
                                              
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
#pragma mark -- UITableViewDelegate
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
    
}
//返回某个section中rows的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.carSparePartsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UsrStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userStoreCellIdentifer"];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"UsrStoreTableViewCell" owner:self options:nil] lastObject];  ;
    }
    [cell setDataWithModel:self.carSparePartsArray[indexPath.row]];
    
    return cell;
}

@end
