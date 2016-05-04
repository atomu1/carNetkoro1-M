//
//  PictureInfController.m
//  CLWsdht
//
//  Created by OYJ on 16/4/10.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "PictureInfController.h"

@interface PictureInfController ()

@end

@implementation PictureInfController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.scrollView.frame=CGRectMake(0,0,SCREEN_WIDTH, SCREEN_WIDTH-44-20-50);
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    for (int i=0;  i<self.imageArray.count; i++) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[self.imageArray objectAtIndex:i] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.1*0.5, 10+i*260, SCREEN_WIDTH*0.9, 250)];
            imageView.image=image;
            [self.view addSubview:imageView];
            
        }];
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

@end
