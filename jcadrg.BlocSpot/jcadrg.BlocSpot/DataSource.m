//
//  DataSource.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/20/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "DataSource.h"

@interface DataSource ()

@end

@implementation DataSource


//Implementation of data source similar as Blocstagram

+(instancetype) sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];

    });
    
    return sharedInstance;
}



-(id) init{
    self = [super init];
    if (self) {
        
        NSString *directory =nil;
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        directory = [path objectAtIndex:0];
        _path = [directory stringByAppendingPathComponent:@"poi.dat"];
        _categoryPath = [directory stringByAppendingPathComponent:@"categories_path.dat"];
        NSLog(@"Saving bookmarks in %@", _path);
        NSLog(@"Saving categories in %@", _categoryPath);
        
    }
    
    return self;
}

-(void) loadPOI{
    _annotation = [NSKeyedUnarchiver unarchiveObjectWithFile:_path];
    if (!_annotation) {
        _annotation = [NSMutableArray array];
    }
}

-(void) loadCategory{
    _category = [NSKeyedUnarchiver unarchiveObjectWithFile:_categoryPath];
    if (!_category) {
        _category = [NSMutableArray array];
    }
}

-(NSArray *) annotation{
    if (!_annotation) {
        [self loadPOI];
    }
    
    return _annotation;
}

-(NSArray *) category{
    if (!_category) {
        [self loadCategory];
    }
    return _category;
}

-(void) addPOI:(POI *)poi{
    if (!_annotation) {
        [self loadPOI];
        NSLog(@"Adding Point of Interest: [name: %@] [description: %@] [annotation: %@] [category name: %@] [category color: %@]", poi.locationName, poi.note, poi.annotation, poi.category.categoryName, poi.category.color);
        
        [_annotation addObject:poi];
        [NSKeyedArchiver archiveRootObject:_annotation toFile:_path];
        NSLog(@"Annotations: %@", _annotation);
    }
}


-(void) addPOI:(POI *)poi toCategoryArray:(Categories *)category{
    
    [category.pointsOfInterest addObject:poi];
    
}

-(void) addCategory:(Categories *)categories{
    [self loadCategory];
    
    [_category addObject:categories];
    [NSKeyedArchiver archiveRootObject:_category toFile:_categoryPath];
}

    //Removing objects

-(void) removeCategory:(Categories *)categories{
    [self loadCategory];
    
    [_category removeObject:categories];
    [NSKeyedArchiver archiveRootObject:_category toFile:_categoryPath];
}

-(void) removePOI:(POI *)poi{
    [self loadCategory];
    [_annotation removeObject:poi];
    [NSKeyedArchiver archiveRootObject:_annotation toFile:_path];
}






@end
