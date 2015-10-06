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
        self.latitude = self.coordinate.latitude;
        self.longitude = self.coordinate.longitude;
        
        self.title = @"Title";
    }
    
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.latitude = [aDecoder decodeFloatForKey:@"latitude"];
        self.longitude = [aDecoder decodeFloatForKey:@"longitude"];
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeFloat:self.latitude forKey:@"latitude"];
    [aCoder encodeFloat:self.longitude forKey:@"longitude"];
}


@end
