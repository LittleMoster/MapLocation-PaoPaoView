//
//  LocationCityTool.h
//  Artisan
//
//  Created by cguo on 2017/7/20.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@class CLLocationManager;
// 定位完成后的block回调方法
typedef void (^LocationFinish) (NSString *city,CLLocationCoordinate2D location);

@interface LocationCityTool : NSObject<CLLocationManagerDelegate>


/**
 *  创建代理对象，便利构造器
 *
 *  @param     定位对象
 *  @param  定位完成后的block回调
 *
 *  @return 实例对象
 */
+ (instancetype)LocationDelegateWithManager:(CLLocationManager*)locationmanager
                              LocationBlock:(LocationFinish)LocationBlock;
@end
