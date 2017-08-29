//
//  LocationCityTool.m
//  Artisan
//
//  Created by cguo on 2017/7/20.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "LocationCityTool.h"



@interface LocationCityTool ()

@property(nonatomic,assign)BOOL Update;
@property (nonatomic, copy) LocationFinish block;
@end
@implementation LocationCityTool


+ (instancetype)LocationDelegateWithManager:(CLLocationManager*)locationmanager
                                          LocationBlock:(LocationFinish)LocationBlock
{
    return [[[self class]alloc]initLocationDelegateWithManager:locationmanager LocationBlock:LocationBlock];

}

-(instancetype)initLocationDelegateWithManager:(CLLocationManager*)locationmanager
                             LocationBlock:(LocationFinish)LocationBlock
{
    if ([CLLocationManager locationServicesEnabled]) {
        // 初始化定位管理器
        //locationmanager=[[CLLocationManager alloc]init];
        //locationmanager.delegate=self;
        // 设置定位精确度到千米
        locationmanager.desiredAccuracy=kCLLocationAccuracyKilometer;
        // 设置过滤器为无
        locationmanager.distanceFilter=kCLDistanceFilterNone;
        //这句话ios8以上版本使用
        [ locationmanager requestAlwaysAuthorization];
        //开始定位
        [ locationmanager startUpdatingLocation];
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
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];


    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray*array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            
#warning 不知道为什么会调用多次，所以就弄了个只回调一次；
            if (self.Update) {
                 self.block(city,newLocation.coordinate);
                self.Update=NO;
            }
           
            
               [manager stopUpdatingLocation];
            //
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

@end
