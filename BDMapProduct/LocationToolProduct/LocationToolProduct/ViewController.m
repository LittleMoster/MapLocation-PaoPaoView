//
//  ViewController.m
//  LocationToolProduct
//
//  Created by cguo on 2017/8/29.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "ViewController.h"
#import "LocationTool.h"
#import "LocationCityTool.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>

@interface ViewController ()
@property(nonatomic,strong)LocationCityTool *locationTool;
@property(nonatomic,strong)LocationTool *BMKlocation;//百度定位
@property(nonatomic,strong)CLLocationManager *locationManager;//定位对象
@property(nonatomic,strong)BMKLocationService *locationService;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //开始定位服务---系统自带的定位
    self.locationManager=[[CLLocationManager alloc]init];
//    __block typeof(self)weakSelf=self;
    self.locationTool=[LocationCityTool LocationDelegateWithManager:self.locationManager LocationBlock:^(NSString *city,CLLocationCoordinate2D location) {
        
        NSLog(@"%@--%f---%f",city,location.latitude,location.longitude);
    }];
    self.locationManager.delegate=self.locationTool;
    
    
    //百度地图获取定位的信息
    self.locationService=[[BMKLocationService alloc]init];
    
    self.BMKlocation=[LocationTool LocationDelegateWithManager:self.locationService LocationBlock:^(BMKUserLocation *userLocation) {
        NSLog(@"%.10f",userLocation.location.coordinate.longitude);
        
     
    }];
    self.locationService.delegate=self.BMKlocation;

    
}


-(void)viewDidAppear:(BOOL)animated
{
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
