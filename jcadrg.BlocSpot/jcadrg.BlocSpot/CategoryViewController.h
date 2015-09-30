//
//  CategoryViewController.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/28/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CategoryViewControllerState) {
    CategoryViewControllerAddCategory,
    CategoryViewControllerShowView
};


@class CategoryViewController, Categories, CategoryTableViewCell;
@protocol CategoryViewControllerDelegate <NSObject>

-(void)didSelectCell:(CategoryTableViewCell *)cell;

-(void)controllerDidDismiss:(CategoryViewController *)controller;
-(void)category:(Categories *)categoriesChosen;

-(void)controllerDidChoose:(UIColor *)color;

-(void)didCompleteWithImageView:(UIImageView *)image;
@end
@interface CategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource >



@property (nonatomic, strong) id <CategoryViewControllerDelegate> delegate;
@property (nonatomic, assign) CategoryViewControllerState state;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *colorsCollectionView;
@property (nonatomic, strong)  NSMutableArray *colorsArray;
@property (nonatomic, strong)  NSMutableArray *colorsArraySimilar;

@property (nonatomic, strong) UIColor *categoryChosenColor;

@property (nonatomic, strong) NSDictionary *categories;

@property (nonatomic, strong) NSMutableArray *categoriesCreated;

@property (nonatomic, strong) NSMutableArray *selectedCategories;
@property (nonatomic, strong) NSMutableArray *selectedCell;




@end