//
//  CategoryViewController.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/28/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CategoriesViewControllerState){
    CategoriesViewControllerAddCategory,
    CategoriesViewControllerShowView
};

@class CategoryViewController;
@class Categories;
@class CategoryTableViewCell;
@protocol CategoryViewControllerDelegate <NSObject>

-(void) didSelectCell:(CategoryTableViewCell *)cell;
-(void) controllerDidDismiss:(CategoryViewController *) controller;
-(void) category:(Categories *) categoryPicked;
-(void) didChoseController:(UIColor *) color;
-(void) didCompleteWithImageView:(UIImageView *)image;

@end


@interface CategoryViewController : UIViewController <UITableViewDataSource, UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) id<CategoryViewControllerDelegate> delegate;
@property (nonatomic, assign) CategoriesViewControllerState state;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *colorCollectionView;
@property (nonatomic, strong) NSMutableArray *colorArray;
@property (nonatomic, strong) NSMutableArray *colorArray2;
@property (nonatomic, strong) NSMutableArray *pickedCategoryColor;

@property (nonatomic, strong) NSDictionary *category;
@property (nonatomic, strong) NSMutableArray *categoriesCreated;
@property (nonatomic, strong) NSMutableArray *categoriesPicked;
@property (nonatomic, strong) NSMutableArray *cellSelected;



@end
