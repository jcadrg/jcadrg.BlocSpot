//
//  Annotation.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/23/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AnnotationView.h"
//#import "POI.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject<MKAnnotation,NSCoding>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;

-(id) initWithCoordinate:(CLLocationCoordinate2D) coordinate;

//-(id) initWithArray:(NSArray *)array;


@end
