//
//  ServiceMapViewController.m
//  Artisan
//
//  Created by cguo on 2017/7/3.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "MapViewController.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
//#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import "ServicePaoView.h"
#import "ServicedateilView.h"
#define kCalloutViewMargin   -8

@interface MapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>

{
    BMKMapView *_mapView;//地图对象
    BMKLocationService *_locationService;//定位
    BMKGeoCodeSearch  *_geoCodeSearch;
    BMKReverseGeoCodeOption * _reverseGeoCodeOption;
    BMKPointAnnotation* pointAnnotation;
    BMKPointAnnotation* animatedAnnotation;
    
}
@property(nonatomic,strong)NSArray *AnnotationArr;
@property(nonatomic,strong)UIButton *mapPin;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [_mapView addAnnotations:_AnnotationArr];
    
    //    [self addMap];
    //添加气泡
    //    [self addPaoPaoView];
    
    
}

-(void)TypeChange:(NSNotification*)noti
{
    NSDictionary *dic=noti.userInfo;
    
    NSLog(@"%@",dic);
    
    if ([dic[@"IsShow"] isEqual:@(0)]) {
        NSLog(@"当前显示的是地图视图");
    }
}



-(void)addPaoPaoView:(CLLocationCoordinate2D)location
{
    //接口获取数据
    //    location.longitude//纬度
    //    location.latitude//经度
    //   BMKPointAnnotation* pointAnnotation = [[BMKPointAnnotation alloc]init];
    //    CLLocationCoordinate2D coor;
    //    coor.latitude = location.latitude+0.08;
    //    coor.longitude =  location.longitude+0.08;
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    item.coordinate = location;
    item.title = @"哇哈哈";
    item.subtitle=@"找到了一只猪，20元";
    
    [_mapView addAnnotation:item];
}


//添加标注
- (void)addPointAnnotation:(CLLocationCoordinate2D)location
{
    if (pointAnnotation == nil) {
        pointAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = location.latitude+0.08;
        coor.longitude =  location.longitude+0.08;
        pointAnnotation.coordinate = coor;
        pointAnnotation.title = @"天安门";
        pointAnnotation.subtitle = @"东长安街";
    }
    [_mapView addAnnotation:pointAnnotation];
}

// 添加动画Annotation
- (void)addAnimatedAnnotation {
    if (animatedAnnotation == nil) {
        animatedAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = 40.115;
        coor.longitude = 116.404;
        animatedAnnotation.coordinate = coor;
        animatedAnnotation.title = @"空调维修";
        animatedAnnotation.subtitle = @"111元";
    }
    [_mapView addAnnotation:animatedAnnotation];
}


-(void)addMap
{
    
    
    BMKMapView  *mapView=[[ BMKMapView alloc] initWithFrame:self.view.bounds];
    mapView.mapType=BMKMapTypeStandard;
    mapView.userTrackingMode=BMKUserTrackingModeFollow;
    mapView.zoomLevel=20;
    mapView.minZoomLevel=10;
    mapView.delegate=self;
    _mapView=mapView;
    [self.view addSubview:_mapView];
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(20, _mapView.bounds.size.height-50, 30, 30)];
    [btn setImage:[UIImage imageNamed:@"Location"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(UpdateLocation) forControlEvents:UIControlEventTouchDown];
    [_mapView addSubview:btn];
    _mapPin=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0, 20 , 20)];
    [_mapPin setImage:[UIImage imageNamed:@"serach_Map"] forState:UIControlStateNormal];
    
    [_mapView addSubview:_mapPin];
    [_mapView bringSubviewToFront:_mapPin];
    
       //精度圈不显示
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
    
    [_mapView updateLocationViewWithParam:displayParam];
    [self initlocationService];
}
//刷新当前位置
-(void)UpdateLocation
{
    [_locationService startUserLocationService];
}
#pragma mark --private Method--定位
-(void)initlocationService{
    
    _locationService=[[BMKLocationService alloc] init];
    _locationService.desiredAccuracy=kCLLocationAccuracyBest;
    _locationService.delegate=self;
    _locationService.distanceFilter=1000;
    [_locationService startUserLocationService];
    
}
/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    ServicePaoView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable =YES;
    
    annotationView.image=[UIImage imageNamed:@"pig"];
    
    return annotationView;
    
    
    /*
     
     //动画annotation
     NSString *AnnotationViewID = @"AnimatedAnnotation";
     MyAnimatedAnnotationView *annotationView = nil;
     if (annotationView == nil) {
     annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
     }
     NSMutableArray *images = [NSMutableArray array];
     for (int i = 1; i < 4; i++) {
     UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"poi_%d.png", i]];
     [images addObject:image];
     }
     annotationView.annotationImages = images;
     return annotationView;
     
     return nil;
     */
}

/**
 * 当选中一个annotation views时，调用此接口
 * @param mapView 地图View
 * @param view 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    if ([view isKindOfClass:[ServicePaoView class]]) {
        ServicePaoView *cusView = (ServicePaoView *)view;
        CGRect frame = [cusView convertRect:cusView.paopaoView.frame toView:_mapView];
        
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin));
        
        if (!CGRectContainsRect(_mapView.frame, frame))
        {
            /* Calculate the offset to make the callout view show up. */
            CGSize offset = [self offsetToContainRect:frame inRect:_mapView.frame];
            
            CGPoint theCenter = _mapView.center;
            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
            
            CLLocationCoordinate2D coordinate = [_mapView convertPoint:theCenter toCoordinateFromView:_mapView];
            
            [_mapView setCenterCoordinate:coordinate animated:YES];
        }
        
    }
}
- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}
/**
 *  选中气泡调用方法
 *  @param mapView 地图
 *  @param view    annotation
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    
    NSLog(@"选中了气泡，跳到服务详情的页面");
    
    
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    
    
    
    _mapView.showsUserLocation=YES;
    [_mapView updateLocationData:userLocation];
    [_mapView setCenterCoordinate:userLocation.location.coordinate];
    [_locationService stopUserLocationService];
    NSLog(@"%@",userLocation.location);
    //    CLLocationCoordinate2D location = userLocation.location.coordinate;
    //    location.longitude//纬度
    //    location.latitude//经度
    
    [self addPaoPaoView:userLocation.location.coordinate];
    //    [self addPointAnnotation:userLocation.location.coordinate];
    
}



#pragma mark BMKMapViewDelegate--地图移动时会调用这个方法
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //屏幕坐标转地图经纬度
    CLLocationCoordinate2D MapCoordinate=[_mapView convertPoint:_mapPin.center toCoordinateFromView:_mapView];
    
    //拿到地图中心点的位置坐标信息
    NSLog(@"%f---%f",MapCoordinate.latitude,MapCoordinate.longitude);
    //       [self addPointAnnotation:MapCoordinate];
    [self addPaoPaoView:MapCoordinate];
    
}
/**
 *地图渲染完毕后会调用此接口
 *@param mapView 地图View
 */
- (void)mapViewDidFinishRendering:(BMKMapView *)mapView
{
    
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [self addMap];
    
  
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _mapView=nil;
}


@end
