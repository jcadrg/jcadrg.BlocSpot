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




@interface CallOutInnerView : UIView

@property(nonatomic, strong) UILabel *descriptionLabel;
@property(nonatomic, strong) UILabel *categoryLabel;

@property(nonatomic, strong) id<MKAnnotation> annotations;


-(id) initForAnnotation:(id<MKAnnotation>) annotation;


@end
