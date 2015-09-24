//
//  DataSource.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/20/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^SearchListCompletionBlock)(NSArray *locations, NSError *error);

@interface DataSource : NSObject

+(instancetype) sharedInstance;

@property (nonatomic, strong) NSMutableArray *annotation;

+(void) getLocationWithName:(NSString *) searchTerm withLocationCoordinate:(CLLocationCoordinate2D *) coordinate completion:(SearchListCompletionBlock)completionHandler;

-(void) createAnnotation;

@end
