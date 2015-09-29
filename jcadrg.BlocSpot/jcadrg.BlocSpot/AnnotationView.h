//
//  AnnotationView.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/23/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "FlatUIKit.h"
#import "TLTagsControl.h"
#import "Categories.h"
#import "POI.h"
#import "DataSource.h"

@class AnnotationView;
@class Categories;

@protocol AnnotationViewDelegate <NSObject>

-(void) customView:(AnnotationView *)view didPressDoneButton:(FUIButton *)button withTitleText:(NSString *)titleText withDescriptionText:(NSString *)descriptionText;
-(void) customViewDidPressAddCategoryView:(AnnotationView *)categoryView;
-(Categories *) categoryPicked;

@end



@interface AnnotationView : UIView<UIGestureRecognizerDelegate>

@property(nonatomic, strong) id<AnnotationViewDelegate> delegate;

@property(nonatomic, strong) POI *poi;
//@property(nonatomic, strong) FUITextField *titleText;
//@property(nonatomic, strong) UITextView *descriptionText;
@property(nonatomic, strong) UIView *tagView;

@property(nonatomic, strong) NSMutableArray *colors;
@property(nonatomic, strong) UIButton *colorPicked;

@property(nonatomic, strong) FUIButton *doneButton;
@property(nonatomic, strong) Categories *category;
@property(nonatomic, strong) TLTagsControl *tagsControl;
@property(nonatomic, strong) UIView *categoryView;
@property(nonatomic, strong) FUIButton *categoryButton;
@property(nonatomic, strong) UILabel *titleLabel;

-(NSAttributedString *)titleLabelStringWithCategory:(NSString *) categoryString withColor:(UIColor *) color;



@end
