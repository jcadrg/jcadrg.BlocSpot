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

@property(nonatomic, strong) UILabel *descriptionLabel;
@property(nonatomic, strong) UILabel *categoryLabel;

@property(nonatomic, strong) UIView *backButtonView;
@property(nonatomic, strong) UIButton *mapDirections;
@property(nonatomic, strong) UIButton *share;
@property(nonatomic, strong) UIButton *deleteButton;

@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIView *div1;
@property(nonatomic, strong) UIButton *visitedIndicatorButton;

-(void) drawInContext:(CGContextRef) context;
-(void) getDrawPath:(CGContextRef) context;

@end


@implementation CallOutView

-(id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.frame = CGRectMake(0,0,CGRectGetWidth(self.bounds)-80,200);
        
        CGRect myFrame = self.frame;
        myFrame.size.width = 40;
        myFrame.size.height = 40;
        self.frame =myFrame;
        
        self.opaque;
    }
    
    return self;
}

-(void) createConstraints{
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_topView, _div1, _visitedIndicatorButton, _descriptionLabel, _categoryLabel, _backButtonView, _mapDirections, _share, _deleteButton);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_descriptionLabel]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topView]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_categoryLabel]-[_backButtonView]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_div1]-|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topView(==44)][_div1(==0.5)][_descriptionLabel]-[_categoryLabel]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topView(==44)][_div1(==0.5)][_descriptionLabel]-[_backButtonView]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewDictionary]];
    
    [self.backButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_mapDirections(==44)][_share(==44)][_deleteButton(==44)]-|"
                                                                                options:kNilOptions
                                                                                metrics:nil
                                                                                  views:viewDictionary]];
    
    [self.backButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mapDirections(==44)]"
                                                                                options:kNilOptions
                                                                                metrics:nil
                                                                                  views:viewDictionary]];
    
    [self.backButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_deleteButton(==44)]"
                                                                                options:kNilOptions
                                                                                metrics:nil
                                                                                  views:viewDictionary]];
    
    
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
