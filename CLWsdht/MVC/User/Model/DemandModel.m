//
//  DemandModel.m
//  CLWsdht
//
//  Created by clish on 16/4/14.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "DemandModel.h"

@implementation DemandModel
-(DemandModel *) initWithNSDictionary: (NSDictionary *) dic
{
    if(self==nil)
    {
        self = [[DemandModel alloc]init];
    }
    self.Id = dic[@"Id"];
    self.UsrId= dic[@"UsrId"];
    self.CarModelId= dic[@"CarModelId"];
    self.PartsTypeId= dic[@"PartsTypeId"];
    self.Cnt= dic[@"Cnt"];
    self.Year= dic[@"Year"];
    self.EndDate= dic[@"EndDate"];
    self.State= dic[@"State"];
    self.AddDate= dic[@"AddDate"];
    self.Description= dic[@"Description"];
    self.Views= dic[@"Views"];
    self.CarBrandId= dic[@"CarBrandId"];
    self.PartsUseForId= dic[@"PartsUseForId"];
    self.UsrName= dic[@"UsrName"];
    self.CarBrandName= dic[@"CarBrandName"];
    self.CarModelName= dic[@"CarModelName"];
    self.PartsUseForName= dic[@"PartsUseForName"];
    self.PartsTypeName= dic[@"PartsTypeName"];
    self.Img= dic[@"Img"];
    self.ProvincialName= dic[@"ProvincialName"];
    self.CityName= dic[@"CityName"];
    self.Title= dic[@"Title"];
    self.Displacement= dic[@"Displacement"];
    self.ProvincialId= dic[@"ProvincialId"];
    self.CityId= dic[@"CityId"];
    self.Mobile= dic[@"Mobile"];
    self.Enable= dic[@"Enable"];
    self.RespondId= dic[@"RespondId"];
    self.Reason= dic[@"Reason"];

    return  self;
}
@end
