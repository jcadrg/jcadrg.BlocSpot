//
//  CallOutView.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/29/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "CallOutView.h"
#import "FlatUIKit.h"
#import <QuartzCore/QuartzCore.h>
#define Arrow_height 15

@interface CallOutView()


-(void) drawInContext:(CGContextRef) context;
-(void) getDrawPath:(CGContextRef) context;

@end


@implementation CallOutView

-(id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, -55);
        self.frame = CGRectMake(0, 0, 300, 80);
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - Arrow_height)];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentView];
        
    }
    
    return self;
}



-(void) drawInContext:(CGContextRef)context{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
    
}

-(void) getDrawPath:(CGContextRef)context{
    CGRect rect = self.bounds;
    CGFloat radius = 6.0;
    
    CGFloat minX = CGRectGetMinX(rect),
    midX = CGRectGetMidX(rect),
    maxX = CGRectGetMaxX(rect);
    
    CGFloat minY = CGRectGetMinY(rect),
    maxY = CGRectGetMaxY(rect)-Arrow_height;
    
    CGContextMoveToPoint(context, midX+Arrow_height, maxY);
    CGContextAddLineToPoint(context, midX, maxY+Arrow_height);
    CGContextAddLineToPoint(context, midX-Arrow_height, maxY);
    
    CGContextAddArcToPoint(context, minX, maxY, minX, minY, radius);
    CGContextAddArcToPoint(context, minX, minX, maxX, minY, radius);
    CGContextAddArcToPoint(context, maxX, minY, maxX, maxX, radius);
    CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, radius);
    CGContextClosePath(context);
}

-(void) drawRect:(CGRect)rect{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
