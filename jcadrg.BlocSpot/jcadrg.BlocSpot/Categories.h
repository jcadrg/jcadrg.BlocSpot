//
//  Categories.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/23/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Categories : NSObject

@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) UIColor *categoryColor;
@property (nonatomic, strong) UILabel *categoryLabel;

-(instancetype) initWithName:(NSString *)categoryName withColor:(UIColor *)color;
-(UILabel *)returnLabel;

@end
