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
        NSLog(@"Saving bookmarks in %@", _path);
        
    }
    
    return self;
}

-(void) loadPOI{
    _annotation = [NSKeyedUnarchiver unarchiveObjectWithFile:_path];
    if (!_annotation) {
        _annotation = [NSMutableArray array];
    }
}

-(NSArray *) annotation{
    if (!_annotation) {
        [self loadPOI];
    }
    
    return _annotation;
}

-(void) addPOI:(POI *)poi{
    if (!_annotation) {
        [self loadPOI];
        NSLog(@"Adding Point of Interest: [name: %@] [description: %@] [annotation: %@]", poi.locationName, poi.note, poi.annotation);
        
        [_annotation addObject:poi];
        [NSKeyedArchiver archiveRootObject:_annotation toFile:_path];
        NSLog(@"Annotations: %@", _annotation);
    }
}



@end
