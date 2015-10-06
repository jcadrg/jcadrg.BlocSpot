//
//  CallOutInnerView.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 10/1/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"

#import "CategoryButton.h"
#import "POI.h"

@class CallOutInnerView;

@protocol CallOutInnerViewDelegate <NSObject>

-(void)calloutView:(CallOutInnerView *)view didPressVisitedButton:(CategoryButton *)button ;

@end

@interface CallOutInnerView : UIView

@property(nonatomic, strong) NSObject<CallOutInnerViewDelegate> *delegate;

@property(nonatomic, strong) UILabel *descriptionLabel;
@property(nonatomic, strong) UILabel *categoryLabel;

@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) UIImageView *visitIndicatorImage;
@property(nonatomic, strong) CategoryButton *visitIndicatorButton;

@property(nonatomic, strong) POI *poi;

@property(nonatomic, strong) id<MKAnnotation> annotations;

//-(id) initForAnnotation:(id<MKAnnotation>) annotation;
-(void) setVisitIndicatorImage:(UIImageView *)visitIndicatorImage withColor:(UIColor *) color;

@end
