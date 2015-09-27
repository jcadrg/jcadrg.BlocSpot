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
    }
    
    return self;
}

@end
