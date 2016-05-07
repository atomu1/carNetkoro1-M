//
//  ReleaseModel.m
//  CLWsdht
//
//  Created by tom on 16/4/27.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "ReleaseModel.h"
#import "NSJSON+YBClass.h"

@implementation ReleaseModel

- (NSMutableArray *)releaseModelWithDict: (NSDictionary *) dataDict{
    NSString *str = [dataDict objectForKey:@"Data"];
    
    NSArray* arr2 = [NSArray arrayWithJSON:str];
    NSLog(@"arr2 = %@",arr2);
    NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:0];
    for ( NSDictionary *dic1 in arr2)
    {
        ReleaseModel *releaseModel = [[ReleaseModel alloc] init];
        releaseModel.Id = [dic1 objectForKey:@"Id"];
        releaseModel.UsrGarageName = [dic1 objectForKey:@"UsrGarageName"];
        releaseModel.PartsUseFor = [dic1 objectForKey:@"PartsUseFor"];
        releaseModel.Url = [dic1 objectForKey:@"Url"];
        releaseModel.Province = [dic1 objectForKey:@"Province"];
        releaseModel.CityName = [dic1 objectForKey:@"CityName"];
        releaseModel.FuturePrice = [dic1 objectForKey:@"FuturePrice"];
        releaseModel.Mobile = [dic1 objectForKey:@"Mobile"];
        releaseModel.Address = [dic1 objectForKey:@"Address"];
        releaseModel.CityId = [dic1 objectForKey:@"CityId"];
        /*这里把ListModel装到最后要返回的数组mutableArr*/
        [mutableArr addObject:releaseModel];
    }
    
    return mutableArr;
}

@end
