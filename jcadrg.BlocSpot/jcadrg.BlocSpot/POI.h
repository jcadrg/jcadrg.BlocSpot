//
//  POI.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/20/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Annotation.h"
#import "Categories.h"

#import "CategoryButton.h"

@interface POI : NSObject

@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, assign) BOOL visitState;

@property (nonatomic, strong) Categories *category;
@property (nonatomic, strong) Annotation *annotation;


@property (nonatomic, assign) VisitButtonSelected buttonState;


-(instancetype) initWithDictionary:(NSDictionary *)mediaDictionary;

@end
