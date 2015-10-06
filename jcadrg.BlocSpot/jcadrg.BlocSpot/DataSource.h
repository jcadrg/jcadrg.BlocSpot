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

@interface DataSource : NSObject{
    /*NSString *_path;
    NSMutableArray *_annotation;
    
    NSString *_categoryPath;
    NSMutableArray *_category;
    NSMutableArray *_categoryPOI;*/
    
    NSString *_annotationPath;
    NSString *_categoriesPath;
}

+(instancetype) sharedInstance;

@property (nonatomic, weak, readonly) NSArray *annotations;
@property (nonatomic, weak, readonly) NSArray *categories;



+(void) getLocationWithName:(NSString *) searchTerm withLocationCoordinate:(CLLocationCoordinate2D *) coordinate completion:(SearchListCompletionBlock)completionHandler;

-(void) deleteCategories:(Categories *)category;
-(void) addCategories:(Categories *)category;
-(void) addPOI:(POI *)poi;

-(void) deletePOI:(POI *)poi;
-(void) replaceAnnotation:(POI *)poi withOtherPOI:(POI *) otherPOI;

-(void) toggleVisitedOnPOI:(POI *) poi;
//-(void) saveToDisk;
//-(void) createAnnotation;

@end
