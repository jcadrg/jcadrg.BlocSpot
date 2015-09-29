//
//  Categories.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/23/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CategoryState){
    CategoryUnselectedState,
    CategorySelectedState
};

@interface Categories : NSObject<NSCoding>

@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) UIColor *categoryColor;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) NSArray *selectedCategory;
@property (nonatomic, strong) NSMutableArray *poi;
@property (nonatomic, strong) NSMutableArray *categoryColorsArray;
@property (nonatomic, assign) CategoryState state;

//-(instancetype) initWithName:(NSString *)categoryName withColor:(UIColor *)color;
-(instancetype) iniWithDictionary:(NSDictionary *)categoryDictionary;
-(UILabel *)returnLabel;

@end
