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
    NSString *_path;
    NSMutableArray *_annotation;
    
    NSString *_categoryPath;
    NSMutableArray *_category;
    NSMutableArray *_categoryPOI;
}

+(instancetype) sharedInstance;

@property (nonatomic, strong) NSMutableArray *annotation;
@property (nonatomic, strong) NSString *path;
//@property (nonatomic, strong) POI *poi;

+(void) getLocationWithName:(NSString *) searchTerm withLocationCoordinate:(CLLocationCoordinate2D *) coordinate completion:(SearchListCompletionBlock)completionHandler;
-(NSArray *)annotation;
-(void) addPOI:(POI *)poi;
-(NSArray *)category;
-(NSArray *)categoryPOI;

//-(void) saveToDisk;
-(void) addCategory:(Categories *) categories;
-(void) removeCategory:(Categories *) categories;
-(void) removePOI:(POI *) poi;
-(void) category:(Categories *)categories addPOI:(POI *) poi;
-(void) addPOI:(POI *)poi toArray:(NSMutableArray *) categoryArray;

//-(void) createAnnotation;

@end
