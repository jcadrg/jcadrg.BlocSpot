//
//  Categories.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/23/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "Categories.h"

@implementation Categories

-(instancetype) initWithName:(NSString *)categoryName withColor:(UIColor *)color{
    if (self) {
        self.categoryName = categoryName;
        self.categoryColor = color;
        
    }
    
    return self;
}

@end
