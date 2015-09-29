//
//  CategoryTableViewCell.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/28/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Categories.h"

typedef NS_ENUM(NSInteger, CategoryTableViewCellState){
    CategoryTableViewCellStateSelected,
    CategoryTableViewCellStateUnSelected
};

@class CategoryTableViewCell;

@protocol CategoryTableViewCellDelegate <NSObject>

-(void) didSelectCellWithView:(UIView *) contentView;


@end

@interface CategoryTableViewCell : UITableViewCell

@property(nonatomic, assign) id<CategoryTableViewCellDelegate> delegate;
@property(nonatomic, assign) CategoryTableViewCellState state;
@property(nonatomic, strong) UILabel *categoryLabel;
@property(nonatomic, strong) UIImageView *tagIV;
@property(nonatomic, strong) UIImageView *tagIVFullView;

@property(nonatomic, strong) Categories *category;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) UIImage *image2;
@property(nonatomic, assign) BOOL categorySelected;



@end
