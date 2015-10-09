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
#import "POI.h"


typedef void (^SearchListCompletionBlock)(NSArray *locations, NSError *error);

@interface DataSource : NSObject {
    NSString *_annotationsPath;
    NSString *_categoriesPath;
    NSString *_distanceValuesPath;
}

+(instancetype) sharedInstance;


@property (nonatomic, weak, readonly) NSArray *annotations;
@property (nonatomic, weak, readonly) NSArray *categories;
@property (nonatomic, weak, readonly) NSDictionary *distanceValuesDictionary;


// To be implemented on the data regarding the list of venues
+(void)fetchPlacesWithName:(NSString *)searchTerm withLocationCoordinate:(CLLocationCoordinate2D *)coordinate completion:(SearchListCompletionBlock)completionHandler;


// KVO METHODS
-(void)deleteCategories:(Categories *)category;
-(void)addCategories:(Categories *)category;

-(void)addPOI:(POI *)poi;
-(void)deletePOI:(POI *)poi;
-(void)replaceAnnotation:(POI *)poi withOtherPOI:(POI *)otherPOI;

-(void)toggleVisitedOnPOI:(POI *)poi;
-(void)addPOI:(POI *)poi toCategoryArray:(Categories *)category;
-(void)addDictionary:(NSDictionary *)dic;

@end
