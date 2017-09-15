//
//  CustomAnnotationView.h
//  MAMapServicesProduct
//
//  Created by cguo on 2017/9/15.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"

@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, strong) CustomCalloutView *calloutView;
@end
