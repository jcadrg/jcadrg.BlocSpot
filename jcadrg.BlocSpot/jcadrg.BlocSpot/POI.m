//
//  POI.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/20/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "POI.h"

@implementation POI

-(instancetype) initWithDictionary:(NSDictionary *)poiDictionary{
    self = [super init];
    if (self) {
        self.locationName = poiDictionary[@"locationName"];
        self.note = poiDictionary[@"notes"];
        self.category = poiDictionary[@"category"];
        //self.location = poiDictionary[@"location"];
        self.annotation = poiDictionary[@"annotation"];
        
        self.buttonState = self.visitState ? VisitButtonSelectedYES : VisitButtonSelectedNO;
        
        NSLog(@"POIDictionary =%@", poiDictionary);

    }
    
    return self;
}


#pragma mark - NSCoding for data persistance

-(instancetype) initWithCoder:(NSCoder *) aDecoder{
    if (self) {
        self.locationName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(locationName))];
        self.note=[aDecoder decodeObjectForKey:NSStringFromSelector(@selector(note))];
        self.category=[aDecoder decodeObjectForKey:NSStringFromSelector(@selector(category))];
        //self.location=[aDecoder decodeObjectForKey:NSStringFromSelector(@selector(location))];
        self.annotation = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(annotation))];

        self.buttonState = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(buttonState))];
    }
    
    return self;
    
}

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.locationName forKey:NSStringFromSelector(@selector(locationName))];
    [aCoder encodeObject:self.note forKey:NSStringFromSelector(@selector(note))];
    [aCoder encodeObject:self.category forKey:NSStringFromSelector(@selector(category))];

    [aCoder encodeObject:self.annotation forKey:NSStringFromSelector(@selector(annotation))];
    [aCoder encodeInteger:self.buttonState forKey:NSStringFromSelector(@selector(buttonState))];
}

@end
