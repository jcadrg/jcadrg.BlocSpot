//
//  CategoryTableViewCell.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/28/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Categories.h"

typedef NS_ENUM(NSInteger, CategoryTableViewCellState) {
    CategoryTableViewCellStateSelectedYES,
    CategoryTableViewCellStateUnSelectedNOT
};
//@class CategoryTableViewCell;
//@protocol CategoryTableViewCellDelegate <NSObject>

//-(void)didSelectCellWithView:(UIView *)contentView;


//@end
@interface CategoryTableViewCell : UITableViewCell

//@property (nonatomic, assign) id<CategoryTableViewCellDelegate> delegate;

@property (nonatomic, assign) CategoryTableViewCellState state;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UIImageView *tagImageView;
@property (nonatomic, strong) UIImageView *tagImageViewFull;

@property (nonatomic, strong) Categories *category;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *image1;
@property (nonatomic, assign) BOOL isSelected;




@end
