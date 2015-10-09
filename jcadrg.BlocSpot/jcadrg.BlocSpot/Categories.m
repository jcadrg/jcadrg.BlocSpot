//
//  Categories.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/23/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "Categories.h"

@implementation Categories


-(instancetype)initWithDictionary:(NSDictionary *)categoryDictionary{
    if (self){
        
        self.categoryName = categoryDictionary[@"categoryName"];
        self.color = categoryDictionary[@"categoryColor"];
        //        self.isSelected = categoryDictionary[@"selected"];
        self.poi = categoryDictionary[@"poi"];
        
        //Use later!
        
        //self.categoryDictionaryAccessor = categoryDictionary;
        
    }
    
    return self;
}



#pragma mark NSCoding


-(id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        self.categoryName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(categoryName))];
        self.color = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(color))];
        self.poi = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(poi))];
        
        
        
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.categoryName forKey:NSStringFromSelector(@selector(categoryName))];
    [aCoder encodeObject:self.color forKey:NSStringFromSelector(@selector(color))];
    [aCoder encodeObject:self.poi forKey:NSStringFromSelector(@selector(poi))];
    

    
}


@end
