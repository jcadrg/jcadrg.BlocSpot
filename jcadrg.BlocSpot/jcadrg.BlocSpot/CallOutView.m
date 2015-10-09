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
        
        /*self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, -55);
        self.frame = CGRectMake(0, 0, 300, 80);*/
        
        //Framing to appropiate values
        
        CGRect frame = self.frame;
        frame.size.width = 40;
        frame.size.height = 40;
        self.frame = frame;
        
        
        /*self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - Arrow_height)];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentView];*/
        
        self.opaque = NO;
        
    }
    
    return self;
}



/*-(void) drawInContext:(CGContextRef)context{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
    
}*/

-(UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView !=nil) {
        [self.superview bringSubviewToFront:self];
    }
    
    return hitView;
}




-(BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if (!isInside) {
        for (UIView *view in self.subviews) {
            isInside = CGRectContainsPoint(view.frame, point);
            if (isInside)
                break;
        }
        

    }
    
    return isInside;
}

-(void) dismiss{
    [self setHidden:YES];
}



@end
