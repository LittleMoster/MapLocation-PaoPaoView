//
//  ViewController.m
//  MAMapServicesProduct
//
//  Created by cguo on 2017/9/15.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "ViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <MAMapKit/MAMapKit.h>
#import "CustomAnnotationView.h"

@interface ViewController ()<AMapSearchDelegate,MAMapViewDelegate>


@property (nonatomic,strong) MAMapView *mapView;

@property (nonatomic,strong) AMapSearchAPI *aMapSearch;

@property (nonatomic,strong) CLLocation *currentLocation;

@property (nonatomic,strong) CustomAnnotationView *annotationView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title=@"高德地图";
    [self.view addSubview:self.mapView];
    _aMapSearch = [[AMapSearchAPI alloc]init];
    self.aMapSearch.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)completeAdressAction
{
    NSLog(@"点击了地址");
}

-(void)tuanORkuanIntrol
{

    NSLog(@"点击了头像");
}

-(CustomAnnotationView *)annotationView {
    if (!_annotationView) {
        _annotationView = [[CustomAnnotationView alloc]init];
    }
    return _annotationView;
}

-(MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(1, 64, [UIScreen mainScreen].bounds.size.width - 1, [UIScreen mainScreen].bounds.size.height - 64)];
        _mapView.delegate = self;
        _mapView.mapType = MAMapTypeStandard;
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        
    }
    return _mapView;
}

//发起搜索请求
- (void)reGeoAction {
    if (_currentLocation)
    {
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude
                                                    longitude:_currentLocation.coordinate.longitude];
        [_aMapSearch AMapReGoecodeSearch:request];
    }
}

#pragma mark 高德地图回调delegate
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    
    static NSString *reuseIndetifier = @"annotationReuseIndetifier";
    self.annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
    if (_annotationView == nil)
    {
        self.annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
    }
    _annotationView.image = [UIImage imageNamed:@"up_door_pin_image"];
    _annotationView.canShowCallout = NO;
    _annotationView.centerOffset = CGPointMake(0, -18);
    return _annotationView;
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    NSLog(@"%f,%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    
    _currentLocation = [userLocation.location copy];
}

-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    
    if([view.annotation isKindOfClass:[MAUserLocation class]]) {
        [self reGeoAction];
    }
    
    [_annotationView.calloutView.completeAdressBtn setTitle:@"随便写一些描述吧" forState:UIControlStateNormal];
    [_annotationView.calloutView.completeAdressBtn addTarget:self action:@selector(completeAdressAction) forControlEvents:UIControlEventTouchDown];
    [_annotationView.calloutView.tuanORkuanBtn addTarget:self action:@selector(tuanORkuanIntrol) forControlEvents:UIControlEventTouchDown];
    _annotationView.calloutView.recommendExpressLabel.text =@"呵呵哒";
    
}

#pragma mark 高德地图搜索代理
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:
(AMapReGeocodeSearchResponse *)response
{
    
    NSString *title = response.regeocode.addressComponent.city;
    if (title.length == 0)
    {
        title = response.regeocode.addressComponent.province;
    }
    NSLog(@"%@",response.regeocode.addressComponent.adcode);
}


//获取附近POI搜索的结果
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count > 0)
    {
        AMapPOI *poi = response.pois[0];
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        annotation.title = poi.name;
        annotation.subtitle = poi.address;
        [_mapView addAnnotation:annotation];
    }
}


@end
