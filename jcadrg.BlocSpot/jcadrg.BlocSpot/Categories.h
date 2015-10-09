//
//  Categories.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/23/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Categories : NSObject <NSCoding>

@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) UIColor *color;

@property (nonatomic, strong) NSMutableArray *poi;

-(instancetype)initWithDictionary:(NSDictionary *)categoryDictionary;


@end
