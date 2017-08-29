//
//  ServicedateilView.m
//  Artisan
//
//  Created by cguo on 2017/7/26.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "ServicedateilView.h"

@implementation ServicedateilView

//- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
//    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
//    if (self) {
//        //        [self setBounds:CGRectMake(0.f, 0.f, 30.f, 30.f)];
//
//
//        [self initPaoView];
//
//    }
//    return self;
//}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self initPaoView];
    }
    return self;
}
-(void)initPaoView
{
    [self setBounds:CGRectMake(0.f, 0.f, 90.f, 30.f)];
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.BgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    //    self.BgImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.BgImageView];
    
    self.titleLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 45.f, 45.f)];
    self.titleLbl.textAlignment=NSTextAlignmentCenter;
    self.titleLbl.font=[UIFont systemFontOfSize:13];
    [self addSubview:self.titleLbl];
    
    self.menoryLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 45.f, 45.f, 45.f)];
    self.menoryLbl.textAlignment=NSTextAlignmentCenter;
    self.menoryLbl.font=[UIFont systemFontOfSize:13];
    [self addSubview:self.menoryLbl];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"点击了");
}
@end
