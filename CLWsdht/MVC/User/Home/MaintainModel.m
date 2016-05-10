//
//  MaintainModel.m
//  CLWsdht
//
//  Created by koroysta1 on 16/4/18.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "MaintainModel.h"

@implementation MaintainModel

- (NSArray *)maintainModelWithDict: (NSDictionary *) dataDict{
    NSDictionary *dic1 = [[NSDictionary alloc] init];
    dic1 = [dataDict objectForKey:@"Data"];
    NSArray *arr1 = [[NSArray alloc] init];
    arr1 = [dic1 objectForKey:@"Data"];
    NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *dic2 in arr1) {
        MaintainModel *maintainModel = [[MaintainModel alloc] init];
        maintainModel.CarBrandId = [dic2 objectForKey:@"CarBrandId"];
        maintainModel.CarBrandName = [dic2 objectForKey:@"CarBrandName"];
        maintainModel.CarModelId = [dic2 objectForKey:@"CarModelId"];
        maintainModel.CarModelName = [dic2 objectForKey:@"CarModelName"];
        maintainModel.GarageMobile = [dic2 objectForKey:@"GarageMobile"];
        maintainModel.GarageName = [dic2 objectForKey:@"GarageName"];
        maintainModel.GarageOrdersAddDate = [dic2 objectForKey:@"GarageOrdersAddDate"];
        maintainModel.GarageOrdersId = [dic2 objectForKey:@"GarageOrdersId"];
        maintainModel.GarageOrdersMobile = [dic2 objectForKey:@"GarageOrdersMobile"];
        maintainModel.GarageOrdersState = [dic2 objectForKey:@"GarageOrdersState"];
        maintainModel.GarageOrdersUsrName = [dic2 objectForKey:@"GarageOrdersUsrName"];
        maintainModel.GaragePrice = [dic2 objectForKey:@"GaragePrice"];
        maintainModel.GarageSerial = [dic2 objectForKey:@"GarageSerial"];
        maintainModel.Message = [dic2 objectForKey:@"Message"];
        maintainModel.PartsList = [dic2 objectForKey:@"PartsLst"];
        maintainModel.UsrGarageId = [dic2 objectForKey:@"UsrGarageId"];
        NSMutableArray *subarr = [[NSMutableArray alloc]init];
        /*这个for循环把当前这个订单的商品装到subarr里，最后赋值给	ListModel.PartsList*/
        for (NSDictionary *dic3 in maintainModel.PartsList){
            GoodModel *goodModel = [[GoodModel alloc] init];
            goodModel.Cnt=[dic3 objectForKey:@"Cnt"];
            goodModel.Url=[dic3 objectForKey:@"Url"];
            goodModel.Name = [dic3 objectForKey:@"Name"];
            goodModel.Id = [dic3 objectForKey:@"Id"];
            goodModel.Img = [dic3 objectForKey:@"Img"];
            goodModel.StoreId = [dic3 objectForKey:@"StoreId"];
            goodModel.StoreName = [dic3 objectForKey:@"StoreName"];
            goodModel.PartsId = [dic3 objectForKey:@"PartsId"];
            goodModel.Price = [dic3 objectForKey:@"Price"];
            goodModel.CurrentPrice = [dic3 objectForKey:@"CurrentPrice"];
            [subarr addObject:goodModel];
        }
        maintainModel.PartsList=subarr;
        /*这里把ListModel装到最后要返回的数组mutableArr*/
        [mutableArr addObject:maintainModel];
    }
    
    return mutableArr;
}
@end
