//
//  Annotation.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/23/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate{
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
    }
    
    return self;
}

@end
