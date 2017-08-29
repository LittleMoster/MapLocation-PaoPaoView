//
//  LocationTool.h
//  BusinessiOS
//
//  Created by cguo on 2017/7/29.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

// 定位完成后的block回调方法
typedef void (^BMKLocationFinish) (BMKUserLocation *userLocation);

@interface LocationTool : NSObject<BMKLocationServiceDelegate>


/**
 *  创建代理对象，便利构造器
 *
 *  @param   locationmanager  定位对象
 *  @param   定位完成后的block回调
 *
 *  @return 实例对象
 */
+ (instancetype)LocationDelegateWithManager:(BMKLocationService*)locationmanager
LocationBlock:(BMKLocationFinish)LocationBlock;

@end
