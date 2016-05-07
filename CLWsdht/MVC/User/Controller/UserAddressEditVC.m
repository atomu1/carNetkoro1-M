//
//  UserAddressEditVC.m
//  CLWsdht
//
//  Created by clish on 16/4/18.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "UserAddressEditVC.h"
#import "UserInfo.h"

@interface UserAddressEditVC ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UITextField *txtName;//收货人姓名
    UITextField *txtTel;//收货人电话
    UISwitch *SwcIsDefault;
    UITextView *txtAddressDetail;//详细地址
    
    UIView *picUVBase;//选择控件是容器视图
    
    NSArray *_province; //字典基础信息省
    UIButton * btnAddress;//区域选择按钮
    
    NSString *_provinceName;
    NSString *_provinceID;
    NSString *_cityName;
    NSString *_cityID;
    NSString *_countryName;
    NSString *_countryID;

}
@end

@implementation UserAddressEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    //self.navigationController.toolbarHidden = YES;
    self.navigationItem.title = @"收货地址";
    if(self.Id)
    {
        [self initUI];
        [self initUIData];
        //[self initData];
    }else
    {
        [self initUI];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)initData
{
    [self getData];
}
-(void)initUI
{
    //收货人姓名
    
    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 30)];
    lblName.text = @"收货人姓名";
    [self.view addSubview:lblName];
    
    txtName = [[UITextField alloc]initWithFrame:CGRectMake(105, 5, self.view.frame.size.width-110, 30)];
    txtName.placeholder = @"请输入收货人姓名";
    txtName.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:txtName];
    
    //收货人下面的线
    UIView *Line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 0.5)];
    Line1.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [self.view addSubview:Line1];
    
    
    
    //收货人电话
    UILabel *lblTel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 100, 30)];
    lblTel.text = @"收货人电话";
    [self.view addSubview:lblTel];
    
    txtTel = [[UITextField alloc]initWithFrame:CGRectMake(105, 45, self.view.frame.size.width-110, 30)];
    txtTel.placeholder = @"请输入收货人电话";
    txtTel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:txtTel];
    //收货人电话下面的线
    UIView *Line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 0.5)];
    Line2.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [self.view addSubview:Line2];
    
    
    
    //默认地址
    UILabel *lblIsDefault = [[UILabel alloc]initWithFrame:CGRectMake(10, 85, 100, 30)];
    lblIsDefault.text = @"默认地址";
    [self.view addSubview:lblIsDefault];
    SwcIsDefault =[[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width-61, 85, 51, 31)];
    [self.view addSubview:SwcIsDefault];
    //默认下面的线
    UIView *Line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 0.5)];
    Line3.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [self.view addSubview:Line3];
    
    
    
    
    //省市区
    UILabel *lblAddress = [[UILabel alloc]initWithFrame:CGRectMake(10, 125, 100, 30)];
    lblAddress.text = @"省市区";
    [self.view addSubview:lblAddress];
    
     btnAddress= [[UIButton alloc]initWithFrame:CGRectMake(110, 125, self.view.frame.size.width - 110, 30)];
    [btnAddress setTitle:@"区域" forState:UIControlStateNormal];
    [btnAddress addTarget:self action:@selector(btnAreaSelect:) forControlEvents:UIControlEventTouchUpInside];
    btnAddress.backgroundColor = [UIColor grayColor];
    btnAddress.layer.cornerRadius = 5.0;
    [self.view addSubview:btnAddress];
    
    //省市区下面的线
    UIView *Line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 160, self.view.frame.size.width, 0.5)];
    Line4.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [self.view addSubview:Line4];
    
    
    
    //详细地址
    UILabel *lblAddressDetail = [[UILabel alloc]initWithFrame:CGRectMake(10, 165, 100, 30)];
    lblAddressDetail.text = @"详细地址";
    [self.view addSubview:lblAddressDetail];
    
    txtAddressDetail = [[UITextView alloc]initWithFrame:CGRectMake(10, 200, self.view.frame.size.width-20, 65)];
    [self.view addSubview:txtAddressDetail];
    //收货人下面的线
    UIView *Line5 = [[UIView alloc]initWithFrame:CGRectMake(0, 270, self.view.frame.size.width, 0.5)];
    Line5.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:0.5];
    [self.view addSubview:Line5];
    
    
    //更新手机号按钮
    UIButton * btnOK= [[UIButton alloc]initWithFrame:CGRectMake(13, self.view.frame.size.height - 100, self.view.frame.size.width - 26, 30)];
    if(self.Id)
    {
        [btnOK setTitle:@"修改" forState:UIControlStateNormal];
    }else
    {
       [btnOK setTitle:@"添加" forState:UIControlStateNormal];
    }
    [btnOK addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    btnOK.backgroundColor = [UIColor grayColor];
    btnOK.layer.cornerRadius = 5.0;
    [self.view addSubview:btnOK];
}
/**
 *  初始化信息
 */
-(void)initUIData
{
        txtName.text = self.Name;//收货人姓名
        txtTel.text = self.Telephone;//收货人电话
        if([self.IsDefault isEqualToString:@"True"])
        {
            SwcIsDefault.on = YES ;
        }else
        {
            SwcIsDefault.on = NO ;
        }
       txtAddressDetail.text = self.DetailAddress;//详细地址
    
    //加载区域信息
}
/**
 没有取得单条信息接口
 
 - returns: <#return value description#>
 */
//-(void)initUIData: (NSDictionary *)DataDic ;
//
//{
//    txtName.text = [DataDic objectForKey:@"Name"];//收货人姓名
//    txtTel.text = [DataDic objectForKey:@"Telephone"];//收货人电话
//    if([[DataDic objectForKey:@"IsDefault"] isEqualToString:@"Ture"])
//    {
//        SwcIsDefault.on = YES ;
//    }else
//    {
//        SwcIsDefault.on = NO ;
//    }
//    
//   txtAddressDetail.text = [DataDic objectForKey:@"DetailAddress"];;//详细地址
//}
#pragma mark - 保存按钮
-(void) btnAction:(id)sender
{
    if(self.Id)
    {
        //更新的方法
    }else
    {

        //添加的方法
        [self AddData];
    }
}
#pragma mark - 打开选择区域
-(void) btnAreaSelect:(id)sender
{
    [self getAreaData]; //加载数据
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width,200)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    //弹出层量底层 全部透明
    picUVBase = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:picUVBase];
    //用半透明盖住选择控件上面的内容
    UIView *picBaseTopUV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    picBaseTopUV.backgroundColor = [UIColor grayColor];
    picBaseTopUV.alpha = 0.9f;
    [picUVBase addSubview:picBaseTopUV];
    
    //选择按件
    self.pickerView.backgroundColor = [UIColor whiteColor];
    [picUVBase addSubview:self.pickerView];
    [self.pickerView reloadAllComponents]; 
    
    
    //选择按件上的按钮，取消，标题，确认
    UIView *btnUVBase = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-230, self.view.frame.size.width, 30)];
    btnUVBase.backgroundColor = [UIColor grayColor];
    [picUVBase addSubview:btnUVBase];
    
    //取消
    UIButton * btnSelectCance = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [btnSelectCance setTitle:@"取消" forState:UIControlStateNormal];
    [btnSelectCance setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnSelectCance addTarget:self action:@selector(toolBarCanelClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnUVBase addSubview:btnSelectCance];
    //标题
    UILabel * lblSelectTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 0, 100, 30)];
    lblSelectTitle.text = @"选择城市";
    lblSelectTitle.textAlignment = NSTextAlignmentCenter;
    [btnUVBase addSubview:lblSelectTitle];
    //确认
    UIButton * btnSelectOK = [[UIButton alloc]initWithFrame:CGRectMake( self.view.frame.size.width-60 , 0,50, 30)];
    [btnSelectOK setTitle:@"确定" forState:UIControlStateNormal];
    [btnSelectOK setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnSelectOK addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [btnUVBase addSubview:btnSelectOK];
    

    
}
#pragma mark - 取消选择区域
-(void)toolBarCanelClick:(id)sender
{
    _provinceName = nil;
    _provinceID = nil;
    _CityName =nil;
    _cityID =nil;
    _countryName = nil;
    _countryID = nil;
    [picUVBase setHidden:YES];
}
#pragma mark - 选择区域后，确认
-(void)finishBtnClick:(id)sender
{
    [btnAddress setTitle:[NSString stringWithFormat:@"%@%@%@>",_provinceName,_CityName,_countryName] forState:UIControlStateNormal];
    [picUVBase setHidden:YES];

}
/**
 城市选择 开始
 
 - returns:
 */

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 3;
}
#pragma mark - 该方法的返回值决定该控件指定列包含多少个列表项
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (0 == component)
    {
         return _province.count;
    }
    if (1 == component) {
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        NSDictionary *provinceName = _province[rowProvince];
        NSArray *citys =provinceName[@"T_DicCity"];
        if(citys.count)
        {
            return citys.count;
        }else
        {
            return 0;
        }
        
    }
     if (2 == component){
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        NSDictionary *provinceName = _province[rowProvince];
        NSArray *citys = provinceName[@"T_DicCity"];
         if(!citys.count)
         {
             return 0;
         }
        NSInteger rowCity = [pickerView selectedRowInComponent:1];
        NSDictionary *cityName = citys[rowCity];
        NSArray *country = cityName[@"T_DicDistrict"];
        if(country.count)
        {
            return country.count;
        }else
        {
            return  0;
        }
        
    }
    return 0;
}
#pragma mark - 该方法返回的NSString将作为UIPickerView中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (0 == component) {
        return _province[row][@"Name"];
    }
    if(1 == component){
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        NSDictionary *provinceName = _province[rowProvince];
        NSArray *citys =provinceName[@"T_DicCity"];
        return citys[row][@"Name"];
    }
    if(2 == component){
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        NSDictionary *provinceName = _province[rowProvince];
        NSArray *citys = provinceName[@"T_DicCity"];;
        NSInteger rowCity = [pickerView selectedRowInComponent:1];
        NSDictionary *cityName = citys[rowCity];
        NSArray *country = cityName[@"T_DicDistrict"];
        return country[row][@"Name"];
    }
    return nil;
}

#pragma mark - 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(0 == component){
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }
    if(1 == component)
        [pickerView reloadComponent:2];
    NSInteger rowOne = [pickerView selectedRowInComponent:0];
    NSInteger rowTow = [pickerView selectedRowInComponent:1];
    NSInteger rowThree = [pickerView selectedRowInComponent:2];

    NSDictionary *provinceName = _province[rowOne];
    _provinceName = provinceName[@"Name"];
    _provinceID= provinceName[@"Id"];
    NSArray *citys = provinceName[@"T_DicCity"];
    if(citys.count)
    {
        NSDictionary *cityName = citys[rowTow];
        _CityName =cityName[@"Name"];
        _cityID =cityName[@"Id"];
        NSArray *countrys = cityName[@"T_DicDistrict"];
       if(countrys.count)
       {
            NSDictionary *country = countrys[rowThree];
            _countryName =country[@"Name"];
            _countryID =country[@"Id"];
        }else
        {
            _countryName = nil;
            _countryID = nil;
        }

    }else
    {
        _CityName =nil;
        _cityID =nil;
        _countryName = nil;
        _countryID = nil;
    }
    
    NSLog(@"%@~%@~%@", _provinceName,  _CityName,_countryName);
        
}


/**
 *  城市选择结束
 *
 *  @return <#return value description#>
 */
/**
 *  获取地址信息
 */
- (void) getData
{
    [SVProgressHUD showWithStatus:k_Status_GetVerifyCode];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,k_url_get_code];
    
    NSDictionary *paramDict = @{
                                @"AddressId":self.Id,
                                @"UsrId":ApplicationDelegate.userInfo.user_Id
                                };
    NSLog(@"%@用户编号",ApplicationDelegate.userInfo.user_Id);
    
    [ApplicationDelegate.httpManager POST:urlStr parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
            NSLog(@"地址详细%@",jsonDic);
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                //成功返回
                [SVProgressHUD showSuccessWithStatus:@"取得地址详细信息"];
                
            } else  {
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

/**
 *  获取地址信息
 */
- (void) AddData
{
    [SVProgressHUD showWithStatus:k_Status_GetVerifyCode];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,k_url_AddAddress];
    NSString * defaulStr;
    if(SwcIsDefault.on)
    {
       defaulStr = @"True";
    }else
    {
        defaulStr = @"False";
    }
    
//去掉省，市，区 空值
    NSString *pStr;
    NSString *ciStr;
    NSString *coStr;
    if(_provinceID)
    {
        pStr =_provinceID;
    }else
    {
        pStr = @"";
    }
    
    if(_cityID)
    {
        ciStr =_cityID;
    }else
    {
        ciStr = @"";
    }
    
    if(_countryID)
    {
        coStr =_countryID;
    }else
    {
        coStr = @"";
    }
    
    
    NSDictionary *paramDict = @{
                                @"DicProvincialId":pStr,//省
                                @"DicCityId":ciStr,//市
                                @"DicDistrictId":coStr,//区
                                @"DetailAddress":txtAddressDetail.text,
                                @"ZipCode":@"",
                                @"Name":txtName.text,
                                @"Telephone":txtTel.text,
                                @"IsDefault":defaulStr,
                                @"UsrId":ApplicationDelegate.userInfo.user_Id
                                };
    NSLog(@"%@用户编号",ApplicationDelegate.userInfo.user_Id);
    
    [ApplicationDelegate.httpManager POST:urlStr parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
            NSLog(@"地址详细%@",jsonDic);
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                //成功返回
                
                [SVProgressHUD showSuccessWithStatus:@"地址添加成功"];
                
            } else  {
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

/**
 *  取得区省信息字典
 */
- (void) getAreaData
{
    [SVProgressHUD showWithStatus:k_Status_GetVerifyCode];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,k_url_Dic_GetProvincial];
    
    NSDictionary *paramDict = @{
                                
                                };
    
    [ApplicationDelegate.httpManager POST:urlStr parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                //成功返回
                _province =jsonDic[@"Data"];
                [self.pickerView reloadAllComponents]; //取得数据后，重新加载
                //[SVProgressHUD showSuccessWithStatus:@"地址添加成功"];
                
            } else  {
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
