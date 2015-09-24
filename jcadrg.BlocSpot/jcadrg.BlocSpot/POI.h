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

@interface POI : NSObject

@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, assign) BOOL visitState;
@property (nonatomic, assign) CLLocation *location;
@property (nonatomic, strong) NSString *category;


-(instancetype) initWithDictionary:(NSDictionary *)mediaDictionary;

@end
