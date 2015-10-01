//
//  ViewController.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/17/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ViewController.h"
#import "UIBarButtonItem+FlatUI.h"
#import "NSString+Icons.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "FlatUIKit.h"
#import "UIPopoverController+FlatUI.h"


#import "POITableViewController.h"
#import "SearchViewController.h"

#import "Annotation.h"
#import "AnnotationView.h"


#import "POI.h"
#import "FPPopoverController.h"
#import "SMCalloutView.h"

#import "CustomIOSAlertView.h"
#import "WYPopoverController.h"

#import "CategoryViewController.h"

#import "CallOutView.h"


typedef NS_ENUM(NSInteger, ViewControllerState){
    ViewControllerStateMapContent, ViewControllerStateAddPOI
};




@interface ViewController () <MKMapViewDelegate, UIViewControllerTransitioningDelegate, UISearchBarDelegate, UISearchControllerDelegate, UITabBarControllerDelegate, UIGestureRecognizerDelegate, AnnotationViewDelegate, WYPopoverControllerDelegate, CategoryViewControllerDelegate>{
    
    CallOutView *_callOutView;
}

@property (nonatomic, strong) MKMapView *mapView;

@property(nonatomic, strong) POITableViewController *poiTableVC;
@property(nonatomic, strong) SearchViewController *searchVC;
@property(nonatomic, strong) NSMutableArray *matchingItems;


@property(nonatomic, strong) UISearchController *searchController;
@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic, strong) CLLocation *currentLocation;
@property(nonatomic, strong) UIBarButtonItem *searchButton;
@property(nonatomic, strong) UIBarButtonItem *filterButton;
@property(nonatomic, strong) UIBarButtonItem *listButton;
@property(nonatomic, strong) UIBarButtonItem *labelButton;

@property(nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property(nonatomic, strong) UILongPressGestureRecognizer *longTapRecognizer;

//@property(nonatomic, strong) AnnotationView *createAnnotation;
@property(nonatomic, strong) POI *poi;
@property(nonatomic, strong) NSMutableDictionary *parameters;
@property(nonatomic, assign) CLLocationCoordinate2D coordinates;
@property(nonatomic, assign) CGPoint point;
@property(nonatomic, strong) MKAnnotationView *annotationView;

//@property(nonatomic, strong) Annotation *customAnnotation;
@property(nonatomic, assign) ViewControllerState state;

@property(nonatomic, strong) CategoryViewController *categoryVC;
@property(nonatomic, strong) CategoryViewController *popup;
@property(nonatomic, strong) WYPopoverController *popover;

@property(nonatomic, strong) Categories *category;
@property(nonatomic, strong) UINavigationController *navVC;
//@property(nonatomic, strong) UIColor *pinColor;
//@property(nonatomic, strong) UIImageView *likeIV;

@property (nonatomic, strong) NSMutableArray *annotationArray;
@property (nonatomic, strong) UIColor *chosenColor;
//@property (nonatomic, assign) BOOL categoryCreated;

//@property (nonatomic, strong) UIImageView *categoryImageView;
//@property (nonatomic, strong) NSMutableArray *imageMutableArray;

@end

static NSString *viewID = @"LikeAnnotation";

@implementation ViewController


-(instancetype) init{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // set the tab bar color
    self.poiTableVC =[[ POITableViewController alloc]init];
    self.navigationItem.hidesBackButton = YES;
    
    // create a mapview
    self.mapView = [[MKMapView alloc]init];
    self.mapView.userInteractionEnabled =YES;
    [self.mapView setDelegate:self];
    [self.view addSubview:self.mapView ];
    self.mapView.showsUserLocation = YES;
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
    self.tapRecognizer.delegate = self;
    self.tapRecognizer.numberOfTapsRequired = 1;
    
    self.longTapRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(addAnnotation:)];
    self.longTapRecognizer.delegate = self;
    self.longTapRecognizer.minimumPressDuration = 0.5;
    [self.mapView addGestureRecognizer:self.longTapRecognizer];
    
    [self.mapView addGestureRecognizer:self.tapRecognizer];
    
    
    self.category = [[Categories alloc] init];
    [self updateLocation];
    [self createConstraints];
    
    [self createTabBarButtons];
    [self createListViewBarButton];
    [self setUpSearchBar];
    
    
    if (!_categoryVC) {
        self.categoryVC = [[CategoryViewController alloc] init];
        self.categoryVC.delegate = self;
    }
    
    if (!_popup) {
        self.popup = [[CategoryViewController alloc] init];
        self.categoryVC.delegate = self;
    }
    
    self.navVC = [[UINavigationController alloc] initWithRootViewController:self.categoryVC];
    UINavigationController *navPopup = [[UINavigationController alloc] initWithRootViewController:self.popup];
    UIBarButtonItem *leftBarPopup = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(popupBarButtonItemDonePressed:)];
    
    self.popup.navigationItem.leftBarButtonItem = leftBarPopup;
    
    if (!_popover) {
        self.popover = [[WYPopoverController alloc] initWithContentViewController:navPopup];
        self.popover.delegate = self;
        self.popover.popoverContentSize = CGSizeMake(self.popover.contentViewController.view.frame.size.width, 44*7 + 20);
    
    }
    
    
    /*for (POI *poi in [DataSource sharedInstance].annotation) {
        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(poi.annotation.latitude, poi.annotation.longitude);
        Annotation *annotation = [[Annotation alloc] initWithCoordinate:coordinates];
        
        [self.mapView addAnnotation:annotation];
    
    }*/
    
    [self.mapView addAnnotations:[self createAnnotations]];
    
    //self.categoryImageView = [[UIImageView alloc] init];
    
    //_annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:viewID];
    
    
    
    /*self.annotationView = (MKAnnotationView*)
    [self.mapView dequeueReusableAnnotationViewWithIdentifier:viewID];*/
    //    self.composePlacesVC = [[BLCComposePlacesViewController alloc]init];
    //    self.popOver = [[WYPopoverController alloc]initWithContentViewController:_composePlacesVC];
    //    self.popOver.delegate = self;
    
    //View that will create a new POI
    
    if (!_createAnnotationView) {
        self.createAnnotationView = [[AnnotationView alloc]init];
        self.createAnnotationView.delegate = self;
        self.state = ViewControllerStateMapContent;
    }
    
    if (!_category) {
        self.category = [[Categories alloc] init];
    }
    
    self.state = ViewControllerStateMapContent;
    if (!self.parameters) {
        self.parameters = [NSMutableDictionary new];
    }

    
}

-(NSMutableArray *) createAnnotations{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    for (POI *poi in [DataSource sharedInstance].annotation) {
        CLLocationCoordinate2D coordinates=CLLocationCoordinate2DMake(poi.annotation.latitude, poi.annotation.longitude);
        poi.annotation = [[Annotation alloc] initWithCoordinate:coordinates];
        [annotations addObject:poi.annotation];
    }
    return annotations;
}

- (void)setUpSearchBar {
    self.searchBar = [[UISearchBar alloc] init];
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
}


-(void)layoutViews {

    
    
    switch (self.state) {
        case ViewControllerStateMapContent: {
            
            [self.createAnnotationView setHidden:YES];
            [self.createAnnotationView resignFirstResponder];
            self.mapView.scrollEnabled = YES;
            [self.navigationController.navigationBar setHidden:NO];
            
        } break;
        case ViewControllerStateAddPOI: {
            
            [self.createAnnotationView removeGestureRecognizer:self.tapRecognizer];
            [self.mapView addSubview:self.createAnnotationView];
            self.createAnnotationView.translatesAutoresizingMaskIntoConstraints = NO;

            [self.createAnnotationView setHidden:NO];
            self.mapView.scrollEnabled = NO;
            [self setLayoutOfCreateAnnotationView];
            [self.navigationController.navigationBar setHidden:YES];
            
            
        } break;
            
    }
    
    
}

// Hide tab bar when lanscape mode


-(void) setLayoutOfCreateAnnotationView
{
    [self.mapView addConstraints:({
        @[ [NSLayoutConstraint
            constraintWithItem:_createAnnotationView
            attribute:NSLayoutAttributeCenterX
            relatedBy:NSLayoutRelationEqual
            toItem:self.mapView
            attribute:NSLayoutAttributeCenterX
            multiplier:1.f constant:0.f],
           
           [NSLayoutConstraint
            constraintWithItem:_createAnnotationView
            attribute:NSLayoutAttributeCenterY
            relatedBy:NSLayoutRelationEqual
            toItem:self.mapView
            attribute:NSLayoutAttributeCenterY
            multiplier:1.f constant:0] ];
    })];
    NSLayoutConstraint *viewHeightConstraint = [NSLayoutConstraint constraintWithItem:_createAnnotationView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0
                                                                             constant:(44*4)+ 100];
    [self.mapView addConstraint:viewHeightConstraint ];
    NSLayoutConstraint *viewWidthConstraint = [NSLayoutConstraint constraintWithItem:_createAnnotationView
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0
                                                                            constant:CGRectGetWidth(self.view.bounds)- 20];
    [self.mapView addConstraint:viewWidthConstraint];
}

-(void) setLayoutCategoriesVC{
    [self.mapView addConstraints:({
        @[ [NSLayoutConstraint
                     constraintWithItem:_categoryVC
                     attribute:NSLayoutAttributeCenterX
                     relatedBy:NSLayoutRelationEqual
                     toItem:self.mapView
                     attribute:NSLayoutAttributeCenterX
                     multiplier:1.f constant:0.f],
           
                    [NSLayoutConstraint
                                 constraintWithItem:_categoryVC
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.mapView
                                 attribute:NSLayoutAttributeCenterY
                                 multiplier:1.f constant:0] ];
        })];
    NSLayoutConstraint *viewHeightConstraint = [NSLayoutConstraint constraintWithItem:_categoryVC
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                     toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1.0
                                                     constant:(44*4)+ 100];
    [self.mapView addConstraint:viewHeightConstraint ];
    NSLayoutConstraint *viewWidthConstraint = [NSLayoutConstraint constraintWithItem:_categoryVC
                                                    attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual
                                                    toItem:nil
                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                    constant:CGRectGetWidth(self.view.bounds)- 20];
    [self.mapView addConstraint:viewWidthConstraint];
}

-(void)createListViewBarButton {
    UILabel *label = [[UILabel alloc]init];
    label.attributedText = [self titleLabelString];
    
    
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGFLOAT_MAX);
    CGSize labelMaxSize = [label sizeThatFits:maxSize];
    
    
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, labelMaxSize.width, labelMaxSize.height)];
    label.frame = CGRectMake(0, 0, labelMaxSize.width, labelMaxSize.height);
    
    [customView addSubview:label];
    _labelButton = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
    UIImage *listImage = [UIImage imageNamed:@"align_justify_filled"];
    self.listButton = [[UIBarButtonItem alloc]initWithImage:listImage
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(listViewPressed:)];
    [_listButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItems = @[_listButton, _labelButton];
    
    [_listButton configureFlatButtonWithColor:[UIColor midnightBlueColor]
                                    highlightedColor:[UIColor wetAsphaltColor]
                                        cornerRadius:3];
    
}

#pragma mark - Overrides

-(void)setState:(ViewControllerState)state animated:(BOOL)animated {
    _state = state;
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self layoutViews];
                         }];
        
    } else {
        [self layoutViews];
    }
    
}
-(void)setState:(ViewControllerState)state{
    [self setState:state animated:NO];
}

#pragma Location delegate methods call

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        self.locationManager=[[CLLocationManager alloc] init];
        self.locationManager.delegate=self;
        
        self.locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
        [self.locationManager requestWhenInUseAuthorization];
    }
    return _locationManager;
}

-(void)updateLocation {
    [self.locationManager startUpdatingLocation];
    
}

-(void)fetchVenuesForLocation:(CLLocation *)location {
    
}

-(void)zoomToLocation:(CLLocation *)location radius:(CGFloat)radius {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, radius*2, radius*2);
    [self.mapView setRegion:region];
    
}


-(NSAttributedString *)titleLabelString  {
    
    NSString *baseString = @"BlocSpot";
    
    NSMutableAttributedString *mutAttString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSForegroundColorAttributeName:[UIColor midnightBlueColor],NSFontAttributeName:[UIFont boldFlatFontOfSize:20]}];
    
    return mutAttString;
    
}

-(void) createTabBarButtons {
    UIImage *searchImage =[UIImage imageNamed:@"search"];
    
    self.searchButton   = [[UIBarButtonItem alloc]initWithImage:searchImage
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(searchButtonPressed:)];
    
    UIImage *filterImage=[UIImage imageNamed:@"sorting_answers_filled"];
    
    
    self.filterButton = [[UIBarButtonItem alloc]initWithImage:filterImage
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(filterButtonPressed:)];
    
    [_filterButton setTintColor:[UIColor whiteColor]];
    [_searchButton setTintColor:[UIColor whiteColor]];
    [_filterButton configureFlatButtonWithColor:[UIColor midnightBlueColor]
                               highlightedColor:[UIColor wetAsphaltColor]
                                   cornerRadius:3];
    [_searchButton configureFlatButtonWithColor:[UIColor midnightBlueColor]
                               highlightedColor:[UIColor wetAsphaltColor]
                                   cornerRadius:3];
    
    [self.navigationItem setRightBarButtonItems:@[_filterButton, _searchButton]];
}


// Setting auto Layout constraints



-(void)createConstraints {
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_mapView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mapView]|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mapView]|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.locationManager = nil;
    
}


-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    
    
    
}

-(void)dealloc{
    self.locationManager = nil;
}


#pragma BLCCustomAnnotationsViewDelegate

-(void)customView:(AnnotationView *)view
didPressDoneButton:(FUIButton *)button
    withTitleText:(NSString *)titleText
withDescriptionText:(NSString *)descriptionText{
    /*[self.createAnnotationView resignFirstResponder];
    self.parameters = [NSDictionary mutableCopy];*/
    
    [self.parameters setObject:titleText forKey:@"location"];
    [self.parameters setObject:descriptionText forKey:@"notes"];
    //[self.parameters setObject:tag forKey:@"category"];
    //[self setState:ViewControllerStateMapContent animated:YES];
    
    Annotation *annotation = [[Annotation alloc] initWithCoordinate:_coordinates];
    [self.parameters setObject:annotation forKey:@"annotation"];
    
    self.poi = [[POI alloc] initWithDictionary:self.parameters];
    
    [[DataSource sharedInstance] addPOI:self.poi];
    
    //self.customAnnotation = [[Annotation alloc]initWithCoordinate:_coordinates];
    //[self.parameters setObject:self.customAnnotation forKey:@"annotation"];
    
    [self setState:ViewControllerStateMapContent animated:YES];
    
    //[self.mapView addAnnotation:self.customAnnotation ];
    
    [self.mapView addAnnotation:annotation];
    
    NSLog(@"parameters = %@", self.parameters);
    
    self.createAnnotationView.titleLabel.attributedText = [self titleLabelString];
    
    /*Categories *category = self.parameters[@"category"];
    [[DataSource sharedInstance] addPOI:self.poi toCategoryArray:category];*/
    
    [[DataSource sharedInstance] addPOI:self.poi toCategoryArray:self.poi.category];
}

-(void)customViewDidPressAddCategoryView:(UIView *)categoryView{
    NSLog(@"tap being fired DELEGATE");
    self.addAnnotationState  =YES;
    
    
    [UIView animateWithDuration:1
          delay:0
          usingSpringWithDamping:.75
          initialSpringVelocity:10
          options:kNilOptions
          animations:^{
              
              [self.navigationController presentViewController:self.navVC animated:NO completion:nil];
              
              

              } completion:^(BOOL finished) {
                  
                  
                  
                  }];
}

#pragma mark CategoriesViewControllerDelegate

-(void)controllerDidDismiss:(CategoryViewController *)controller{
    
    [self.navVC dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)category:(Categories *)categories {
    
    _category = categories;
    
    /*self.imageMutableArray = [NSMutableArray new];
    [self.imageMutableArray addObject:imageView];
    
    self.categoryImageView = [[UIImageView alloc] init];
    
    self.categoryImageView = imageView;*/

    [self.parameters setObject:categories forKey:@"category"];
    
    self.createAnnotationView.titleLabel.attributedText = [self.createAnnotationView titleLabelStringWithCategory:categories.categoryName withColor:categories.color];
    
}


-(void) getImageView:(UIImageView *)imageView{
    
}

-(void) addimageView:(UIImageView *)imageView asSubViewOf:(MKAnnotationView *)annotationView{
    
}



#pragma mark tap gesture recognizer

-(void)tapFired:(UITapGestureRecognizer *)sender{
    [_searchBar resignFirstResponder];
    _searchBar.alpha = 0.0;
    self.navigationItem.titleView = nil;
    self.navigationItem.leftBarButtonItems = @[_listButton, _labelButton];
    self.navigationItem.rightBarButtonItems =@[_filterButton, _searchButton];
    [self setState:ViewControllerStateMapContent animated:NO];
}


-(void) addAnnotation: (UILongPressGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self setState:ViewControllerStateAddPOI animated:YES];
        
        self.point = [sender locationInView:self.mapView];
        self.coordinates = [self.mapView convertPoint:self.point toCoordinateFromView:self.mapView];
        
        /*CLLocation *location = [[CLLocation alloc] initWithLatitude:self.coordinates.latitude longitude:self.coordinates.longitude];
        [self zoomToLocation:location radius:2000];
                                
        
        self.customAnnotation = [[Annotation alloc]initWithCoordinate:_coordinates];
        [self.parameters setObject:self.customAnnotation forKey:@"annotation"];*/
        
        //self.poi = [[POI alloc] initWithDictionary:self.parameters];
        
        //[self.mapView addAnnotation:self.customAnnotation];
        
    }
}

/*-(void)setPoi:(POI *)poi{
    _poi = poi;
    poi = [[POI alloc] initWithDictionary:self.parameters];
}
*/

#pragma mark UITabBar button actions
-(void)searchButtonPressed:(id)sender{
    
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:.75
          initialSpringVelocity:10
                        options:kNilOptions
                     animations:^{
                         _searchBar.alpha = 1.0;
                         
                         
                         self.navigationItem.rightBarButtonItems = nil;
                         self.navigationItem.leftBarButtonItems = nil;
                         self.navigationItem.titleView = _searchBar;
                         [_searchBar becomeFirstResponder];
                         
                         
                         
                     } completion:^(BOOL finished) {
                         
                         
                         
                     }];
}




-(void)listViewPressed:(id)sender{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromLeft;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:self.poiTableVC animated:NO];
    
}
-(void)filterButtonPressed:(id)sender {
    
    [UIView animateWithDuration:1
                          delay:0
                        usingSpringWithDamping:.75
                        initialSpringVelocity:10
                        options:kNilOptions
                     animations:^{
         
         [self.navVC.navigationItem.leftBarButtonItem setEnabled:NO];
         [_popover presentPopoverFromBarButtonItem:self.filterButton
                                permittedArrowDirections:WYPopoverArrowDirectionDown
                               animated:NO];
         
            } completion:^(BOOL finished) {
 
            }];
    
}

-(void)popupBarButtonItemDonePressed:(id)sender{
    [self.popover dismissPopoverAnimated:YES];
}


#pragma mark UISearchBarDelegate methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.9
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0
                        options:kNilOptions
                     animations:^{
                         
                         
                     } completion:^(BOOL finished) {
                         _searchBar.alpha = 0.0;
                         
                         self.navigationItem.titleView = nil;
                         self.navigationItem.leftBarButtonItems = @[_listButton, _labelButton];
                         self.navigationItem.rightBarButtonItems =@[_filterButton, _searchButton];
                         
                     }];
    
    
}

#pragma mark MapViewDelegate
/*
 -(void)mapView:(MKMapView *)mapV didUpdateUserLocation:(MKUserLocation *)userLocation
 {
 NSLog(@"map new location: %f %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
 CLLocationCoordinate2D location = userLocation.coordinate;
 
 MKCoordinateRegion region;
 region.center = location;
 MKCoordinateSpan span;
 span.latitudeDelta=0.1;
 span.longitudeDelta=0.1;
 region.span=span;
 te
 [mapV setRegion:region animated:TRUE];
 }
 */
//
//- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//    MKAnnotationView* newAnnotation = [views firstObject];
//}




#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //MKAnnotationView *pinAnnotation = nil;
    
        if ([annotation isKindOfClass:[MKUserLocation class]])
            return nil;
    
    if ([annotation isKindOfClass:[Annotation class]]) {
        
        _annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:viewID];
        
            _annotationView = [[MKAnnotationView alloc]
                           initWithAnnotation:annotation reuseIdentifier:viewID];
        
            [_annotationView setTintColor:_category.color];
        
            _annotationView.canShowCallout = NO;
        
            //_annotationView.image = _likeIV.image;
            //[_annotationView setTintColor:[UIColor redColor]];
            //_annotationView.annotation = self.customAnnotation;
        
            //_annotationView.tintColor = [UIColor yellowColor];
            //_annotationView.backgroundColor = [UIColor clearColor];
        
            /*[_annotationView addSubview:[self returnImageColored]];
            _annotationView.image = [self returnImageColored].image;*/
        
            [_annotationView addSubview:[self returnImageColored]];
    
    }else{
        
        [mapView.userLocation setTitle:@"I'm here!"];
    }
    
    return _annotationView;
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views{
    NSLog(@"Array of annotation views: %@", views);
    for (MKAnnotationView *view in views) {
        id<MKAnnotation> mp = [view annotation];
        for (POI *poi in [DataSource sharedInstance].annotation) {
            if (poi.annotation == mp) {
                [view setTintColor:poi.category.color];
            }
        }
    }
}

-(UIImageView *) returnImageColored{
    UIImageView *imageView = [UIImageView new];
    UIImage *image = [UIImage imageNamed:@"hearts_filled"];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.image = image;
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    return imageView;
}



/*-(void) mapViewWillStartRenderingMap:(MKMapView *)mapView{
    
    _mapView = mapView;
    
    for (POI *poi in [DataSource sharedInstance].annotation ) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(poi.annotation.latitude, poi.annotation.longitude);
        Annotation *annotation = [[Annotation alloc] initWithCoordinate:coordinate];
        
        //[mapView addAnnotation:annotation];
        _annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                       reuseIdentifier:viewID];
        
        [_annotationView setTintColor:poi.category.color];
        [mapView addAnnotation:annotation];
    }
    
}
*/
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    //SMCalloutView *callOutView = [[SMCalloutView alloc] init];
    //callOutView.contentView = composePlacesVC.view;
    //[callOutView presentCalloutFromRect:self.view.frame inView:mapView constrainedToView:mapView permittedArrowDirections:SMCalloutArrowDirectionUp animated:YES];
    //    self.popOver.popoverContentSize = self.composePlacesVC.view.bounds.size;
    //
    //    [self.popOver presentPopoverFromRect:view.frame
    //                                  inView:mapView
    //                permittedArrowDirections:WYPopoverArrowDirectionAny
    //                                animated:YES
    //                                 options:WYPopoverAnimationOptionScale
    //                              completion:nil];
    
    
    //   EXTERNAL LIBRARY POPOVER
    //    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:composePlacesVC ];
    //    popover.delegate = self;
    //    popover.border = NO;
    //    popover.arrowDirection = FPPopoverArrowDirectionIsVertical(FPPopoverArrowDirectionUp);
    //    popover.origin = view.frame.origin;
    //    //[popover setShadowsHidden:YES];
    //    [popover presentPopoverFromPoint:view.frame.origin];
    
    
    
    
    
}

#pragma mark CLLocationManagerDelegate Methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    [self fetchVenuesForLocation:location];
    [self zoomToLocation:location radius:2000];
    [self.locationManager stopUpdatingLocation];
    
}

@end