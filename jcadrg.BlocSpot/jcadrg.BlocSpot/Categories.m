//
//  Categories.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/23/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "Categories.h"

@implementation Categories

-(instancetype) iniWithDictionary:(NSDictionary *)categoryDictionary{
    if (self) {
        self.categoryName = categoryDictionary[@"categoryName"];
        self.categoryColor = categoryDictionary[@"categoryColor"];
        self.poi = categoryDictionary[@"poi"];
    }
    
    return self;
}

#pragma mark - NSCoding

-(id) initWithCoder:(NSCoder *)aDecoder{
    self =[super init];
    if (self) {
        self.categoryName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(categoryName))];
        self.categoryColor = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(categoryColor))];
        self.poi = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(poi))];
        
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.categoryName forKey:NSStringFromSelector(@selector(categoryName))];
    [aCoder encodeObject:self.categoryColor forKey:NSStringFromSelector(@selector(categoryColor))];
    [aCoder encodeObject:self.poi forKey:NSStringFromSelector(@selector(poi))];
}

@end
