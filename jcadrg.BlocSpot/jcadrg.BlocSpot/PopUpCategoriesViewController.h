//
//  PopUpCategoriesViewController.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 10/7/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "CategoryViewController.h"

@class PopUpCategoriesViewController;

@protocol  PopUpCategoriesViewControllerDelegate <NSObject>

-(void) getSelectedCategories:(NSArray *) categories andProceed:(BOOL) proceed;

@end


@interface PopUpCategoriesViewController : CategoryViewController

@property (nonatomic, strong) NSObject <PopUpCategoriesViewControllerDelegate> *popupDelegate;

@property (nonatomic, strong) NSArray *filteredCategories;


@end
