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



-(instancetype) init{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

@end
