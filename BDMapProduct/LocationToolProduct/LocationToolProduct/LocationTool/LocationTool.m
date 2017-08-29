//
//  LocationTool.m
//  BusinessiOS
//
//  Created by cguo on 2017/7/29.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "LocationTool.h"
#import <CoreLocation/CLLocationManager.h>


@interface LocationTool ()

@property(nonatomic,assign)BOOL Update;
@property (nonatomic, copy) BMKLocationFinish block;
@end
@implementation LocationTool


+ (instancetype)LocationDelegateWithManager:(BMKLocationService*)locationmanager
                              LocationBlock:(BMKLocationFinish)LocationBlock
{
    return [[[self class]alloc]initLocationDelegateWithManager:locationmanager LocationBlock:LocationBlock];
    
}

-(instancetype)initLocationDelegateWithManager:(BMKLocationService*)locationmanager
                                 LocationBlock:(BMKLocationFinish)LocationBlock
{
    if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法定位" message:@"定位权限被拒绝，请去设置开启" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    if ([CLLocationManager locationServicesEnabled]) {
        // 初始化定位管理器
        locationmanager.desiredAccuracy=kCLLocationAccuracyBest;

        locationmanager.distanceFilter=1000;
        
   
        //这句话ios8以上版本使用
//        [ locationmanager requestAlwaysAuthorization];
        //开始定位
        [ locationmanager startUserLocationService];
        self.block=LocationBlock;
        self.Update=YES;
        //        self.locationmanger=locationmanager;
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法定位" message:@"请检查你的设备是否开启定位功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    return self;
    
}

#pragma mark--定位代理
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    

    if(self.Update)
    {
        if (self.block!=nil) {
            self.block(userLocation);
            self.Update=NO;
        }
       
        
    }

   
}
@end
