//
//   UserRespondDemandModel.h
//   CLWsdht
//
//   Created by clish on 16/4/16.
//   Copyright © 2016年 时代宏图. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRespondDemandModel : NSObject

@property (nonatomic ,copy) NSString * AddDate ;
@property (nonatomic ,copy) NSString * DelFlg  ;
@property (nonatomic ,copy) NSString * DemandId  ;
@property (nonatomic ,copy) NSString * DemandTitle  ;
@property (nonatomic ,copy) NSString * Description ;
@property (nonatomic ,copy) NSString * Id  ;
@property (nonatomic ,copy) NSString * Img  ;
@property (nonatomic ,copy) NSString * PartsId ;
@property (nonatomic ,copy) NSString * PartsName  ;
@property (nonatomic ,copy) NSString * PartsPrice  ;
@property (nonatomic ,copy) NSString * Price ;
@property (nonatomic ,copy) NSString * StoreName  ;
@property (nonatomic ,copy) NSString * Url ;
@property (nonatomic ,copy) NSString * UsrStoreId  ;
-(UserRespondDemandModel *) initWithNSDictionary: (NSDictionary *) dic;
@end
//
//
//@property (nonatomic ,copy) NSString * AddDate = "2016-04-13T16:12:01.89";
//@property (nonatomic ,copy) NSString * DelFlg = 0;
//@property (nonatomic ,copy) NSString * DemandId = "6d458b65-3507-42f0-bdc9-c643d8b11ace";
//@property (nonatomic ,copy) NSString * DemandTitle = "\U6c42\U8d2d\U5965\U8fea\U7684\U65cb\U94ae";
//@property (nonatomic ,copy) NSString * Description = "";
//@property (nonatomic ,copy) NSString * Id = "dd7f7563-88f9-47b1-bce6-6acec496a868";
//@property (nonatomic ,copy) NSString * Img = "936d7812-1432-4880-b2fc-b28c3ab28179";
//@property (nonatomic ,copy) NSString * PartsId = "5a9bd77f-e81f-421c-a734-b2954bcfba9e";
//@property (nonatomic ,copy) NSString * PartsName = "VOGUE TYRE \U91d1\U8fb9\U8f6e\U80ce 205/55R16 SC08 91H \U901f\U817e \U8fc8\U817e \U9ad8\U5c14\U592b \U5e15\U8428\U7279\U9002\U914d";
//@property (nonatomic ,copy) NSString * PartsPrice = 123;
//@property (nonatomic ,copy) NSString * Price = 365;
//@property (nonatomic ,copy) NSString * StoreName = "\U674e\U78ca\U7684\U914d\U4ef6\U5e97";
//@property (nonatomic ,copy) NSString * Url = "http://115.28.133.3:9456/Att/Img/936d7812-1432-4880-b2fc-b28c3ab28179.jpg";
//@property (nonatomic ,copy) NSString * UsrStoreId = "c89d324f-c116-4344-8dbd-181bdf0785b2";
