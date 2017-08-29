//
//  ServicePaoView.m
//  Artisan
//
//  Created by cguo on 2017/7/5.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "ServicedateilView.h"
#import "ServicePaoView.h"

#define kWidth  40.f
#define kHeight 40.f

#define kHoriMargin 8.f
#define kVertMargin 8.f

#define kPortraitWidth  30.f
#define kPortraitHeight 30.f

#define kCalloutWidth   100.0
#define kCalloutHeight  40.0

@interface ServicePaoView ()

@property(nonatomic,strong)UIImageView *BGimageView;

@property(nonatomic,strong,readwrite)ServicedateilView *dateilView;


@end
@implementation ServicePaoView



-(void)setBgImage:(UIImage *)bgImage
{
    _bgImage=bgImage;
    self.BGimageView.image=_bgImage;
}



- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.dateilView == nil)
        {
            
            /* Construct custom callout. */
            self.dateilView = [[ServicedateilView alloc] initWithFrame:CGRectMake(0, 0, 30 , kCalloutHeight)];
            self.paopaoView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                 -CGRectGetHeight(self.paopaoView.bounds) / 2.f + self.calloutOffset.y);
            
            self.dateilView.BgImageView.image = [UIImage imageNamed:@"mapPao.png"];
            
            self.dateilView.titleLbl.text=self.annotation.title;
            self.dateilView.menoryLbl.text=self.annotation.subtitle;
            
        }
        
        [self addSubview:self.paopaoView];
    }
    else
    {
        [self.paopaoView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.paopaoView pointInside:[self convertPoint:point toView:self.paopaoView] withEvent:event];
    }
    
    return inside;
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self initPaoPao];
        
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
          [self initPaoPao];
    }
    return self;
}

-(void)initPaoPao
{
//    self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
//    [self setBounds:CGRectMake(0.f, 0.f, kWidth, kHeight)];
    
    [self setFrame:CGRectMake(0.f, 0.f, kWidth, kHeight)];
    
    self.backgroundColor = [UIColor orangeColor];
    
    /* Create portrait image view and add to view hierarchy. */
    self.BGimageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHoriMargin, kVertMargin, kPortraitWidth, kPortraitHeight)];
    self.BGimageView.image=[UIImage imageNamed:@"mapPao"];
    
    [self addSubview:self.BGimageView];

}
@end



