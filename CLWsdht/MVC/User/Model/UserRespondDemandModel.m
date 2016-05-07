//
//  UserRespondDemandModel.m
//  CLWsdht
//
//  Created by clish on 16/4/16.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "UserRespondDemandModel.h"

@implementation UserRespondDemandModel
-(UserRespondDemandModel *) initWithNSDictionary: (NSDictionary *) dic
{
    if(self==nil)
    {
        self = [[UserRespondDemandModel alloc]init];
    }

    self.AddDate =      dic[@"AddDate"];
    self.DelFlg  =      dic[@"DelFlg"];
    self.DemandId =     dic[@"DemandId"];
    self.DemandTitle =  dic[@"DemandTitle"];
    self.Description =  dic[@"Description"];
    self.Id =           dic[@"Id"];
    self.Img  =         dic[@"Img"];
    self.PartsId =      dic[@"PartsId"];
    self.PartsName =    dic[@"PartsName"];
    self.PartsPrice =   dic[@"PartsPrice"];
    self.Price =        dic[@"Price"];
    self.StoreName  =   dic[@"StoreName"];
    self.Url =          dic[@"Url"];
    self.UsrStoreId =   dic[@"UsrStoreId"];
    return  self;
}
@end
