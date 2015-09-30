//
//  Categories.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/23/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CategoriesState) {
    CategoriesUnselectedState,
    CategoriesSelectedState
};
@interface Categories : NSObject <NSCoding>

@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, assign) CategoriesState state;
@property (nonatomic, strong) NSArray *selectedCategory;
@property (nonatomic, strong) NSMutableArray *pointsOfInterest;
@property (nonatomic, strong) NSMutableArray *colorList;

@property (nonatomic, strong) UIImageView *categoryImage;


-(instancetype)initWithDictionary:(NSDictionary *)categoryDictionary;

-(UILabel *)returnLabel;

@end
